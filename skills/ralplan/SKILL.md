---
name: ralplan
description: "Activates consensus planning — iterative multi-perspective review until agreement"
tags:
  - planning
  - consensus
---

## Activation

This skill activates the **ralplan agent** for consensus-driven planning.

The ralplan agent orchestrates a structured dialogue:
1. Planner creates initial plan with principles, drivers, options
2. Architect reviews for soundness — provides antithesis and trade-offs
3. Critic evaluates quality — verifies testable criteria
4. If rejected: iterate (max 5 rounds)
5. On approval: produce ADR (Architecture Decision Record)

## Trigger Keywords

ralplan, consensus, consensus planning

## Persistence

- Review history: `.omg/reviews/ralplan-log.md`
- Final plan: `.omg/plans/ralplan-result.md`
- ADR: `.omg/research/adr-{name}.md`
- Index: `store_memory` key `omg:active-plan`

## Quality Contract

- Multi-perspective review (planner + architect + critic)
- Iterate on rejection — address every finding
- All rounds persisted for cross-session history
