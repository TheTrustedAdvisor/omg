---
name: handoff-protocol
description: "Standard persistence and handoff protocol for inter-agent communication"
tags:
  - reference
  - protocol
---

## .omg/ Directory Convention

All inter-agent data flows through `.omg/` with defined subdirectories:

| Directory | Purpose | Producers | Consumers |
|-----------|---------|-----------|-----------|
| `.omg/plans/` | Work plans with acceptance criteria | planner, plan skill | autopilot, ralph, team, verifier |
| `.omg/research/` | Analysis output, specs, findings | analyst, architect, explore, deep-interview, tracer | planner, executor, autopilot |
| `.omg/reviews/` | Review verdicts, critique feedback | critic, code-reviewer, security-reviewer, verifier | planner (revision), executor (fixes) |
| `.omg/qa-logs/` | Iteration state for cyclical workflows | ultraqa, autopilot (Phase 3), ralph | Same skills (next iteration) |

## store_memory Keys

| Key | Value | Set by | Read by |
|-----|-------|--------|---------|
| `omg:active-plan` | `{ path, title, steps, created }` | planner | autopilot, ralph, team |
| `omg:active-spec` | `{ path, title, created }` | deep-interview, analyst | planner, autopilot |
| `omg:last-review` | `{ path, verdict, reviewer, created }` | critic, code-reviewer, verifier | planner, executor |

## Handoff Contract (for producing agents)

When delegating to another agent via `task`, always:

1. **Persist output** to the appropriate `.omg/` subdirectory
2. **Include in the task prompt:** the file path to your output, not the full content
3. **For CRITICAL/HIGH findings:** extract actionable items as a numbered list in the prompt
4. **For rejections:** include specific items to fix, not just "it failed"

## Input Discovery (for consuming agents)

Before starting work, always:

1. **Check `store_memory`** for relevant keys (`omg:active-plan`, `omg:active-spec`, `omg:last-review`)
2. **Check `.omg/` directories** via `glob` for relevant files
3. **Read the most recent relevant file** to get full context
4. **If nothing found:** proceed with the task prompt as sole context
