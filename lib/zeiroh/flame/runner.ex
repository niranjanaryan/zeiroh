defmodule Zeiroh.FLAME.Runner do
  @moduledoc false

  def init(opts) when is_list(opts) do
    {:ok,
     %{
       opts: opts,
       overlay: Keyword.get(opts, :overlay, :both),
       provisioner: Keyword.get(opts, :provisioner, :local),
       runner: nil,
       node: Node.self()
     }}
  end

  def remote_boot(state) do
    parent = self()

    {:ok, pid} =
      Task.start_link(fn ->
        Process.flag(:trap_exit, true)

        receive do
          {:boot, caller} ->
            send(caller, {:booted, self(), Node.self()})
            loop(parent)
        end
      end)

    send(pid, {:boot, self()})

    receive do
      {:booted, runner, node} ->
        {:ok, runner, %{state | runner: runner, node: node}}
    after
      5_000 -> {:error, :boot_timeout}
    end
  end

  def remote_spawn_monitor(%{runner: runner} = _state, func)
      when is_pid(runner) and is_function(func, 0) do
    req = make_ref()
    send(runner, {:spawn, self(), req, func})

    receive do
      {:spawned, ^req, pid} ->
        {:ok, {pid, Process.monitor(pid)}}
    after
      5_000 -> {:error, :spawn_timeout}
    end
  end

  def remote_spawn_monitor(state, func) when is_function(func, 0) do
    with {:ok, _term, state2} <- remote_boot(state) do
      remote_spawn_monitor(state2, func)
    end
  end

  def remote_spawn_monitor(state, {mod, fun, args})
      when is_atom(mod) and is_atom(fun) and is_list(args) do
    remote_spawn_monitor(state, fn -> apply(mod, fun, args) end)
  end

  def system_shutdown, do: :ok
  def handle_info(_msg, state), do: {:noreply, state}

  defp loop(parent) do
    receive do
      {:spawn, from, ref, func} ->
        {pid, _} = spawn_monitor(func)
        send(from, {:spawned, ref, pid})
        loop(parent)

      {:EXIT, ^parent, reason} ->
        exit(reason)

      _ ->
        loop(parent)
    end
  end
end
