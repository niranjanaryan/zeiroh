defmodule Zeiroh.Zenoh do
  @moduledoc """
  Zenoh overlay process. Uses `IngotCluster.Zenoh` or `Dusk.Zenoh` when loaded.
  """
  use GenServer
  require Logger

  def start_link(opts),
    do: GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))

  def child_spec(opts) do
    %{id: Keyword.get(opts, :name, __MODULE__), start: {__MODULE__, :start_link, [opts]}}
  end

  def put(key, payload), do: GenServer.call(__MODULE__, {:put, key, payload})
  def session, do: GenServer.call(__MODULE__, :session)

  @impl true
  def init(opts) when is_list(opts) do
    connect = Keyword.get(opts, :connect, "tcp/127.0.0.1:7447")
    key = Keyword.get(opts, :key, "zeiroh/flame/runners")
    live = Keyword.get(opts, :live, false)

    backend = pick_backend()

    Logger.warning("Zeiroh.Zenoh #{backend} connect=#{connect} key=#{key} live=#{live}")

    {:ok, %{backend: backend, connect: connect, key: key, live: live, session: nil, stub: true}}
  end

  @impl true
  def handle_call(:session, _from, state), do: {:reply, {:ok, state.session}, state}

  def handle_call({:put, key, payload}, _from, state) do
    result =
      cond do
         state.backend == :ingot_cluster and function_exported?(IngotCluster.Zenoh, :put, 2) and
            Process.whereis(IngotCluster.Zenoh) ->
          IngotCluster.Zenoh.put(key, payload)

        state.backend == :dusk and function_exported?(Dusk.Zenoh, :put, 2) and
            Process.whereis(Dusk.Zenoh) ->
          Dusk.Zenoh.put(key, payload)

        true ->
          {:error, :backend_not_loaded}
      end

    {:reply, result, state}
  end

  defp pick_backend do
    cond do
      Code.ensure_loaded?(IngotCluster.Zenoh) -> :ingot_cluster
      Code.ensure_loaded?(Dusk.Zenoh) -> :dusk
      true -> :stub
    end
  end
end
