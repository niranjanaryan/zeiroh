# Evaluation — Zeiroh, Ingot, Dusk, FLAME

Status as of 2026-09-06. This is the design eval, not a ship checklist.

## Intent

Use **Iroh** (iron, P2P QUIC) and **Zenoh** (brokered `zenohd`) for Elixir
node membership, then drive **Phoenix FLAME** runners over that overlay.

Kind (Kubernetes-in-Docker) clustering is **out of scope**.

## Package map

| Package | Role | Keep? |
|---|---|---|
| **gale** | Phoenix HTTP/3 (Zig NIF, Bandit sidecar) | yes |
| **ingot** | Iroh + Zenoh cluster, libcluster strategies, one FLAME module | yes |
| **dusk** | Zenoh-first cluster (optional Iroh) | yes |
| **crucible** | Multi-cloud boot (`Driver`, Gale HTTP) | yes |
| **zeiroh** | FLAME Iroh/Zenoh backends; launch `package: :ingot \| :dusk \| :zeiroh` | **yes** |

`zeiroh` path-depends on sibling `ingot` and `dusk`. Mix still compiles those
path deps even when marked `optional: true`. It does **not** fix the
`iroh_beam` vs `zenohex` rustler_precompiled pin clash: a host app still
picks **one** native backend.

## What the tests prove

`mix test` in `zeiroh/` (5 cases) and matching ingot/dusk FLAME tests:

- A local Task loop starts.
- `remote_spawn_monitor` runs a 0-arity function **on the parent VM**.
- Overlay processes register (`Zeiroh.Iroh` / `Zeiroh.Zenoh`) as stubs when
  `iroh_beam` / `zenohex` are absent.

They do **not** prove remote BEAM boot, `FLAME.Pool`, or live Iroh/Zenoh
discovery.

## What Phoenix FLAME actually requires

`FLAME.Backend` (`flame` 0.5):

| Callback | Contract |
|---|---|
| `init/1` | Merge app env. FLAME passes `:terminator_sup`. |
| `remote_boot/1` | Provision or attach a **BEAM node**. Export `FLAME_PARENT`. Wait for `{ref, {:remote_up, terminator_pid}}`. Return `{ok, terminator_pid, state}`. |
| `remote_spawn_monitor/2` | Spawn on that **remote** node (`Node.spawn_monitor` / terminator), not in the parent VM. |
| `system_shutdown/0` | Halt the runner (`no_return`). |
| `handle_info/2` | Pool messages. |

`FLAME.LocalBackend` starts `FLAME.Terminator` under `terminator_sup`.
`FLAME.FlyBackend` boots a machine, then the terminator connects back.

### Current backends (zeiroh / ingot / dusk)

- Do not declare `@behaviour FLAME.Backend`.
- Do not start `FLAME.Terminator`.
- Do not set `FLAME_PARENT`.
- Do not boot or connect a remote node.
- `system_shutdown/0` returns `:ok`.
- Runner is a local Task — **LocalBackend-shaped**, not Fly-shaped.

`FLAME.Pool` / `FLAME.call/3` will not drive these the way they drive Fly.

## What Iroh and Zenoh can and cannot do

Iroh and Zenoh **cannot provision VMs**. They can:

1. **Discover** already-running nodes (gossip `node@host`, then
   `:net_kernel.connect_node/1`).
2. Later: carry **Erlang distribution** (custom dist carrier — large project).

Without Fly, Kubernetes, or local Docker boot, the honest product is
**attach-to-cluster**, not **elastic FLAME**.

## libcluster today

`Ingot.Strategy.Iroh` / `Ingot.Strategy.Zenoh` (and dusk counterparts):

- `GenServer` tick + `Cluster.Strategy.connect_nodes/4`.
- Peer list is **`config[:nodes]`**, static.
- They start overlay stubs; they do not subscribe to Iroh tickets or Zenoh
  keys for live membership.

Useful as a strategy *shape*. Not a mesh yet.

## Recommended order (do this before a fourth Hex package)

1. **libcluster live membership** — put/get `node@host` on a Zenoh key (and
   Iroh gossip when `iroh_beam` is present). Static `:nodes` only in tests.
2. **FLAME attach mode** — `@behaviour FLAME.Backend`; `remote_boot` picks a
   connected node or falls back to `FLAME.LocalBackend` + terminator when
   there is no remote. `FLAME.call/3` works in-process.
3. **FLAME boot mode** — wrap Fly / K8s / Docker; Iroh/Zenoh only for
   membership after boot.
4. **One backend module** — `Ingot.FLAME.Backend` with
   `overlay: :iroh | :zenoh | :both`. **Zeiroh** is the FLAME-facing
   package (`Zeiroh.FLAME.Iroh` / `.Zenoh` / `.Backend`) and delegates
   cluster to ingot/dusk. Crucible is `provisioner:` under that backend.

## Launch (current, local overlay)

```elixir
{:zeiroh, path: "../zeiroh"}
{:flame, "~> 0.5"}

{Zeiroh, overlay: :both, live: false}
{Zeiroh, package: :ingot, iroh: true, zenoh: [live: false]}
{Zeiroh, package: :dusk, live: false}

config :flame, :backend, {Zeiroh.FLAME.Backend, overlay: :both, live: false}
# or {Zeiroh.FLAME.Iroh, alpns: ["zeiroh/flame"]}
# or {Zeiroh.FLAME.Zenoh, connect: "tcp/127.0.0.1:7447"}
```

`live: false` is the supported path until zenohd / iroh_beam are wired.

## Cannot provision VMs

Iroh and Zenoh are transports. Relays and `zenohd` do not create Fly
machines or pods. Smooth scaling is **provisioner + overlay**, not overlay
alone. Plan and tool map: [SCALING.md](SCALING.md).

## Decision

Keep all five: **gale** (HTTP), **ingot** (Iroh+Zenoh cluster), **dusk**
(Zenoh-first), **zeiroh** (FLAME overlay + launch), **crucible** (boot).
Zeiroh is part of the line. Limits above are implementation status, not
a reason to drop the package.
