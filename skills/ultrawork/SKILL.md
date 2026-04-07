---
name: ultrawork
description: "Parallel execution engine — fires multiple agents simultaneously for independent tasks"
tags:
  - execution-mode
  - parallel
---

## When to Use

- Multiple independent tasks can run simultaneously
- User says "ultrawork" or wants parallel execution
- Task benefits from concurrent execution

## When NOT to Use

- Task requires guaranteed completion with verification → use ralph (includes ultrawork)
- Full autonomous pipeline → use autopilot (includes ralph which includes ultrawork)
- Single sequential task → delegate directly to @executor

## Relationship to Other Modes

```
autopilot (full lifecycle)
 └── ralph (persistence + verification)
     └── ultrawork (parallel execution)
```

Ultrawork is the parallelism layer. Ralph adds persistence and verification. Autopilot adds the full lifecycle pipeline.

## Workflow

### 1. Classify Tasks
Identify which tasks can run in parallel vs which have dependencies.

### 2. Route by Complexity
- Simple lookups/definitions → invoke @executor (lightweight)
- Standard implementation → invoke @executor (standard)
- Complex analysis/refactoring → invoke @executor or @architect (thorough)

### 3. Fire Independent Tasks Simultaneously
Launch all parallel-safe tasks at once via `task`.

### 4. Run Dependent Tasks Sequentially
Wait for prerequisites before launching dependent work.

### 5. Verify
Lightweight verification when all tasks complete:
- Build/typecheck passes
- Affected tests pass
- No new errors introduced

## Rules

- Fire all independent agent calls simultaneously — never serialize independent work
- Run builds/tests in background when possible
- For full persistence and verification, recommend switching to ralph

## Checklist

- [ ] All parallel tasks completed
- [ ] Build/typecheck passes
- [ ] Affected tests pass
- [ ] No new errors introduced

## Autonomous Execution

When invoked in automation or CI, use `--no-ask-user` to prevent the agent from stopping to ask questions:
```
copilot -p "..." --autopilot --no-ask-user --yolo -s
```
This ensures fully autonomous execution without human intervention.
