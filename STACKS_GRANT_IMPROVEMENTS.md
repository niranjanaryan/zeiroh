# Zeiroh Stacks Grant — Improvement Plan

**Date:** 2026-09-08  
**Grant Cycle:** Q3 2026  
**Deadline:** September 23, 2026  
**Portal:** https://portal.stacksendowment.co/apply/cycle-3  
**Current Request:** $6,000 STX  
**Proposed Request:** $5,000 STX  

---

## Current State

**Files:**
- `zeiroh/STACKS_GRANT.md` — 217 lines, application draft
- `zeiroh/STACKS_GRANT_SUBMISSION.md` — 95 lines, submission checklist
- `zeiroh/STACKS_GRANT_PORTAL_ANSWERS.md` — 249 lines, all 8 portal sections answered
- Committed as `83ecf0f`

**Strengths:**
- Clear problem/solution structure
- 2 milestones with 50/50 split (appropriate for under $7,000)
- Complete portal answers for all 8 sections
- Track record of 6+ open-source Elixir projects
- Existing Zeiroh codebase on Hex.pm with FLAME backend

**Weaknesses:**
- Overlaps significantly with IngotCluster and Dusk Stacks applications
- Generic use cases; lacks Stacks-specific scenarios
- Limited technical specificity in implementation details
- No explicit differentiation from existing solutions
- Final adoption metric is vague
- Budget could be tighter for a Getting Started Grant

---

## Recommended Improvements

### 1. Pivot Identity: FLAME Execution Layer

**Current framing:** "Zeiroh is a P2P overlay for Stacks"  
**Recommended framing:** "Zeiroh is the Phoenix FLAME execution layer for Stacks off-chain workers"

**Rationale:** Zeiroh's unique value is not generic P2P — it is the ability to **spawn distributed workers** via Phoenix FLAME. IngotCluster handles cluster membership; Dusk handles Zenoh-first clustering. Only Zeiroh can claim the FLAME execution layer angle.

**Changes:**
- Rewrite §1 Project Summary to lead with FLAME worker spawning
- Rewrite §3 Solution to emphasize distributed off-chain workers first, P2P second
- Rewrite §4 Why This Matters to focus on off-chain services (indexers, monitors, fraud detectors)
- Update CLI examples to show `zeiroh flame --overlay stacks` as primary use case

### 2. Add Concrete Stacks Use Cases

**Current examples:**
- Generic "distributed block indexer"
- Generic "sBTC relay health monitor"

**Recommended examples:**
1. **Distributed burnchain indexer:** FLAME workers shard burnchain block ranges, auto-discover via Iroh, publish results via Zenoh. Operators get near-real-time indexing without a single point of failure.
2. **sBTC relay health monitor:** FLAME workers probe multiple relays, aggregate status via Zenoh, auto-spawn replacements when relays degrade.
3. **Signer node health watcher:** Lightweight FLAME workers deployed alongside signer nodes watch for missed blocks, connectivity drops, or PoX-5 voting misconfig, and alert via Zenoh.

**Changes:**
- Add these to §3 Solution with code snippets
- Add to §6 Milestones as explicit deliverables

### 3. Strengthen Technical Specificity

**Current state:** High-level architecture only  
**Recommended:** Add implementation details that show the project is real

**Changes:**
- Add to §3 Solution:
  - Iroh DHT namespace: `stacks/node/1` ALPN
  - Peer records: `stx.address`, IP, port, `stacks-node` version, last-seen timestamp
  - FLAME overlay config: `overlay: :stacks` injects `FLAME_PARENT` and Iroh bootstrap tickets
  - Zenoh key space: `stacks/sbtc/relay/**` with `{height, status, latency}` published every block
- Add to §6 Milestones:
  - Specific API endpoints for health checks
  - Specific test scenarios (mocked DHT, FLAME worker lifecycle)

### 4. Clarify Differentiation

**Current state:** No comparison to alternatives  
**Recommended:** Add "Why not X?" block

**Changes:**
- Add to §3 Solution or §4 Why This Matters:
  - **libp2p wrappers:** Generic, not Elixir-native, no Phoenix FLAME integration
  - **libcluster strategies:** Discovery only, no off-chain worker spawning, no pub/sub relay coordination
  - **Custom Ansible/Terraform:** One-off, not self-healing, no P2P data plane

### 5. Strengthen Proof of Work

**Current state:** Generic "6+ open-source repos"  
**Recommended:** Add concrete Zeiroh metrics

**Changes:**
- Add to §10 Proof of Work:
  - Current Hex version/download count
  - CI status badge
  - Link to EVAL.md / SCALING.md if they show honest limits and roadmap
  - Specific FLAME backend demo (even if not Stacks-specific yet)

### 6. Tighten Post-Grant Sustainability

**Current state:** Generic "no exit strategy"  
**Recommended:** Add concrete 90-day and 6-month plans

**Changes:**
- Rewrite §9 Ecosystem Commitment:
  - **Month 1–3:** Bug fixes, community contributions, label `good first issue` for Stacks-specific work
  - **Month 3–6:** Add support for Stacks `sbtc_trustless_set` events as Zenoh topic; integrate with `stacks-node` v3.x if released
  - **Adoption target:** 50+ GitHub stars, 100+ Hex downloads, 1+ community-contributed Stacks template within 90 days of v0.3.0

### 7. Reduce Ask to $5,000

**Current ask:** $6,000  
**Recommended ask:** $5,000  

**Rationale:** $6,000 for 10 weeks is ~$600/week. For a Getting Started Grant, $5,000 is more typical and scores better on budget reasonableness. The work can realistically be done for $5,000 by tightening scope slightly.

**Changes:**
- Update budget table:
  - Development: 4,000 STX (10 weeks at ~400 STX/week)
  - Cloud infra testing: 400 STX
  - Security review: 250 STX
  - Documentation: 150 STX
  - Buffer: 200 STX
  - **Total: 5,000 STX**
- Update milestones to 50/50 split:
  - M1 (Week 5): $2,500
  - M2 (Week 10): $2,500

### 8. Improve Final Adoption Metric

**Current metric:** "GitHub stars + Hex downloads" (vague)  
**Recommended metric:** Specific, measurable, time-bound

**Changes:**
- Replace with: "Number of Stacks node operators using `Zeiroh.Stacks` for peer discovery in production or test environments, measured by GitHub issue reports, forum mentions, and direct feedback. Target: 3+ operators reporting successful deployment within 30 days of v0.3.0."

---

## Implementation Priority

| Priority | Improvement | Effort | Impact |
|----------|-------------|--------|--------|
| P0 | Pivot identity to FLAME execution layer | High | High |
| P0 | Reduce ask to $5,000 | Low | High |
| P1 | Add concrete Stacks use cases | Medium | High |
| P1 | Improve final adoption metric | Low | Medium |
| P2 | Strengthen technical specificity | Medium | Medium |
| P2 | Clarify differentiation | Low | Medium |
| P3 | Strengthen proof of work | Low | Low |
| P3 | Tighten post-grant sustainability | Low | Low |

---

## Files to Update

1. `zeiroh/STACKS_GRANT.md` — main application
2. `zeiroh/STACKS_GRANT_SUBMISSION.md` — submission checklist
3. `zeiroh/STACKS_GRANT_PORTAL_ANSWERS.md` — portal answers

---

## Risks of Not Improving

1. **Reviewer confusion:** Zeiroh, IngotCluster, and Dusk look like the same project
2. **Weak differentiation:** No clear reason to fund Zeiroh over its siblings
3. **Budget concerns:** $6,000 may seem high for a Getting Started Grant
4. **Vague metrics:** Hard for reviewers to evaluate success

---

## Expected Outcome

After improvements, Zeiroh's application will:
- Have a clear, unique identity as the FLAME execution layer for Stacks
- Show concrete, Stacks-specific use cases that reviewers can visualize
- Present a realistic $5,000 budget appropriate for the track
- Include measurable success criteria
- Differentiate clearly from IngotCluster and Dusk

---

## Approval

This improvement plan was prepared on 2026-09-08. Implementation requires:
- [ ] Review and approve suggested changes
- [ ] Update STACKS_GRANT.md with P0 improvements
- [ ] Update STACKS_GRANT_PORTAL_ANSWERS.md to match
- [ ] Re-commit and push
- [ ] Submit via portal
