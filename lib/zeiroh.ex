defmodule Zeiroh do
  @moduledoc """
  Phoenix **FLAME** backends for **Iroh** and **Zenoh**.

  First-class FLAME package. Siblings:

  * [Ingot](https://github.com/niranjanaryan/ingot) — Iroh + Zenoh cluster
  * [Dusk](https://github.com/niranjanaryan/dusk) — Zenoh-first cluster
  * [Crucible](https://github.com/niranjanaryan/crucible) — boot the machine
  * [Gale](https://github.com/niranjanaryan/gale) — HTTP/3

      config :flame, :backend, {Zeiroh.FLAME.Backend, provisioner: :local, overlay: :both}

      {Zeiroh, overlay: :both, live: false}
      {Zeiroh, package: :ingot, iroh: true, zenoh: [live: false]}
      {Zeiroh, package: :dusk, live: false}
  """

  defdelegate start_link(opts), to: Zeiroh.Cluster
  defdelegate child_spec(opts), to: Zeiroh.Cluster

  def backends do
    %{
      iroh: Code.ensure_loaded?(Ingot.Iroh) and Ingot.Iroh.available?(),
      zenoh:
        (Code.ensure_loaded?(Ingot.Zenoh) and Ingot.Zenoh.available?()) or
          (Code.ensure_loaded?(Dusk.Zenoh) and Dusk.Zenoh.available?()),
      ingot: Code.ensure_loaded?(Ingot),
      dusk: Code.ensure_loaded?(Dusk),
      flame_iroh: true,
      flame_zenoh: true,
      crucible: Code.ensure_loaded?(Crucible),
      gale: Code.ensure_loaded?(Gale)
    }
  end
end
