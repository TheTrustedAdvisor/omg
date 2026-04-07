---
name: ralplan
description: "Activates consensus planning — multi-perspective review with planner, architect, and critic"
tags:
  - planning
  - consensus
---

## Activation

This skill activates the **planner agent** in **consensus mode**.

Consensus mode = planner creates plan → architect reviews → critic evaluates → iterate until agreement.

## Trigger Keywords

ralplan, consensus, consensus planning, multi-perspective plan

## Persistence

- Review history: `.omg/reviews/ralplan-log.md`
- Final plan: `.omg/plans/`
- ADR: `.omg/research/adr-{name}.md`
- Index: `store_memory` key `omg:active-plan`
