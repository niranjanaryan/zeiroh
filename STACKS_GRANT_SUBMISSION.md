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
Stacks node and sBTC relay networking relies on static configs and centralized relays, creating single points of failure. Node operators manually configure peers in stacks-node.toml, and relay coordination depends on centralized message brokers. There is no Elixir-native P2P overlay designed for Stacks infrastructure.
```

### Solution
```
Zeiroh adds a Stacks-specific overlay backend that provides Iroh-based DHT node discovery, FLAME-compatible off-chain workers for distributed indexers and monitors, and Zenoh pub/sub for sBTC relay coordination. All from Elixir, composable with existing Stacks tooling.
```

### What You Will Ship
```
Milestone 1 (Week 3): Iroh DHT-based Stacks node discovery with stable peer IDs
Milestone 2 (Week 7): FLAME backend for distributed Stacks indexers and relay monitors
Milestone 3 (Week 10): Zenoh pub/sub for sBTC relay state synchronization
```

### How This Helps Stacks
```
Makes Stacks node and relay networking resilient, distributed, and fault-tolerant without centralized infrastructure. Enables geo-redundant sBTC relay networks and distributed off-chain workers for indexers and monitors.
```

### Budget
```
$6,000 STX — development (5,000 STX), cloud infrastructure for testing (500 STX), security review (250 STX), documentation (150 STX), buffer (100 STX)
```

### Team
```
Solo builder with 6+ open-source Elixir projects, including Zeiroh (FLAME overlay for Iroh/Zenoh), IngotCluster (Iroh+Zenoh cluster), Crucible (multi-cloud provisioner), Gale (HTTP/3), and Orian (S3/S5 transfer). All MIT-licensed with CI and docs.
```

---

## Links

- GitHub: https://github.com/niranjanaryan/zeiroh
- Hex.pm: https://hex.pm/packages/zeiroh
- Proposal: https://github.com/niranjanaryan/zeiroh/blob/main/STACKS_GRANT.md

---

## Milestones

### Milestone 1
- **Title:** Stacks Node Discovery via Iroh DHT
- **Amount:** $2,000 STX
- **Duration:** Weeks 1–3
- **Deliverables:** Iroh DHT namespace for Stacks nodes, CLI: `zeiroh stacks peers`, node identity from Stacks address

### Milestone 2
- **Title:** FLAME Overlay for Stacks Off-Chain Services
- **Amount:** $2,000 STX
- **Duration:** Weeks 4–7
- **Deliverables:** FLAME backend with Stacks overlay, distributed indexer example, relay monitor example

### Milestone 3
- **Title:** sBTC Relay Pub/Sub + Production Packaging
- **Amount:** $2,000 STX
- **Duration:** Weeks 8–10
- **Deliverables:** Zenoh pub/sub for relay state, Burrito binary, benchmarks

---

## Disbursement
```
50% at Milestone 1 (Week 3)
50% at Milestone 3 (Week 10)
```
