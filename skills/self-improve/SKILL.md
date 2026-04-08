---
name: self-improve
description: "Activates autonomous code improvement — competing strategies, benchmarking, tournament selection"
tags:
  - optimization
  - autonomous
---

## Activation

This skill activates the **self-improve agent** for measurable code optimization.

The agent will:
- Analyze the target area and capture baseline metrics
- Generate 2-3 competing improvement hypotheses
- Implement and benchmark each approach
- Tournament-select: keep only what measurably improves
- Iterate until target met or budget exhausted

## Trigger Keywords

self-improve, autonomous optimization, improve performance, optimize

## Persistence

- Config: `.omg/research/self-improve/config.json`
- Baseline: `.omg/research/self-improve/baseline.json`
- History: `.omg/research/self-improve/history/`

## When NOT to Use

- Single targeted fix → use @omg:executor
- Need to understand before changing → use deep-dive or trace
- No benchmark/metric available → define one first

## Example

```bash
copilot -i "self-improve: optimize pipeline performance"
```

## Quality Contract

- Benchmark before and after, tournament-select best approach
