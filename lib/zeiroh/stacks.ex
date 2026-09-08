defmodule Zeiroh.Stacks do
  @moduledoc """
  Stacks-specific overlay for Zeiroh.

  Provides Iroh-based P2P node discovery, Phoenix FLAME integration for
  distributed off-chain workers, and Zenoh pub/sub for sBTC relay
  peer-to-peer data exchange — all from Elixir.

  ## Examples

      # Start Zeiroh with Stacks overlay
      {:ok, _pid} = Zeiroh.start_link(overlay: :stacks, backend: :iroh,
        iroh: [alpns: ["stacks/node/1", "stacks/relay/1"]])

      # Discover Stacks nodes
      {:ok, peers} = Zeiroh.Stacks.discover_peers()

      # Spawn FLAME worker for Stacks indexer
      {:ok, _pid} = Zeiroh.FLAME.Backend.spawn_worker(%{
        name: StacksIndexer,
        overlay: :stacks,
        provisioner: {Crucible, driver: :hetzner}
      })
  """

  alias Zeiroh.{Iroh, Zenoh}
  alias Zeiroh.Stacks.Discovery

  @stacks_alpns ["stacks/node/1", "stacks/relay/1"]

  @doc """
  Start Zeiroh with Stacks overlay configuration.
  """
  def start_link(opts) do
    backend = Keyword.get(opts, :backend, :iroh)
    overlay = Keyword.get(opts, :overlay, :stacks)

    case backend do
      :iroh ->
        iroh_opts = Keyword.merge(opts, alpns: @stacks_alpns, overlay: overlay)
        Zeiroh.Iroh.start_link(iroh_opts)

      :zenoh ->
        zenoh_opts = Keyword.merge(opts, overlay: overlay)
        Zeiroh.Zenoh.start_link(zenoh_opts)

      _ ->
        {:error, {:unsupported_backend, backend}}
    end
  end

  @doc """
  Discover Stacks peers via Iroh DHT.
  """
  def discover_peers(opts \\ []) do
    Discovery.discover(opts)
  end

  @doc """
  Subscribe to sBTC relay status updates via Zenoh pub/sub.
  """
  def relay_status_subscriber do
    {:ok, session} = Zenoh.session("stacks/sbtc/relay/status")
    {:ok, session}
  end

  @doc """
  Publish sBTC relay status via Zenoh pub/sub.
  """
  def publish_relay_status(session, status) when is_map(status) do
    Zenoh.publish(session, "stacks/sbtc/relay/status", status)
  end
end
