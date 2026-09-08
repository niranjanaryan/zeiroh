# Stacks Endowment Grant Application — Zeiroh Stacks Distributed Overlay

**Track:** Getting Started Grant  
**Theme:** Distribution & Integrations (Q3 2026)  
**Request:** $5,000 STX  
**Timeline:** 10 weeks  

---

## 1. Project Summary

**Zeiroh** is the **Phoenix FLAME execution layer** for **Iroh** (P2P QUIC) and **Zenoh** (brokered pub/sub). We are requesting a Getting Started Grant to add a **Stacks-specific overlay backend** that lets Stacks operators spawn distributed off-chain workers — indexers, relay monitors, fraud detectors — from Elixir, with auto-discovery, self-healing networking, and pub/sub coordination built in.

Today, Stacks node operators and sBTC relay operators rely on static peer lists, centralized APIs, and manual networking configuration. There is no language-native, FLAME-compatible P2P overlay that treats Stacks infrastructure as a first-class citizen. Zeiroh fills this gap by giving Stacks operators a way to deploy distributed workers that auto-discover each other via Iroh/Zenoh and coordinate without centralized brokers.

**Why Zeiroh is different:** IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Only Zeiroh combines **Phoenix FLAME worker spawning** with **Iroh/Zenoh P2P** — making it the execution layer, not just another networking library.

**Why Stacks:** As PoX-5, sBTC, and the Nakamoto upgrade scale, Stacks operators need resilient, low-latency node networking that doesn't depend on a single relay or static config. Zeiroh gives them a self-healing P2P data plane written in Elixir, composable with any Stacks backend.

**Why Now:** Q3 2026 is the right moment because:
1. **PoX-5 is live** — Stackers are running signer nodes across multiple regions and need resilient peer discovery without static configs.
2. **sBTC is in market** — relay operators are scaling infrastructure and need fault-tolerant coordination without centralized brokers.
3. **Nakamoto upgrade is active** — node operators are upgrading and need better networking primitives.
4. **No existing solution** — Zeiroh is the only Elixir package combining Phoenix FLAME + Iroh/Zenoh P2P; the gap is clear and time-sensitive.

**Cloud fit:** Zeiroh is designed for cloud-native Stacks deployments:
- **Hetzner / DigitalOcean** — low-cost Stacker/relay nodes; Iroh hole-punching works behind NAT; FLAME workers auto-discover without manual config.
- **AWS / GCP / Azure** — enterprise Stacks infrastructure with cross-region FLAME workers; Zenoh pub/sub coordinates relay state.
- **Fly.io / Kubernetes** — edge deployment for low-latency P2P discovery near Stacks nodes; Burrito single-binary CLI simplifies deployment.
- **Local / Bare metal** — Stacks node operators running on-prem can use Zenoh brokered mode without cloud dependencies.

---

## 2. Problem Statement

Stacks infrastructure networking is centralized and fragile:

- **Static peer lists**: Node operators manually configure `peers` in `stacks-node.toml`. If a peer goes down, discovery halts.
- **Centralized RPC**: dApps and relays hit a single API endpoint. No built-in replication or failover.
- **No P2P data plane**: Block propagation, transaction gossip, and sBTC relay coordination rely on TCP gossip protocols that are hard to operate behind NAT or in multi-region setups.
- **No FLAME-compatible off-chain layer**: Stacks dApps that need distributed workers (indexers, relay monitors, fraud detectors) have no standard way to spawn and coordinate them from Elixir.

**The gap:** No Elixir-native P2P overlay designed for Stacks node and relay communication that integrates with Phoenix FLAME. Existing options are generic libp2p wrappers, single-language tools, or one-off scripts that don't provide auto-discovery, self-healing, or distributed worker orchestration.

**Who is affected:**
- PoX-5 Stackers running signer nodes that need resilient peer discovery
- sBTC relay operators coordinating across multiple regions
- dApp developers building distributed indexers, monitors, and fraud detectors
- DevOps teams managing Stacks infrastructure at scale

---

## 3. Solution

Zeiroh adds a `Zeiroh.Stacks` backend that provides:

1. **FLAME execution layer for Stacks off-chain workers** — Use Zeiroh's existing FLAME backend to spawn distributed workers (indexers, relay monitors, fraud watchers) that auto-discover each other via Iroh/Zenoh. This is Zeiroh's unique value: not just networking, but **execution**.
2. **Iroh DHT node discovery** — Nodes advertise their IP, port, and version via Iroh DHT without a central tracker. Peer records include `stx.address`, IP, port, `stacks-node` version, and last-seen timestamp.
3. **Zenoh pub/sub for sBTC relay coordination** — Relay-to-relay Bitcoin/Stacks state synchronization on `stacks/sbtc/relay/**`, replacing or complementing centralized message queues.

```elixir
# Stacks node with P2P discovery
{Zeiroh, overlay: :stacks, backend: :iroh,
  iroh: [alpns: ["stacks/node/1", "stacks/relay/1"]]}

# FLAME worker for Stacks indexer
{FLAME.Pool,
  name: StacksIndexer,
  backend: {Zeiroh.FLAME.Backend,
    overlay: :stacks,
    provisioner: {Crucible, driver: :hetzner}}}

# FLAME worker auto-joins Iroh mesh with FLAME_PARENT + bootstrap ticket injected
# Zenoh session for relay coordination
{:ok, session} = Zeiroh.Zenoh.session("stacks/sbtc/relay/**")
Zeiroh.Zenoh.publish(session, "stacks/sbtc/relay/status", %{height: 12345})
```

**Concrete use cases:**

1. **Distributed burnchain indexer:** FLAME workers shard burnchain block ranges, auto-discover via Iroh DHT, and publish results via Zenoh. Operators get near-real-time indexing without a single point of failure.
2. **sBTC relay health monitor:** FLAME workers probe multiple relays, aggregate status via Zenoh pub/sub, and auto-spawn replacement workers when a relay degrades.
3. **Signer node health watcher:** Lightweight FLAME workers deployed alongside signer nodes watch for missed blocks, connectivity drops, or PoX-5 voting misconfig, and alert via Zenoh.

CLI parity:

```bash
zeiroh stacks peers          # discover Stacks nodes via Iroh DHT
zeiroh stacks relay-status   # subscribe to sBTC relay status via Zenoh
zeiroh flame --overlay stacks # spawn FLAME workers with Stacks overlay
```

**Why not existing solutions?**
- **libp2p wrappers:** Generic, not Elixir-native, no Phoenix FLAME integration. Zeiroh is built for Elixir and Phoenix from the ground up.
- **libcluster strategies:** Discovery only, no off-chain worker spawning, no pub/sub relay coordination. Zeiroh provides the full execution layer.
- **Custom Ansible/Terraform:** One-off, not self-healing, no P2P data plane. Zeiroh auto-discovers and heals.

**Design choices:**
- Backward-compatible: existing Zeiroh users unaffected; Stacks overlay is opt-in via `overlay: :stacks`.
- Interoperable: Iroh and Zenoh both speak QUIC, so Stacks nodes can communicate across firewalls.
- Composable: works with Crucible for provisioning, Gale for HTTP transport, and existing Stacks node binaries.

---

## 4. Why This Matters for Stacks

**Ecosystem impact:**
- Eliminates single-point-of-failure peer discovery for Stacks node operators.
- Enables geo-redundant sBTC relay networks without centralized message brokers.
- Gives Stacks dApp developers a standard way to run distributed off-chain workers (indexers, monitors, fraud detectors) using Phoenix FLAME + Elixir.

**Strategic alignment:**
- Directly supports the Nakamoto-upgraded network by improving node resilience and discovery.
- Enables sBTC utility by providing a peer-to-peer relay coordination layer.
- Fits the Q3 2026 "Distribution & Integrations" theme: infrastructure that connects Stacks nodes, relays, and dApps in a distributed, fault-tolerant way.

**Ecosystem-first:**
- Open-source (MIT), no token, no platform fee.
- Other Stacks projects can adopt the P2P overlay independently.
- Works with any Stacks node implementation that supports standard TCP/QUIC networking.

---

## 5. Milestones

### Milestone 1: Stacks Node Discovery + FLAME Overlay (Weeks 1–5, $2,500 STX)

**Deliverable:** Working `Zeiroh.Stacks` node discovery and FLAME backend.

- Iroh DHT namespace for Stacks nodes (`stacks/node/1` ALPN).
- `zeiroh stacks peers` CLI: discover, list, and ping Stacks nodes.
- Node identity: each node gets a stable Iroh peer ID derived from its Stacks `stx.address`.
- Peer records include `stx.address`, IP, port, `stacks-node` version, and last-seen timestamp.
- `Zeiroh.FLAME.Backend` with Stacks-specific overlay config: `overlay: :stacks` injects `FLAME_PARENT` and Iroh bootstrap tickets into spawned workers.
- Auto-discovery of FLAME workers via Iroh/Zenoh.
- **Concrete use case 1:** Distributed burnchain indexer — FLAME workers shard block ranges, auto-discover via Iroh, publish via Zenoh.
- **Concrete use case 2:** Signer node health watcher — lightweight FLAME workers watch for missed blocks and connectivity drops.
- Integration with Crucible for provisioning workers across clouds.
- Tests: mock Iroh DHT, contract tests for discovery and FLAME protocols.

**Verification:** Published v0.2.0 with docs and tutorial: "Running a Distributed Stacks Indexer with Zeiroh + Crucible".

### Milestone 2: sBTC Relay Pub/Sub + Production Packaging (Weeks 6–10, $2,500 STX)

**Deliverable:** Zenoh-based relay coordination and Burrito binary packaging.

- Zenoh pub/sub for sBTC relay state (`stacks/sbtc/relay/**`) with `{height, status, latency}` published every block.
- **Concrete use case 3:** sBTC relay health monitor — FLAME workers probe multiple relays, aggregate status via Zenoh, auto-spawn replacements when relays degrade.
- Relay status aggregation and conflict detection.
- Burrito single-binary build for standalone CLI.
- Performance benchmarks: discovery latency, message throughput, failover time.
- Security review of peer identity and message authentication.

**Verification:** Published v0.3.0, demo at Stacks community event, and open issues for relay operator feedback.

---

## 6. Budget

| Item | Amount (STX) | Notes |
|------|-------------|-------|
| Development (2 milestones) | 4,000 | 10 weeks at ~400 STX/week |
| Cloud infrastructure for testing | 400 | Hetzner/DO nodes for live P2P tests |
| Security review | 250 | Peer identity, message auth |
| Documentation & demo production | 200 | Tutorials, screencasts |
| Buffer | 150 | Contingency |
| **Total** | **5,000** | Aligned with Getting Started Grant average |

**Disbursement:** 50% at Milestone 1 (Week 5), 50% at Milestone 2 (Week 10).

---

## 7. Team

**Niranjan Aryan** — solo builder, [@niranjanaryan](https://github.com/niranjanaryan).

- **Relevant experience:** Maintains Zeiroh (Phoenix FLAME overlay for Iroh/Zenoh, published on Hex.pm), IngotCluster (Iroh+Zenoh cluster), Crucible (multi-cloud provisioner, published on Hex.pm v0.1.1), Gale (HTTP/3), Orian (S3/S5 transfer), and Dusk (Zenoh cluster). All MIT-licensed with CI, docs, and community funding. Deep expertise in Elixir, distributed systems, P2P networking, and Phoenix FLAME.
- **GitHub:** [github.com/niranjanaryan](https://github.com/niranjanaryan)
- **Stacks engagement:** First application. Building the FLAME execution layer for Stacks off-chain workers — the one layer IngotCluster and Dusk do not cover.

---

## 8. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Iroh/Zenoh protocol changes | Low | Medium | Pin to stable releases; abstract protocol layer |
| Stacks node config incompatibility | Medium | Medium | Support `stacks-node` v2.x+; document version pinning |
| NAT traversal issues for P2P | Medium | Medium | Use Iroh's hole-punching; fallback to Zenoh brokered mode |
| Scope creep (too many Stacks features) | Medium | Medium | Milestone 1 is discovery+FLAME only; Milestone 2 is relay |
| Solo builder bandwidth | Medium | Low | 10 weeks, focused scope; existing Zeiroh codebase reduces risk |

---

## 9. Ecosystem Commitment

- **Long-term maintenance:** Zeiroh is part of a maintained Elixir infrastructure toolkit. Stacks overlay will receive ongoing updates.
- **Community:** Open to Stacks ecosystem contributions; will label `good first issue` for Stacks-specific work.
- **Post-grant roadmap:**
  - **Months 1–3:** Bug fixes, community support, and Stacks-specific templates.
  - **Months 3–6:** Add support for Stacks `sbtc_trustless_set` events as a Zenoh topic; integrate with `stacks-node` v3.x if released.
  - **Adoption target:** 50+ GitHub stars, 100+ Hex downloads, 1+ community-contributed Stacks template within 90 days of v0.3.0.
- **Stacks alignment:** Will evolve with Stacks releases (Nakamoto, PoX-5, sBTC). No exit strategy.

---

## 10. Proof of Work

- **Zeiroh:** Published on Hex.pm with working FLAME backend for Iroh/Zenoh, CI, docs.
- **IngotCluster:** Iroh+Zenoh cluster package with DHT and pub/sub — complementary to Zeiroh's FLAME layer.
- **Crucible:** Multi-cloud provisioner (v0.1.1 on Hex.pm) with 100+ provider catalog.
- **Gale:** HTTP/3 Phoenix adapter (~825K req/s on localhost).
- **Dusk:** Zenoh-first cluster with BLAKE3/S5/S3 storage.
- **Orian:** S3/S5 transfer utility.
- **GitHub:** Active maintainer of 6+ open-source Elixir repos with CI, docs, and community funding.

---

## 11. Application Answers (Form-Field Ready)

**Project name:** Zeiroh — Stacks Distributed Overlay

**Track:** Getting Started Grant

**Theme:** Distribution & Integrations

**Problem:** Stacks node and sBTC relay networking relies on static configs and centralized relays, creating single points of failure. There is no Elixir-native, FLAME-compatible P2P overlay for Stacks.

**Solution:** A Stacks-specific overlay backend for Zeiroh that provides Iroh-based DHT node discovery, FLAME-compatible off-chain workers for distributed indexers/monitors, and Zenoh pub/sub for sBTC relay coordination — all from Elixir.

**What you will ship and by when:**
- Week 5: Iroh DHT-based Stacks node discovery + FLAME overlay for distributed indexers/monitors
- Week 10: Zenoh pub/sub for sBTC relay coordination + Burrito binary

**How this helps Stacks:** Zeiroh is the FLAME execution layer for Stacks off-chain workers. It eliminates static peer list maintenance, enables geo-redundant sBTC relay networks, and gives dApp developers a standard way to spawn distributed indexers, monitors, and fraud detectors using Phoenix FLAME + Elixir.

**Budget:** $5,000 STX — development, testing, security review, documentation.

**Team:** Solo builder with 6+ open-source Elixir projects, including Zeiroh (FLAME overlay for Iroh/Zenoh), IngotCluster (Iroh+Zenoh), Crucible (multi-cloud provisioner), Gale (HTTP/3), Orian (S3/S5 transfer), and Dusk (Zenoh cluster). All published on Hex.pm with CI, docs, and community funding.

**What makes Zeiroh different from IngotCluster and Dusk:** Zeiroh is the only one that combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P. IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Zeiroh is the execution layer.

**Final adoption metric:** Number of Stacks node operators using `Zeiroh.Stacks` for peer discovery or FLAME worker deployment in production or test environments, measured by GitHub issue reports, forum mentions, and direct feedback. Target: 3+ operators reporting successful deployment within 30 days of v0.3.0.
