---
name: ralph
description: "Activates persistence loop — keeps working until all acceptance criteria pass with verified evidence"
tags:
  - execution-mode
  - persistence
  - verification
---

## Activation

This skill activates the **ralph agent** for persistent, verified execution.

The ralph agent will:
- Decompose the task into stories with testable acceptance criteria
- Implement each story, verify with fresh output
- Fix failures and re-verify (up to 5 iterations per story)
- Track progress in `.omg/qa-logs/ralph-progress.md`
- Never claim done without evidence

## Trigger Keywords

ralph, don't stop, must complete, finish this, keep going until done

## Plan Discovery

Ralph checks for existing plans before decomposing:
1. `store_memory` key `omg:active-plan`
2. `.omg/plans/` directory

## Story State Persistence

Progress is tracked in `.omg/qa-logs/ralph-progress.md` for cross-session resume.

## Quality Contract

- Every acceptance criterion verified with fresh command output
- Same failure 3x → stop and report fundamental issue
- No scope creep — only implement what's in the stories
