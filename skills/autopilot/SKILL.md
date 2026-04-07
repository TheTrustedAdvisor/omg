---
name: autopilot
description: "Full autonomous execution from idea to working code — expand, plan, implement, QA, validate"
tags:
  - execution-mode
  - autonomous
  - pipeline
---

## When to Use

- User wants end-to-end autonomous execution from an idea to working code
- User says "autopilot", "autonomous", "build me", "create me", "make me", "full auto", "handle it all"
- Task requires multiple phases: planning, coding, testing, and validation
- User wants hands-off execution and is willing to let the system run to completion

## When NOT to Use

- User wants to explore options — use plan skill instead
- User says "just explain" or "what would you suggest" — respond conversationally
- User wants a single focused code change — use ralph or @omg:executor
- Task is a quick fix — delegate directly to @omg:executor

## Relationship to Other Modes

```
autopilot (this skill: full lifecycle)
 └── ralph (persistence + verification)
     └── ultrawork (parallel execution)
         └── task → omg:executor (single agent work)
```

## Plan Discovery

Before starting, check for an existing plan or spec:
1. Check `store_memory` for `omg:active-plan` — if found, **skip Phase 0 + 1**
2. Check `store_memory` for `omg:active-spec` — if found, **skip Phase 0** (use spec for Phase 1)
3. Check `.omg/plans/` and `.omg/research/` via `glob`
4. If a validated plan exists (from planner/ralplan), jump directly to Phase 2

## Phase 0 — Expansion (skip if spec/plan exists)

Turn the user's idea into a detailed spec.

1. Invoke @omg:analyst to extract requirements:
   ```
   task(agent_type="omg:analyst", prompt="Requirements analysis for: {idea}", model="claude-opus-4.6", mode="sync")
   ```
2. Invoke @omg:architect to create technical specification:
   ```
   task(agent_type="omg:architect", prompt="Technical spec from requirements: {analyst output}", model="claude-opus-4.6", mode="sync")
   ```
3. If input is vague (no file paths, function names, or concrete anchors): suggest deep-interview first
4. **Persist:** Save analyst output to `.omg/research/analyst-requirements.md`, architect spec to `.omg/research/architect-spec.md`
5. **Index:** `store_memory` with key `omg:active-spec`

## Phase 1 — Planning (skip if plan exists)

Create an implementation plan from the spec.

1. Invoke @omg:architect to create plan:
   ```
   task(agent_type="omg:architect", prompt="Create implementation plan from spec: {spec}", model="claude-opus-4.6", mode="sync")
   ```
2. Invoke @omg:critic to validate plan:
   ```
   task(agent_type="omg:critic", prompt="Evaluate plan: {plan}", model="claude-opus-4.6", mode="sync")
   ```
3. If critic rejects: revise and re-submit (max 3 rounds)
4. **Persist:** Save plan to `.omg/plans/{name}.md`
5. **Index:** `store_memory` with key `omg:active-plan`

## Phase 2 — Execution

Implement the plan using ralph + ultrawork patterns.

1. Break plan into executable stories (ralph PRD)
2. Route by complexity:
   - Simple tasks → `task(agent_type="omg:executor", model="claude-haiku-4.5")`
   - Standard tasks → `task(agent_type="omg:executor", model="claude-sonnet-4.6")`
   - Complex tasks → `task(agent_type="omg:executor", model="claude-opus-4.6")`
3. Fire independent tasks in parallel via multiple `task(mode="background")` calls simultaneously
4. Track progress in `.omg/qa-logs/ralph-progress.md`

## Phase 3 — QA (UltraQA Mode)

Cycle until all tests pass:

1. Run build + lint + tests via `bash`
2. If all pass → proceed to Phase 4
3. If failures:
   a. Invoke @omg:architect to diagnose:
      ```
      task(agent_type="omg:architect", prompt="Diagnose failure: {error output}", model="claude-opus-4.6", mode="sync")
      ```
   b. Invoke @omg:executor to fix based on diagnosis
   c. Record cycle in `.omg/qa-logs/autopilot-qa-log.md`:
      ```
      ## Cycle N
      - Error: {output}
      - Diagnosis: {architect finding}
      - Fix: {what was changed}
      - Result: PASS/FAIL
      ```
4. Repeat up to 5 cycles
5. **Same failure 3x:** stop and report fundamental issue — check qa-log before each fix

## Phase 4 — Validation

Multi-perspective review — ALL must approve:

1. Run all 3 reviewers (can be parallel):
   ```
   task(agent_type="omg:architect", prompt="Verify completeness against plan: {plan}", model="claude-opus-4.6", mode="background")
   task(agent_type="omg:security-reviewer", prompt="Security audit: {changed files}", model="claude-opus-4.6", mode="background")
   task(agent_type="omg:code-reviewer", prompt="Quality review: {changed files}", model="claude-opus-4.6", mode="background")
   ```
2. **Wait for ALL to complete** — do NOT proceed after just one response
3. **Aggregate verdicts:**
   - ALL approve → Phase 5
   - ANY reject → collect ALL rejection reasons into single remediation list
4. Delegate full remediation list to @omg:executor
5. **Re-validate ALL reviewers** (not just the one that rejected)
6. Max 3 validation rounds
7. **Persist:** Save validation report to `.omg/reviews/validation-{date}.md`, index via `store_memory` key `omg:last-review`

## Phase 5 — Done

1. Report what was built with summary
2. List files created/modified
3. List any known limitations or deferred items
4. Clean up QA logs if desired

## Phase Output Persistence

| Phase | Output File | store_memory Key |
|-------|------------|-----------------|
| Phase 0 | `.omg/research/analyst-requirements.md` + `.omg/research/architect-spec.md` | `omg:active-spec` |
| Phase 1 | `.omg/plans/{name}.md` | `omg:active-plan` |
| Phase 3 | `.omg/qa-logs/autopilot-qa-log.md` | — |
| Phase 4 | `.omg/reviews/validation-{date}.md` | `omg:last-review` |

## Escalation

- Same QA error 3 times → stop, report fundamental issue (check `.omg/qa-logs/`)
- Validation keeps failing after 3 rounds → stop, report specific blockers
- User says "stop" or "cancel" → stop immediately

## Examples

**Good input:** "autopilot A REST API for bookstore inventory with CRUD using TypeScript"
→ Specific domain, clear features, technology constraint. Enough for full expansion.

**Good input:** "build me a CLI tool that tracks daily habits with streak counting"
→ Clear product concept with specific feature. "build me" triggers autopilot.

**Bad input:** "fix the bug in the login page"
→ Single focused fix. Use @omg:executor or ralph instead.

## Checklist

- [ ] All 5 phases completed (or skipped with justification)
- [ ] All validators approved in Phase 4
- [ ] Tests pass (fresh output)
- [ ] Build succeeds (fresh output)
- [ ] Phase outputs persisted to `.omg/` directories
- [ ] User informed with summary

## Autonomous Execution

When invoked in automation or CI, use `--no-ask-user` to prevent the agent from stopping to ask questions:
```
copilot -p "..." --autopilot --no-ask-user --yolo -s
```
This ensures fully autonomous execution without human intervention.

## Session Audit Trail

Export session log on completion for audit/review:
```
copilot -p "..." --autopilot --yolo --share .omg/reviews/session-$(date +%Y%m%d).md
```
Or share as GitHub Gist: `--share-gist`
