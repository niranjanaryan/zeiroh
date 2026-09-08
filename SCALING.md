# Scaling plan — provision compute, overlay Iroh/Zenoh

Iroh (iron) and Zenoh **cannot provision VMs**. That is not a bug in the
libraries; they are **transports**. Smooth scaling means splitting the job:

| Layer | Job | Tools |
|---|---|---|
| **Provision** | Create / destroy a process that runs *your release* | Fly Machines, Kubernetes pods, Docker, EC2, Hetzner |
| **Join** | Make that process a BEAM node the parent can talk to | Iroh dist / tickets, zenohd, Erlang cookie |
| **Run** | `FLAME.call` on the node, idle-shutdown | `FLAME.Pool` + real `FLAME.Backend` |
| **Fabric** | Keep NAT traversal and pub/sub up as node count grows | Iroh relays, zenohd routers (not FLAME runners) |

```
FLAME.Pool
    │ remote_boot
    ▼
IngotCluster.Provisioner  ──HTTP/API──►  Fly | K8s | Docker | (later EC2)
    │ image + FLAME_PARENT + overlay env
    ▼
Runner boots release
    │
    ├─ Iroh:  IrohBeam.Distribution.start → Node.connect(parent)
    └─ Zenoh: client → zenohd, put node@host on key
    │
    ▼
FLAME.Terminator {ref, {:remote_up, pid}}
```

Kind remains out of scope as a *product* name. Kubernetes itself is in
scope as a **provisioner**.

## Why overlays do not boot machines

- **Iroh** dials *endpoint IDs* (keys), punches NAT, falls back to
  **relays**. Relays forward encrypted packets. They do not start Docker
  or a BEAM VM. `iroh_beam` can carry **Erlang distribution** once two
  VMs already exist (`IrohBeam.Distribution.start/1`).
- **Zenoh** is pub/sub + query. **`zenohd`** is a router you run as a
  daemon. Clients connect to it. Scaling Zenoh means more routers and
  clients, not “Zenoh, please give me a 2 CPU box.”

Public Iroh relays are rate-limited and shared. Production Iroh traffic
needs **shared/dedicated relays** (n0) or self-hosted `iroh-relay`.
Zenoh production needs **deployed `zenohd`**, not a process spawned
inside `FLAME.call`.

## Existing provisioners (use these; do not rewrite)

| Tool | Hex / API | Fit |
|---|---|---|
| **`FLAME.FlyBackend`** | `flame` | Best default for elastic machines; ~3s boot; same Docker image |
| **`FLAMEK8sBackend`** | `flame_k8s_backend` ~> 0.6 | Pods in the current cluster; copies parent image/env |
| **`FlameEC2`** | `flame_ec2` | S3 release bundle + EC2 instance |
| **Docker Engine API** | local / CI | `docker run` same image; no cloud account |
| **Hetzner / GCP / Nomad** | none in Hex yet | Same pattern as Fly: HTTP create + env inject |

Chris McCord: any host with an API to “boot this image” is a valid
FLAME backend. Overlay code should **wrap** these, not replace them.

## Target API

```elixir
{FLAME.Pool,
 name: MyApp.Runners,
 backend: {IngotCluster.FLAME.Backend,
   provisioner: :fly,          # :local | :docker | :fly | :k8s
   overlay: :iroh,             # :iroh | :zenoh | :both
   live: true}}
```

Semantics:

1. `init/1` — require `:terminator_sup`; start overlay client (stub if
   `live: false`).
2. `remote_boot/1` — **provisioner** creates the runner with:
   - same release image
   - `FLAME_PARENT` (encoded)
   - `RELEASE_COOKIE`
   - overlay: `IROH_BOOTSTRAP_TICKET` or `ZENOH_CONNECT=tcp/zenohd:7447`
3. Runner starts Iroh dist and/or Zenoh client, terminator connects
   **back** (Iroh does not need a public A record).
4. `remote_spawn_monitor/2` — `Node.spawn_monitor` on the remote.
5. Idle → `system_shutdown/0` → provisioner deletes machine/pod.

`overlay: :both` is for apps that want Iroh dist **and** Zenoh
membership keys. Host still cannot Mix-lock `iroh_beam` and `zenohex`
together until rustler pins align — pick one native lib per release.

## Provisioner adapters (implement in this order)

### 1. `:local` (dev)

Keep today’s Task loop **or** delegate to `FLAME.LocalBackend`.
Proves `FLAME.call` without cloud. Overlay `live: false`.

### 2. `:docker`

- Socket: `/var/run/docker.sock` or `DOCKER_HOST`.
- `docker run --rm -e FLAME_PARENT=… -e RELEASE_COOKIE=… IMAGE`
- Optional sidecar: `eclipse/zenoh` on `7447`.
- Use for laptop + CI. No Kind required.

### 3. `:fly` (compose, do not fork)

- Call **`FLAME.FlyBackend`** for create/destroy.
- After boot, parent publishes its **Iroh ticket** (or node name) on
  a known channel; runner dials parent over Iroh if Fly 6PN is not
  enough (home ↔ Fly, multi-cloud, CGNAT workers).
- Env on the machine: `IROH_NETWORK=n0` or custom relay URLs.

Fly already clusters on 6PN. Iroh is the **escape hatch** when the
runner is not on Fly (laptop, second cloud, edge box).

### 4. `:k8s`

- Call **`FLAMEK8sBackend`** (`POD_NAME` / `POD_NAMESPACE`).
- Inject overlay env onto the runner pod manifest.
- Cluster DNS is optional if Iroh dist is the carrier.
- Deploy **zenohd** as a Deployment + Service (not as a FLAME runner).
- Deploy **iroh-relay** only if you leave n0 public relays.

## Fabric (scale the overlay, not the provisioner)

These stay up while FLAME min=0:

**Zenoh**

- 2+ `zenohd` in **router** mode, `--connect` to each other.
- Clients (`mode: client`) list both endpoints.
- K8s: Deployment + Service `zenohd:7447`.
- Docker Compose: `eclipse/zenoh` next to the app.
- Optional REST plugin for admin; storage plugin only if you need
  last-value of `ingot_cluster/cluster/nodes`.

**Iroh**

- Dev: `network: :n0` public relays.
- Prod: n0 Shared/Dedicated relays **or** `iroh-relay` on a public IP
  (Fly machine / VM) with TLS.
- Bootstrap: parent ticket in env or a one-shot Zenoh key
  `ingot_cluster/iroh/bootstrap` (Zenoh as introduction, Iroh as dist).
- `IrohBeam.Distribution` is OTP 29-only today — document the OTP
  floor; until then use classic dist *plus* Iroh only for discovery.

## Smooth scaling path

| Stage | Compute | Overlay | Who uses it |
|---|---|---|---|
| A | LocalBackend | stubs | unit tests |
| B | Docker run same image | zenohd compose + Iroh n0 | laptop |
| C | FlyBackend + Iroh join | n0 or dedicated relay | prod elastic |
| D | FLAMEK8sBackend + zenohd Service | Iroh optional | existing K8s |
| E | Multi-cloud: Fly *or* K8s boot, Iroh dist everywhere | dedicated relays | CGNAT / mixed DC |

Never wait on Iroh/Zenoh to grow `FLAME.Pool` max. Pool max is a
**provisioner quota** (Fly machine cap, K8s ResourceQuota). Overlay
only has to stay connected.

## What not to do

- Do not implement a fourth “Zeiroh cloud.”
- Do not use Kind as the documented cluster story (user dropped it).
- Do not spawn `zenohd` inside each FLAME runner (split-brain routers).
- Do not put `iroh_beam` and `zenohex` in one Mix lock until pins match.
- Do not treat public n0 relays as a capacity plan.

## New package: Crucible

Survey of Hex FLAME backends + Libcloud: [../crucible/DESIGN.md](../crucible/DESIGN.md).
Skeleton Mix app: `crucible/` (`Crucible.Driver`, Local/Docker, wrap Fly/K8s/EC2).

## Implementation order (zeiroh FLAME + crucible boot + ingot_cluster/dusk join)

1. `IngotCluster.Provisioner` behaviour: `boot/1`, `shutdown/1`.
2. `Local` + `Docker` adapters; tests with `live: false`.
3. Real `@behaviour FLAME.Backend` wrapping Local, then Docker.
4. Wrap `FLAME.FlyBackend` / `FLAMEK8sBackend` as provisioners;
   inject overlay env.
5. Live `IngotCluster.Strategy.Zenoh`: put/get `node@host` on zenohd.
6. Live Iroh: ticket exchange + `Node.connect` (dist when OTP allows).
7. Docs: compose file for zenohd; Fly `[env]` for tickets; K8s
   Service for zenohd.

Until (3), `FLAME.call` on these backends is in-process only — see
[EVAL.md](EVAL.md).
