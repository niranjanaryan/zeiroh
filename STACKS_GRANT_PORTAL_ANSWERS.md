# Zeiroh — Stacks Grant Portal Answers

**Cycle:** Q3 2026  
**Deadline:** September 23, 2026  
**Portal:** https://portal.stacksendowment.co/apply/cycle-3  

---

## Section 01 — Applicant Identity
**Status:** Already complete in portal  
- Applicant: Individual · Niranjan A
- Contact: Niranjan Anand
- Jurisdiction: INDIA

---

## Section 02 — Project

### Project Name
```
Zeiroh — Stacks Distributed Overlay
```

### Website or Repo (optional)
```
https://github.com/niranjanaryan/zeiroh
```

### Primary Category
```
Developer Tools & Infrastructure
```

### Secondary Category
```
Developer Tools & Infrastructure - Infrastructure
```

### Project Description
```
Zeiroh is the Phoenix FLAME execution layer for Iroh (P2P QUIC) and Zenoh (brokered pub/sub). This grant adds a Stacks-specific overlay backend that lets Stacks operators spawn distributed off-chain workers — indexers, relay monitors, fraud detectors — from Elixir, with auto-discovery, self-healing networking, and pub/sub coordination built in. Today, Stacks node operators rely on static peer lists and centralized APIs. Zeiroh replaces these with a self-healing P2P data plane: Iroh DHT for node discovery, FLAME workers for distributed indexers and monitors, and Zenoh pub/sub for sBTC relay coordination. The result is resilient, low-latency node networking that works across clouds and firewalls. Zeiroh is unique because it combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P — IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Only Zeiroh is the execution layer.
```

---

## Section 03 — Audience and Ecosystem Fit

### Primary Audience
```
Stacks node operators, PoX-5 Stackers, sBTC relay operators, and Elixir developers building distributed off-chain services.
```

### Audience Segmentation
```
1. PoX-5 Stackers running signer nodes that need resilient peer discovery without static configs
2. sBTC relay operators coordinating across multiple regions without centralized brokers
3. dApp developers building distributed indexers, monitors, and fraud detectors using Phoenix FLAME
4. Elixir/Erlang teams wanting native P2P tooling for Stacks infrastructure
```

### Why Stacks?
```
PoX-5, sBTC, and the Nakamoto upgrade are scaling Stacks node infrastructure demand. Today, node operators manually configure peers in stacks-node.toml and rely on centralized RPC endpoints. This creates single points of failure and limits geographic redundancy. Zeiroh provides Iroh-based DHT discovery and Zenoh pub/sub, giving Stacks operators a self-healing P2P data plane written in Elixir. Zeiroh is unique because it is the only tool that combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P — operators can deploy distributed workers that auto-discover each other and coordinate without manual networking. This matters because Stacks needs resilient networking primitives that can operate across clouds, behind NAT, and at the edge — exactly what Iroh and Zenoh were designed for.
```

### Maintenance Plan
```
Zeiroh is MIT-licensed and maintained as part of a broader Elixir infrastructure toolkit (Crucible, Gale, IngotCluster, Orian, Dusk). The Stacks overlay will receive bug fixes and protocol updates as part of ongoing maintenance. Issues are tracked on GitHub with labeled milestones. Community contributions are welcome via issue templates and CONTRIBUTING.md. After the grant, the overlay will evolve with Stacks releases and Iroh/Zenoh protocol updates. No exit strategy — this is core networking infrastructure.
```

### Ecosystem Fit
```
This project directly supports the Q3 2026 "Distribution & Integrations" theme. Zeiroh connects Stacks nodes, relays, and dApps in a distributed, fault-tolerant way. It enables geo-redundant sBTC relay networks, eliminates static peer list maintenance, and gives dApp developers a standard FLAME-compatible overlay for distributed workers. The result is a more resilient Stacks network that can scale node infrastructure without centralization bottlenecks. Zeiroh's unique value is the FLAME execution layer — not just networking, but spawning and coordinating distributed workers from Elixir.
```

---

## Section 04 — Risk and Prior History

### Prior Grant History
```
No prior Stacks grants. First application.
```

### Prior Projects / Track Record
```
Active maintainer of 6+ open-source Elixir repos with CI, docs, and community funding:
- Zeiroh (Phoenix FLAME overlay for Iroh/Zenoh, published on Hex.pm)
- IngotCluster (Iroh+Zenoh cluster, published on Hex.pm)
- Crucible (multi-cloud provisioner, published on Hex.pm v0.1.1)
- Gale (HTTP/3 Phoenix adapter, published on Hex.pm)
- Orian (S3/S5 transfer, published on Hex.pm)
- Dusk (Zenoh-first cluster, published on Hex.pm)

All projects are MIT-licensed with GitHub Actions CI, hex docs, and community funding pages.
```

### Key Risks
```
1. Iroh/Zenoh protocol changes — Mitigation: pin to stable releases; abstract protocol layer
2. Stacks node config incompatibility — Mitigation: support stacks-node v2.x+; document version pinning
3. NAT traversal issues for P2P — Mitigation: use Iroh's hole-punching; fallback to Zenoh brokered mode
4. Scope creep (too many Stacks features) — Milestone 1 is discovery+FLAME only; Milestone 2 is relay coordination
5. Solo builder bandwidth — 10 weeks, focused scope; existing Zeiroh codebase reduces risk
```

---

## Section 05 — Track and Qualification
**Status:** Already complete in portal  
- Track: Getting Started
- Requested: $5,000 STX
- Qualification: Open track, no gates

---

## Section 06 — Track-Specific Context

### What are you proposing to explore or build?
```
A Stacks-specific overlay backend for Zeiroh that provides Iroh-based DHT node discovery, FLAME-compatible off-chain workers for distributed indexers/monitors, and Zenoh pub/sub for sBTC relay coordination. All from Elixir, composable with existing Stacks tooling. Zeiroh is unique because it is the only tool that combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P.
```

### What user or ecosystem problem motivates the project?
```
Stacks node operators rely on static peer lists in stacks-node.toml and centralized RPC endpoints. If a peer goes down, discovery halts. sBTC relay operators use centralized message brokers. There is no Elixir-native, FLAME-compatible P2P overlay designed for Stacks infrastructure. This limits geographic redundancy, creates single points of failure, and forces operators to maintain manual networking configs. Stacks dApps that need distributed workers have no standard way to spawn and coordinate them from Elixir.
```

### Why is Stacks the right environment for this work?
```
Stacks is scaling node infrastructure with PoX-5, sBTC, and the Nakamoto upgrade. The ecosystem needs resilient, low-latency networking that doesn't depend on static configs or centralized relays. Zeiroh's Iroh/Zenoh-based P2P overlay is a natural fit: both protocols speak QUIC, work behind NAT, and are designed for distributed systems. Zeiroh is unique because it is the only tool that combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P. The result is Stacks infrastructure that can self-heal, auto-discover, and coordinate without manual intervention — capabilities that align with Stacks' Bitcoin-native, decentralized mission.
```

### What have you already validated, prototyped, or learned?
```
Zeiroh is already published on Hex.pm with a working FLAME backend for Iroh/Zenoh. The core overlay mechanisms — DHT discovery, pub/sub, FLAME worker spawning — are proven in the existing codebase. IngotCluster provides additional Iroh+Zenoh cluster primitives. The Stacks overlay is a configuration and integration layer on top of this proven foundation, not a research project. We know the protocols work; the grant funds Stacks-specific templates, testing, and documentation. Zeiroh is ready to extend to Stacks; this is not a speculative project.
```

### Who will do the work and what experience do they bring?
```
Niranjan Aryan — solo builder with 6+ open-source Elixir projects. Built Zeiroh (FLAME overlay for Iroh/Zenoh), IngotCluster (Iroh+Zenoh cluster), Crucible (multi-cloud provisioner), Gale (HTTP/3), Orian (S3/S5 transfer), and Dusk (Zenoh cluster). All published on Hex.pm with CI, docs, and community funding. Deep expertise in Elixir, distributed systems, P2P networking, and FLAME.
```

### What is the smallest useful outcome this grant should produce?
```
A working Zeiroh.Stacks backend that enables Iroh DHT-based peer discovery for Stacks nodes, with a CLI command to discover and list peers. This gives operators an immediate alternative to static peer lists, with auto-discovery and failover built in.
```

### What evidence will show the concept is worth continuing?
```
1. Published Zeiroh.Stacks backend with working DHT discovery tests
2. Successful demo of two Stacks nodes discovering each other via Iroh without manual config
3. Community feedback from Stacks node operators
4. Integration with existing Stacks tooling (stacks-node, sBTC relay software)
5. Adoption metrics: GitHub stars, Hex downloads, community contributions
```

### What dependencies or risks could affect delivery?
```
1. Iroh/Zenoh protocol changes — pinned to stable releases; protocol layer abstracted
2. Stacks node config incompatibility — support stacks-node v2.x+; document version pinning
3. NAT traversal — use Iroh's hole-punching; fallback to Zenoh brokered mode
4. Scope creep — Milestone 1 is discovery+FLAME only; Milestone 2 is relay coordination
5. Solo builder bandwidth — 10 weeks, focused scope; existing Zeiroh codebase reduces risk
```

### What support from the Stacks ecosystem would help?
```
1. Feedback from Stacks node operators on discovery requirements
2. Early testing of Iroh DHT with real stacks-node deployments
3. Documentation of Stacks-specific networking constraints
4. Community promotion to Stackers and relay operators
5. Integration testing with existing Stacks tooling
```

### How will you share progress or learnings publicly?
```
1. Weekly GitHub commits with public progress
2. Monthly blog posts or forum updates on Stacks forum
3. Screencasts showing node discovery and FLAME worker deployment
4. Open issues for community feedback
5. Published Hex package with full documentation
6. Stacks community event demo at completion
```

### What happens after the grant if the work succeeds?
```
The Stacks overlay becomes a permanent part of Zeiroh, maintained as part of the broader Elixir infrastructure toolkit. It will receive bug fixes, protocol updates, and new Stacks features as part of ongoing maintenance. The overlay will evolve with Stacks releases and Iroh/Zenoh protocol changes. Community contributions will be welcomed via labeled issues. No exit strategy — this is core networking infrastructure for Stacks operators.
```

### Any other context reviewers should consider?
```
Zeiroh already has a working FLAME backend for Iroh/Zenoh. The Stacks overlay is not a research project — it's an extension of proven code. The 10-week timeline is realistic because the core discovery, pub/sub, and FLAME mechanisms are already implemented. Zeiroh is unique in the Stacks ecosystem because it is the only tool that combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P — IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Only Zeiroh is the execution layer. This is a low-risk, high-impact project that addresses a clear gap in the Stacks ecosystem with existing, battle-tested code.
```

---

## Section 07 — Compliance Readiness

### Individual Applicant Readiness
```
I have reviewed the Vouched ID requirements and will be able to complete the required KYC through Vouched if selected.
```

---

## Section 08 — Milestones

### Milestone 1
- **Name:** Stacks Node Discovery + FLAME Overlay
- **Target date:** 5 weeks from project start
- **Description:** Working Zeiroh.Stacks backend with Iroh DHT-based node discovery and FLAME overlay for distributed off-chain workers. Includes DHT namespace for Stacks nodes, CLI commands, node identity from Stacks address, FLAME backend config with `FLAME_PARENT` and Iroh bootstrap ticket injection, distributed burnchain indexer example, signer node health watcher example, and Crucible integration.
- **Success criteria:** Published v0.2.0 with docs and tutorial showing Stacks nodes discovering each other via Iroh and FLAME workers auto-discovering for indexer/monitor workloads
- **Payment percent:** 50
- **Amount:** 2,500 STX

### Milestone 2 (Final)
- **Name:** sBTC Relay Pub/Sub + Production Packaging
- **Target date:** 10 weeks from project start
- **Description:** Zenoh-based relay coordination and Burrito binary packaging. Includes Zenoh pub/sub for sBTC relay state, relay status aggregation and conflict detection, Burrito single-binary build, performance benchmarks for discovery latency and message throughput, and security review of peer identity and message authentication.
- **Success criteria:** Published v0.3.0, demo at Stacks community event or forum post, and open issues for relay operator feedback
- **Payment percent:** 50
- **Amount:** 2,500 STX
- **Final adoption metric:** Number of Stacks node operators using `Zeiroh.Stacks` for peer discovery or FLAME worker deployment in production or test environments, measured by GitHub issue reports, forum mentions, and direct feedback. Target: 3+ operators reporting successful deployment within 30 days of v0.3.0.

---

## Quick Copy-Paste Summary

**Project name:** Zeiroh — Stacks Distributed Overlay

**Problem:** Stacks node and sBTC relay networking relies on static configs and centralized relays, creating single points of failure. There is no Elixir-native, FLAME-compatible P2P overlay for Stacks.

**Solution:** A Stacks-specific overlay backend for Zeiroh that provides Iroh-based DHT node discovery, FLAME-compatible off-chain workers for distributed indexers/monitors, and Zenoh pub/sub for sBTC relay coordination. Zeiroh is unique because it combines Phoenix FLAME worker spawning with Iroh/Zenoh P2P — IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Only Zeiroh is the execution layer.

**What you will ship:**
- Week 5: Iroh DHT-based Stacks node discovery + FLAME overlay for distributed indexers/monitors
- Week 10: Zenoh pub/sub for sBTC relay coordination + Burrito binary

**Budget:** $5,000 STX — development, testing, security review, documentation

**Team:** Solo builder, 6+ open-source Elixir projects, maintains Zeiroh, IngotCluster, Crucible, Gale, Orian, Dusk

**Differentiation:** Zeiroh is the FLAME execution layer. IngotCluster = cluster membership. Dusk = Zenoh-first clustering. Zeiroh = spawn + coordinate distributed workers.
