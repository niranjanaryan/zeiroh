defmodule ZeirohTest do
  use ExUnit.Case, async: false

  setup do
    on_exit(fn ->
      for name <- [Zeiroh.Iroh, Zeiroh.Zenoh, Ingot.Iroh, Ingot.Zenoh] do
        if pid = Process.whereis(name) do
          try do
            GenServer.stop(pid, :normal, 500)
          catch
            :exit, _ -> :ok
          end
        end
      end
    end)

    :ok
  end

  test "backends map" do
    b = Zeiroh.backends()
    assert b.flame_iroh
    assert b.flame_zenoh
    assert is_boolean(b.crucible)
    assert is_boolean(b.gale)
    assert is_boolean(b.ingot)
    assert is_boolean(b.dusk)
  end

  test "cluster starts iroh and zenoh stubs" do
    {:ok, pid} =
      Zeiroh.start_link(
        name: Zeiroh.Cluster.Test,
        overlay: :both,
        live: false
      )

    assert Process.alive?(pid)
    assert {:error, :backend_not_loaded} = Zeiroh.Iroh.endpoint()
    assert {:error, :backend_not_loaded} = Zeiroh.Zenoh.put("zeiroh/x", "hi")
    Supervisor.stop(pid)
  end

  test "FLAME Iroh backend boots and runs a function" do
    {:ok, state} = Zeiroh.FLAME.Iroh.init(live: false)
    {:ok, _term, state} = Zeiroh.FLAME.Iroh.remote_boot(state)
    parent = self()

    assert {:ok, {pid, ref}} =
             Zeiroh.FLAME.Iroh.remote_spawn_monitor(state, fn ->
               send(parent, :iroh_ran)
               :ok
             end)

    assert is_pid(pid)
    assert is_reference(ref)
    assert_receive :iroh_ran, 1_000
  end

  test "FLAME Zenoh backend boots and runs a function" do
    {:ok, state} = Zeiroh.FLAME.Zenoh.init(live: false)
    {:ok, _term, state} = Zeiroh.FLAME.Zenoh.remote_boot(state)
    parent = self()

    assert {:ok, {pid, ref}} =
             Zeiroh.FLAME.Zenoh.remote_spawn_monitor(state, fn ->
               send(parent, :zenoh_ran)
               :ok
             end)

    assert is_pid(pid)
    assert is_reference(ref)
    assert_receive :zenoh_ran, 1_000
  end

  test "FLAME both overlay" do
    {:ok, state} = Zeiroh.FLAME.Backend.init(overlay: :both, live: false)
    {:ok, _term, state} = Zeiroh.FLAME.Backend.remote_boot(state)
    parent = self()

    assert {:ok, {_pid, _ref}} =
             Zeiroh.FLAME.Backend.remote_spawn_monitor(state, fn ->
               send(parent, :both_ran)
             end)

    assert_receive :both_ran, 1_000
  end
end
