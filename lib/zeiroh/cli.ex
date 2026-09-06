defmodule Zeiroh.CLI do
  @moduledoc "Standalone CLI (`zeiroh`) and Mix task (`mix zeiroh`)."

  @version Mix.Project.config()[:version]

  @help """
  zeiroh #{@version} — Phoenix FLAME overlay (Iroh / Zenoh)

    zeiroh backends
    zeiroh flame [--overlay iroh|zenoh|both]
    zeiroh version

  Install: mix zeiroh.install   (escript → ~/.local/bin/zeiroh)
  """

  def main(args), do: main(args, halt: !mix?())

  def main(args, opts) do
    _ = Application.ensure_all_started(:zeiroh)

    {parsed, rest, _} =
      OptionParser.parse(args,
        strict: [overlay: :string, help: :boolean, version: :boolean],
        aliases: [h: :help, v: :version]
      )

    result =
      cond do
        parsed[:help] == true ->
          info(@help)
          :ok

        parsed[:version] == true or rest == ["version"] ->
          info("zeiroh #{@version}")
          :ok

        rest == [] ->
          info(@help)
          :ok

        true ->
          dispatch(rest, parsed)
      end

    finish(result, Keyword.get(opts, :halt, false))
  end

  defp dispatch(["backends" | _], _), do: info(inspect(Zeiroh.backends(), pretty: true))

  defp dispatch(["flame" | _], parsed) do
    overlay =
      case parsed[:overlay] || "both" do
        "iroh" -> :iroh
        "zenoh" -> :zenoh
        _ -> :both
      end

    {:ok, state} = Zeiroh.FLAME.Backend.init(overlay: overlay, live: false)
    {:ok, _term, state} = Zeiroh.FLAME.Backend.remote_boot(state)
    parent = self()

    {:ok, _} =
      Zeiroh.FLAME.Backend.remote_spawn_monitor(state, fn ->
        send(parent, :zeiroh_flame)
        :ok
      end)

    receive do
      :zeiroh_flame ->
        info("flame overlay=#{overlay} ok")
        :ok
    after
      2_000 ->
        err("flame timeout")
        {:error, :timeout}
    end
  end

  defp dispatch(_, _) do
    info(@help)
    :ok
  end

  defp info(msg), do: IO.puts(msg)
  defp err(msg), do: IO.puts(:stderr, msg)

  defp mix? do
    Code.ensure_loaded?(Mix.Project) and function_exported?(Mix.Project, :get, 0)
  rescue
    _ -> false
  end

  defp finish(:ok, false), do: :ok
  defp finish({:error, _} = e, false), do: e
  defp finish(:ok, true), do: System.halt(0)
  defp finish(_, true), do: System.halt(1)
end
