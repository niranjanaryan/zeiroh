# Elixir Forum Announcement — Zeiroh 0.1.0

Post this to [Elixir Forum](https://elixirforum.com/) under **Announcements** or **Libraries and Tools**.

---

**Title:** `[ANN] Zeiroh 0.1.0 — Phoenix FLAME overlay for Iroh and Zenoh`

**Body:**

Hi everyone,

I’m happy to announce **Zeiroh** — a Phoenix FLAME backend for Iroh and Zenoh. It delegates cluster membership to sibling packages and gives you a single `FLAME.call` entrypoint.

**What it does:**
- **FLAME backend**: `Zeiroh.FLAME.Backend` with `overlay: :iroh | :zenoh | :both`
- **Cluster delegation**: launch via `IngotCluster.Cluster` or `Dusk.Cluster` with `package: :ingot_cluster | :dusk`
- **Provisioners**: local, Docker, Fly, K8s, EC2 via Crucible
- **Overlay stubs**: works even without Iroh/Zenoh loaded; plugs in when available

**Install**
```elixir
defp deps do
  [
    {:zeiroh, "~> 0.1"},
    {:ingot_cluster, "~> 0.1", hex: :ingot_cluster, optional: true},
    {:dusk, "~> 0.1", optional: true},
    {:flame, "~> 0.5"}
  ]
end
```

**Usage**
```elixir
config :flame, :backend, {Zeiroh.FLAME.Backend, overlay: :both, provisioner: :local}

{Zeiroh, package: :ingot_cluster, iroh: true, zenoh: [live: false]}
{Zeiroh, package: :dusk, live: false}
```

**Docs & Source**
- [Hex.pm](https://hex.pm/packages/zeiroh)
- [Hexdocs](https://hexdocs.pm/zeiroh)
- [GitHub](https://github.com/niranjanaryan/zeiroh)

**Honest limits**
- `remote_boot` is in-process unless a Crucible/Fly/K8s provisioner is wired.
- Iroh/Zenoh discover existing nodes; they do not replace Fly/K8s boot.
- See [EVAL.md](https://github.com/niranjanaryan/zeiroh/blob/main/EVAL.md) and [SCALING.md](https://github.com/niranjanaryan/zeiroh/blob/main/SCALING.md).

**Sponsor / Funding**
- [github.com/sponsors/niranjanaryan](https://github.com/sponsors/niranjanaryan)
- [Buy Me a Coffee](https://www.buymeacoffee.com/niranjanaryan)

— Niranjan
