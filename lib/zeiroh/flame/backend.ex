defmodule Zeiroh.FLAME.Backend do
  @moduledoc """
  Phoenix **FLAME** backend with Iroh and/or Zenoh membership overlay.

      config :flame, :backend, {Zeiroh.FLAME.Backend,
        provisioner: :local,  # :docker | :fly | :k8s | :ec2
        overlay: :both,
        alpns: ["zeiroh/flame"],
        connect: "tcp/127.0.0.1:7447",
        key: "zeiroh/flame/runners",
        live: false
      }

  `overlay:` `:iroh`, `:zenoh`, or `:both`.

  Local runner plus overlay advertise, or **Crucible** when
  `provisioner` is not `:local` and Crucible is loaded.
  """

  alias Zeiroh.FLAME.Runner

  def init(opts) when is_list(opts) do
    overlay = Keyword.get(opts, :overlay, :both)
    provisioner = Keyword.get(opts, :provisioner, :local)
    _ = start_overlay(overlay, opts)

    case Runner.init(Keyword.merge(opts, overlay: overlay, provisioner: provisioner)) do
      {:ok, state} ->
        state =
          case maybe_crucible_init(provisioner, opts) do
            {:ok, inner} -> Map.put(state, :crucible, inner)
            _ -> state
          end

        :telemetry.execute([:zeiroh, :flame, :init], %{system_time: System.system_time()}, %{
          overlay: overlay,
          provisioner: provisioner
        })

        {:ok, state}
    end
  end

  defp maybe_crucible_init(:local, _opts), do: :skip

  defp maybe_crucible_init(provisioner, opts) do
    if function_exported?(Crucible.FLAME.Backend, :init, 1) do
      Crucible.FLAME.Backend.init(Keyword.put(opts, :driver, provisioner))
    else
      :skip
    end
  end

  def remote_boot(state) do
    provisioner = Map.get(state, :provisioner, :local)

    result =
      if provisioner != :local and is_map(state[:crucible]) and
           function_exported?(Crucible.FLAME.Backend, :remote_boot, 1) do
        Crucible.FLAME.Backend.remote_boot(state.crucible)
      else
        Runner.remote_boot(state)
      end

    case result do
      {:ok, runner, next} ->
        state = Map.merge(state, Map.take(next, [:runner, :node, :machine, :crucible]))
        advertise(state, Map.get(state, :node, Node.self()), runner)
        {:ok, runner, state}

      other ->
        other
    end
  end

  defdelegate remote_spawn_monitor(state, func), to: Runner
  defdelegate system_shutdown(), to: Runner
  defdelegate handle_info(msg, state), to: Runner

  defp start_overlay(:iroh, opts), do: start_iroh(opts)
  defp start_overlay(:zenoh, opts), do: start_zenoh(opts)

  defp start_overlay(:both, opts) do
    start_iroh(opts)
    start_zenoh(opts)
  end

  defp start_overlay(_, opts), do: start_overlay(:both, opts)

  defp start_iroh(opts) do
    unless Process.whereis(Zeiroh.Iroh) do
      Zeiroh.Iroh.start_link(alpns: Keyword.get(opts, :alpns, ["zeiroh/flame"]))
    end
  rescue
    _ -> :ok
  end

  defp start_zenoh(opts) do
    unless Process.whereis(Zeiroh.Zenoh) do
      Zeiroh.Zenoh.start_link(
        connect: Keyword.get(opts, :connect, "tcp/127.0.0.1:7447"),
        key: Keyword.get(opts, :key, "zeiroh/flame/runners"),
        live: Keyword.get(opts, :live, false)
      )
    end
  rescue
    _ -> :ok
  end

  defp advertise(state, node, runner) do
    payload = "#{node} #{inspect(runner)}"
    overlay = Map.get(state, :overlay, :both)

    if overlay in [:zenoh, :both] and Process.whereis(Zeiroh.Zenoh) do
      key = Keyword.get(state.opts, :key, "zeiroh/flame/runners")
      _ = Zeiroh.Zenoh.put(key, payload)
    end

    :ok
  rescue
    _ -> :ok
  end
end
