# Zeiroh Consumer Awareness

## Target Audience

| Segment | Who they are | Why they care |
|---------|-------------|---------------|
| Stacks node operators | Phoenix FLAME integration | P2P overlay for distributed workers |
| sBTC relay operators | Spawning distributed workers | Auto-discovery via Iroh/Zenoh |
| dApp developers | P2P off-chain services | Phoenix LiveView + FLAME + Stacks |
| Phoenix/LiveView teams | Distributed workers | Composable with Crucible provisioning |

## Awareness Channels

### Stacks Ecosystem
- **Stacks Forum:** FLAME overlay tutorial, distributed worker examples
- **Stacks Discord:** Q&A, demos, office hours
- **Stacks GitHub:** Issues, discussions, PRs

### Elixir Ecosystem
- **Elixir Forum:** "P2P Phoenix workers with Zeiroh"
- **Hex.pm:** Package description, docs, changelogs
- **GitHub:** Issues, discussions, stars, forks

### Social Media
- **Twitter/X:** Demo videos, benchmark screenshots
- **Reddit r/elixir:** Cross-post tutorials
- **YouTube:** Full demo screencast

## Content Strategy

### Blog Posts / Tutorials
1. **"Phoenix FLAME Workers for Stacks with Zeiroh"**
   - `Zeiroh.Stacks` backend setup
   - `zeiroh flame --overlay stacks` CLI walkthrough
   - Distributed Stacks indexer example
   - Target: Phoenix/LiveView teams

2. **"P2P Off-Chain Services for Stacks dApps"**
   - Iroh-based P2P discovery
   - Zenoh pub/sub for relay coordination
   - Auto-discovery of FLAME workers
   - Target: dApp developers

3. **"Zeiroh + Crucible: Provisioned FLAME Workers for Stacks"**
   - Cross-cloud worker provisioning
   - Auto-discovery via Iroh/Zenoh
   - Distributed relay monitor example
   - Target: sBTC relay operators

### Demo Videos
- **5 min:** FLAME workers auto-discovering each other
- **5 min:** Distributed Stacks indexer with Zeiroh + Crucible

### Benchmark Publications
- `benchmark/FLAME_SPAWN_TIME.md` — Worker spawn latency
- `benchmark/DISCOVERY_LATENCY.md` — Time-to-discovery for workers

## Adoption Metrics

| Metric | Baseline | 30-day target | 90-day target |
|--------|----------|---------------|---------------|
| Hex downloads | 0 | 150+ | 800+ |
| GitHub stars | 0 | 30+ | 150+ |
| Stacks Forum replies | 0 | 5+ | 20+ |
| Blog post views | 0 | 400+ | 1,500+ |
| Demo video views | 0 | 150+ | 800+ |

## Timeline

### Week 1-2
- [ ] Publish FLAME tutorial
- [ ] Post Stacks Forum thread
- [ ] Record worker discovery demo

### Week 3-4
- [ ] Publish P2P off-chain services tutorial
- [ ] Post Elixir Forum thread
- [ ] Submit Reddit r/elixir cross-post

### Week 5-8
- [ ] Publish Zeiroh + Crucible integration guide
- [ ] Monitor and respond to feedback
- [ ] Update benchmarks

## Key Messages

**For Stacks operators:**
> "Phoenix FLAME + P2P overlay for Stacks. Spawn distributed workers that auto-discover each other via Iroh/Zenoh."

**For Elixir developers:**
> "The only Elixir package combining Phoenix LiveView, FLAME, Iroh, and Zenoh in a single overlay. Composable with Crucible for provisioning."

## Competitive Positioning

| Competitor | Gap we fill |
|------------|-------------|
| Generic FLAME backends | Stacks-specific overlay with Iroh/Zenoh |
| Generic P2P libs | Phoenix/FLAME integration, not just networking |
| Single-backend overlays | Iroh + Zenoh in one package |
| No Stacks integration | First-class Stacks overlay for Phoenix FLAME |

**Our advantage:** Only Elixir package combining Phoenix LiveView, FLAME, Iroh, and Zenoh with a Stacks-specific overlay.

---

*This document is part of the Elixir Distributed Stack consumer awareness strategy.*
