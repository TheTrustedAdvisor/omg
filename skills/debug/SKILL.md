---
name: debug
description: "Structured debugging — reproduce, diagnose, fix with @omg:debugger agent"
tags:
  - debugging
---

## When to Use

- Bug needs systematic investigation
- User says "debug" or reports an error/failure

## Workflow

1. Invoke @omg:debugger with the error/symptom
2. Debugger reproduces, investigates root cause, recommends minimal fix
3. If fix needed, invoke @omg:executor to apply it
4. Verify fix via `bash`

## Structured Handoff

When invoking @omg:executor for the fix:
1. Persist diagnosis to `.omg/research/debug-{issue}.md`
2. Include in executor prompt ONLY: (1) exact file:line from Root Cause, (2) specific Fix, (3) Verification command
3. If Similar Issues found, create one additional task per location
