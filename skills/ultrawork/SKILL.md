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

### 2. Route by Complexity and Fire

Route each subtask to the right agent/model, then fire all independent ones simultaneously:
Launch all parallel-safe tasks at once. Example with 3 independent subtasks:

```
task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="background",
  prompt="[SUBTASK 1] {description}. Work ONLY on {files}.")

task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="background",
  prompt="[SUBTASK 2] {description}. Work ONLY on {files}.")

task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="background",
  prompt="[SUBTASK 3] {description}. Work ONLY on {files}.")
```

Route by complexity:
- Simple lookups → `task(agent_type="omg:explore", model="claude-haiku-4.5", mode="background")`
- Standard implementation → `task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="background")`
- Complex analysis → `task(agent_type="omg:architect", model="claude-opus-4.6", mode="background")`

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
