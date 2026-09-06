defmodule Zeiroh.FLAME.Zenoh do
  @moduledoc """
  Phoenix **FLAME** backend using the **Zenoh** overlay only.

      config :flame, :backend, {Zeiroh.FLAME.Zenoh,
        connect: "tcp/127.0.0.1:7447",
        key: "zeiroh/flame/runners"}
  """

  def init(opts) when is_list(opts) do
    Zeiroh.FLAME.Backend.init(Keyword.put(opts, :overlay, :zenoh))
  end

  defdelegate remote_boot(state), to: Zeiroh.FLAME.Backend
  defdelegate remote_spawn_monitor(state, func), to: Zeiroh.FLAME.Backend
  defdelegate system_shutdown(), to: Zeiroh.FLAME.Backend
  defdelegate handle_info(msg, state), to: Zeiroh.FLAME.Backend
end
