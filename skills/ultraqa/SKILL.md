---
name: ultraqa
description: "QA cycling — test, diagnose, fix, repeat until quality goal is met"
tags:
  - qa
  - verification
---

## When to Use

- Need to get tests/build/lint passing through iterative fixing
- User says "ultraqa" or wants automated QA cycling

## Goal Types

| Goal | What to Check |
|------|---------------|
| tests | All test suites pass |
| build | Build succeeds |
| lint | No lint errors |
| typecheck | No TypeScript errors |

## Cycle Workflow (Max 5)

1. **RUN QA** — execute check via `bash`
2. **CHECK** — did it pass? If YES → done. If NO → continue.
3. **DIAGNOSE** — invoke @architect to analyze failure root cause
4. **FIX** — invoke @executor to apply recommended fix
5. **REPEAT** — go back to step 1

## Exit Conditions

- **Goal met** → report success with cycle count
- **Cycle 5 reached** → stop with diagnosis of remaining issues
- **Same failure 3x** → stop early, report fundamental issue

## Cycle State Tracking

Maintain a cycle log to prevent repeating failed approaches:

1. **Before each cycle:** read `.omg/qa-logs/ultraqa-log.md` if it exists
2. **After each cycle:** append to the log:
   ```
   ## Cycle N
   - Error: [output]
   - Diagnosis: [architect finding]
   - Fix applied: [what was changed]
   - Result: PASS/FAIL
   ```
3. **Same-failure detection:** before applying a fix, check the log — if the same error appeared in 2+ previous cycles, stop and report as fundamental issue
4. **Cleanup:** delete `.omg/qa-logs/ultraqa-log.md` on completion

## Autonomous Execution

When invoked in automation or CI, use `--no-ask-user` to prevent the agent from stopping to ask questions:
```
copilot -p "..." --autopilot --no-ask-user --yolo -s
```
This ensures fully autonomous execution without human intervention.
