# Zeiroh Stacks Grant — Submission Checklist

**Portal:** https://portal.stacksendowment.co/apply/cycle-3  
**Deadline:** September 23, 2026  
**Track:** Getting Started Grant  
**Theme:** Distribution & Integrations  

---

## Form Fields

### Project Name
```
Zeiroh — Stacks Distributed Overlay
```

### Track
```
Getting Started Grant
```

### Theme
```
Distribution & Integrations
```

### Problem Statement
```
Stacks node and sBTC relay networking relies on static configs and centralized relays, creating single points of failure. Node operators manually configure peers in stacks-node.toml, and relay coordination depends on centralized message brokers. There is no Elixir-native, FLAME-compatible P2P overlay designed for Stacks infrastructure. Zeiroh fills this gap as the Phoenix FLAME execution layer for Stacks off-chain workers.
```

### Solution
```
Zeiroh adds a Stacks-specific overlay backend that provides Iroh-based DHT node discovery, FLAME-compatible off-chain workers for distributed indexers/monitors, and Zenoh pub/sub for sBTC relay coordination. All from Elixir, composable with existing Stacks tooling. Zeiroh is unique because it combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P — IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Only Zeiroh is the execution layer.
```

### What You Will Ship
```
Milestone 1 (Week 5): Iroh DHT-based Stacks node discovery + FLAME overlay for distributed indexers/monitors
Milestone 2 (Week 10): Zenoh pub/sub for sBTC relay coordination + Burrito binary
```

### How This Helps Stacks
```
Makes Stacks node and relay networking resilient, distributed, and fault-tolerant without centralized infrastructure. Zeiroh is the FLAME execution layer for Stacks off-chain workers: distributed burnchain indexers, sBTC relay health monitors, and signer node health watchers — all auto-discovering via Iroh/Zenoh.
```

### Budget
```
$5,000 STX — development (4,000 STX), cloud infrastructure for testing (400 STX), security review (250 STX), documentation and demos (200 STX), buffer (150 STX)
```

### Team
```
Solo builder with 6+ open-source Elixir projects, including Zeiroh (FLAME overlay for Iroh/Zenoh), IngotCluster (Iroh+Zenoh cluster), Crucible (multi-cloud provisioner), Gale (HTTP/3), Orian (S3/S5 transfer), and Dusk (Zenoh cluster). All MIT-licensed with CI and docs.
```

---

## Links

- GitHub: https://github.com/niranjanaryan/zeiroh
- Hex.pm: https://hex.pm/packages/zeiroh
- Proposal: https://github.com/niranjanaryan/zeiroh/blob/main/STACKS_GRANT.md

---

## Milestones

### Milestone 1
- **Title:** Stacks Node Discovery + FLAME Overlay
- **Amount:** $2,500 STX
- **Duration:** Weeks 1–5
- **Deliverables:** 
  - Iroh DHT namespace for Stacks nodes (`stacks/node/1` ALPN)
  - CLI: `zeiroh stacks peers`
  - Node identity from Stacks address
  - `Zeiroh.FLAME.Backend` with Stacks overlay config
  - Distributed burnchain indexer example
  - Signer node health watcher example
  - Tests: mock Iroh DHT, FLAME worker lifecycle

### Milestone 2 (Final)
- **Title:** sBTC Relay Pub/Sub + Production Packaging
- **Amount:** $2,500 STX
- **Duration:** Weeks 6–10
- **Deliverables:**
  - Zenoh pub/sub for sBTC relay state (`stacks/sbtc/relay/**`)
  - sBTC relay health monitor example
  - Relay status aggregation and conflict detection
  - Burrito single-binary build
  - Performance benchmarks: discovery latency, message throughput, failover time
  - Security review of peer identity and message authentication
  - Final adoption metric: 3+ operators reporting successful deployment within 30 days of v0.3.0

---

## Disbursement
```
50% at Milestone 1 (Week 5)
50% at Milestone 2 (Week 10)
```
