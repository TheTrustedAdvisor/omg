---
name: team
description: "Activates parallel team execution — N coordinated agents working simultaneously on independent subtasks"
tags:
  - execution-mode
  - parallel
---

## Activation

This skill activates the **team agent** for parallel multi-agent execution.

## Usage

```
team <task description>
team N <task description>
team N:agent-type <task description>
team ralph <task description>
```

Parameters:
- **N** — number of agents (1-20), auto-sized if omitted
- **agent-type** — executor (default), debugger, designer, test-engineer
- **ralph** — modifier: wrap in persistence loop

## Trigger Keywords

team, assemble a team, team N, coordinated parallel execution

## Plan Discovery

Team checks for existing plans before decomposing:
1. `store_memory` key `omg:active-plan`
2. `.omg/plans/` directory

## Dependency & Conflict Management

- Each worker gets explicit file boundaries (no overlap)
- After all workers complete: combined build + test verification
- If conflicts detected: diagnose which worker caused the issue, fix that one

## Quality Contract

- Parallel, not sequential — never serialize independent work
- Combined verification after all workers complete
- Progress tracked in `.omg/qa-logs/team-log.md`

## Example

```bash
copilot -i "team 3: fix TypeScript errors across src/"
```
