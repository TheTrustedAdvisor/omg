---
name: ultrawork
description: "Activates parallel execution — fires multiple agents simultaneously for independent tasks"
tags:
  - execution-mode
  - parallel
---

## Activation

This skill activates the **ultrawork agent** for parallel task execution.

The ultrawork agent will:
- Classify tasks as independent or dependent
- Fire all independent tasks simultaneously
- Run dependent tasks sequentially after prerequisites
- Verify combined result (build, tests)

## Trigger Keywords

ultrawork, ulw, parallel execution, fire simultaneously

## Quality Contract

- Never serialize independent work
- Each parallel worker gets explicit file boundaries
- Lightweight verification after all tasks complete
