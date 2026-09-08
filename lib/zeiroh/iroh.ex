defmodule Zeiroh.Iroh do
  @moduledoc """
  Iroh overlay process. Uses `IngotCluster.Iroh` when loaded; otherwise a stub.
  """
  use GenServer
  require Logger

  def start_link(opts),
    do: GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))

  def child_spec(opts) do
    %{id: Keyword.get(opts, :name, __MODULE__), start: {__MODULE__, :start_link, [opts]}}
  end

  def endpoint, do: GenServer.call(__MODULE__, :endpoint)

  @impl true
  def init(opts) do
    alpns = Keyword.get(opts, :alpns, ["zeiroh/flame"])

    cond do
      Code.ensure_loaded?(IngotCluster.Iroh) and function_exported?(IngotCluster.Iroh, :start_link, 1) ->
        case maybe_ingot_cluster(opts) do
          {:ok, pid} -> {:ok, %{backend: :ingot_cluster, endpoint: pid}}
          {:error, {:already_started, pid}} -> {:ok, %{backend: :ingot_cluster, endpoint: pid}}
          {:error, reason} -> {:stop, reason}
        end

      true ->
        Logger.warning("Zeiroh.Iroh stub (iroh_beam / ingot_cluster not loaded) alpns=#{inspect(alpns)}")
        {:ok, %{backend: :stub, endpoint: nil, stub: true, alpns: alpns}}
    end
  end

  @impl true
  def handle_call(:endpoint, _from, %{stub: true} = state),
    do: {:reply, {:error, :backend_not_loaded}, state}

  def handle_call(:endpoint, _from, %{backend: :ingot_cluster} = state) do
    reply =
      if function_exported?(IngotCluster.Iroh, :endpoint, 0) do
        IngotCluster.Iroh.endpoint()
      else
        {:ok, state.endpoint}
      end

    {:reply, reply, state}
  end

  def handle_call(:endpoint, _from, state),
    do: {:reply, {:ok, state.endpoint}, state}

  defp maybe_ingot_cluster(opts) do
    if Process.whereis(IngotCluster.Iroh) do
      {:ok, Process.whereis(IngotCluster.Iroh)}
    else
      IngotCluster.Iroh.start_link(Keyword.take(opts, [:alpns, :identity, :network, :name]))
    end
  end
end
