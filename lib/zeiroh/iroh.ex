defmodule Zeiroh.Iroh do
  @moduledoc """
  Iroh overlay process. Uses `Ingot.Iroh` when loaded; otherwise a stub.
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
      Code.ensure_loaded?(Ingot.Iroh) and function_exported?(Ingot.Iroh, :start_link, 1) ->
        case maybe_ingot(opts) do
          {:ok, pid} -> {:ok, %{backend: :ingot, endpoint: pid}}
          {:error, {:already_started, pid}} -> {:ok, %{backend: :ingot, endpoint: pid}}
          {:error, reason} -> {:stop, reason}
        end

      true ->
        Logger.warning("Zeiroh.Iroh stub (iroh_beam / ingot not loaded) alpns=#{inspect(alpns)}")
        {:ok, %{backend: :stub, endpoint: nil, stub: true, alpns: alpns}}
    end
  end

  @impl true
  def handle_call(:endpoint, _from, %{stub: true} = state),
    do: {:reply, {:error, :backend_not_loaded}, state}

  def handle_call(:endpoint, _from, %{backend: :ingot} = state) do
    reply =
      if function_exported?(Ingot.Iroh, :endpoint, 0) do
        Ingot.Iroh.endpoint()
      else
        {:ok, state.endpoint}
      end

    {:reply, reply, state}
  end

  def handle_call(:endpoint, _from, state),
    do: {:reply, {:ok, state.endpoint}, state}

  defp maybe_ingot(opts) do
    if Process.whereis(Ingot.Iroh) do
      {:ok, Process.whereis(Ingot.Iroh)}
    else
      Ingot.Iroh.start_link(Keyword.take(opts, [:alpns, :identity, :network, :name]))
    end
  end
end
