defmodule Zeiroh.FLAME.Iroh do
  @moduledoc """
  Phoenix **FLAME** backend using the **Iroh** (iron) overlay only.

      config :flame, :backend, {Zeiroh.FLAME.Iroh, alpns: ["zeiroh/flame"]}
  """

  def init(opts) when is_list(opts) do
    Zeiroh.FLAME.Backend.init(Keyword.put(opts, :overlay, :iroh))
  end

  defdelegate remote_boot(state), to: Zeiroh.FLAME.Backend
  defdelegate remote_spawn_monitor(state, func), to: Zeiroh.FLAME.Backend
  defdelegate system_shutdown(), to: Zeiroh.FLAME.Backend
  defdelegate handle_info(msg, state), to: Zeiroh.FLAME.Backend
end
