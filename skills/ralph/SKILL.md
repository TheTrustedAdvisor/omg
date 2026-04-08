---
name: ralph
description: "Activates strict completion mode — keeps working until ALL acceptance criteria pass with verified proof"
tags:
  - execution-mode
  - persistence
  - verification
---

## Activation

This skill activates the **autopilot agent** in **ralph mode** (strict completion).

Ralph mode = autopilot without planning/review phases — just relentless implementation + verification until done.

## Trigger Keywords

ralph, don't stop, must complete, finish this, keep going until done

## Quality Contract

- Every acceptance criterion verified with fresh command output
- Same failure 3x → stop and report fundamental issue
- No scope creep — only implement what's in the stories

## Plan Discovery

Ralph checks for existing plans before decomposing:
1. `store_memory` key `omg:active-plan`
2. `.omg/plans/` directory

## Story State Persistence

Progress tracked in `.omg/qa-logs/ralph-progress.md` for cross-session resume.

## Example

```bash
copilot -i "ralph: fix all lint errors"
```
