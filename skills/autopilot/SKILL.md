---
name: autopilot
description: "Activates full autonomous execution — from idea to working, verified code"
tags:
  - execution-mode
  - autonomous
  - pipeline
---

## Activation

This skill activates the **autopilot agent** for full lifecycle execution.

The autopilot agent will:
- Expand vague requirements into concrete acceptance criteria
- Create a structured plan with testable criteria
- Implement code changes (parallel when independent)
- Run build, typecheck, tests as verification
- Review for security and code quality
- Persist all artifacts to `.omg/` directories

## Trigger Keywords

autopilot, autonomous, build me, create me, make me, full auto, handle it all

## Plan Discovery

Before starting fresh, autopilot checks for existing work:
1. `store_memory` key `omg:active-plan` — skip to execution
2. `store_memory` key `omg:active-spec` — skip to planning
3. `.omg/plans/` and `.omg/research/` via `glob`

## Quality Contract

- Every claim backed by evidence (fresh test output)
- Smallest viable change (no scope creep)
- Same failure 3x → stop and report
- All reviewers must approve before completion

## Examples

Good: "autopilot: build a REST API for bookstore inventory with CRUD using TypeScript"
Good: "build me a CLI tool that tracks daily habits with streak counting"
Bad: "fix the bug in the login page" → use debug or @omg:executor instead
