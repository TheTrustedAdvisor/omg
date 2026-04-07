---
name: ralph
description: "PRD-driven persistence loop — keeps working until all acceptance criteria pass with reviewer verification"
tags:
  - execution-mode
  - persistence
  - verification
---

## When to Use

- Task requires guaranteed completion with verification (not just "do your best")
- User says "ralph", "don't stop", "must complete", "finish this", "keep going until done"
- Work may span multiple iterations and needs persistence across retries
- Task benefits from structured PRD-driven execution with reviewer sign-off

## When NOT to Use

- Full autonomous pipeline from idea → use autopilot (includes ralph)
- Quick one-shot fix → delegate directly to @omg:executor
- Need to explore or plan first → use plan skill
- Need parallel execution without persistence → use ultrawork

## Relationship to Other Modes

```
autopilot (full lifecycle: plan → execute → QA → validate)
 └── ralph (persistence + verification: this skill)
     └── ultrawork (parallel execution within ralph)
```

Ralph adds persistence and verification on top of ultrawork's parallelism. Autopilot adds the full lifecycle pipeline on top of ralph.

## Plan Discovery

Before starting, check for an existing plan:
1. Check `store_memory` for key `omg:active-plan` — if found, read the plan file
2. Check `.omg/plans/` directory via `glob`
3. If a plan exists, derive user stories from its steps instead of decomposing from scratch

## Workflow

### 1. Setup (PRD Generation)

Break the task into user stories with **specific, testable** acceptance criteria.

**If a plan exists** in `.omg/plans/`: derive stories from its steps.
**Otherwise:** analyze the task and decompose.

For each story:
```json
{
  "id": "US-001",
  "name": "Add input validation",
  "acceptanceCriteria": [
    "validateInput('') returns false",
    "validateInput('valid@email.com') returns true",
    "TypeScript compiles with no errors (npm run build)"
  ],
  "passes": false
}
```

Save PRD to `.omg/qa-logs/ralph-prd.json`.

**CRITICAL:** Generic criteria like "Implementation is complete" or "Code compiles without errors" are NOT acceptable. Every criterion must be task-specific and testable.

### 2. Pick Next Story

Read PRD and select the highest-priority story with `passes: false`.

### 3. Implement

Delegate to specialist agents at appropriate tiers:
```
task(agent_type="omg:executor", prompt="Implement US-001: {description}. Acceptance criteria: {criteria}", model="claude-sonnet-4.6", mode="background")
```

**Tier routing:**
- Simple lookups/changes → haiku
- Standard implementation → sonnet
- Complex analysis/refactoring → opus

If sub-tasks are discovered during implementation, add them as new stories to the PRD.

**Parallel execution:** Fire independent stories simultaneously via multiple `task` calls. Spawn multiple `task(mode="background")` calls simultaneously for 3+ independent stories.

### 4. Verify Story

For EACH acceptance criterion in the current story:
1. Run the relevant check via `bash` (test, build, lint, typecheck)
2. Read the output — verify with fresh evidence
3. If ANY criterion is NOT met → continue working, do NOT mark complete

### 5. Mark Story Complete

When ALL acceptance criteria verified:
1. Set `passes: true` in PRD
2. Append to `.omg/qa-logs/ralph-progress.md`:
   ```
   ## Story: US-001 — Add input validation
   - Acceptance criteria met:
     - validateInput('') returns false ✓ (test output: PASS)
     - TypeScript compiles ✓ (npm run build exit 0)
   - Files changed: src/validators/input.ts, test/validators/input.test.ts
   - Learnings: existing validation pattern in src/validators/schema.ts
   ```

### 6. Check PRD Completion

- Read PRD — are ALL stories `passes: true`?
- If NOT → loop back to step 2 (pick next story)
- If ALL complete → proceed to step 7 (reviewer verification)

### 7. Reviewer Verification

Invoke reviewer based on change scope:
- <5 files with tests: `task(agent_type="omg:verifier", model="claude-sonnet-4.6", mode="sync")`
- Standard changes: `task(agent_type="omg:architect", model="claude-sonnet-4.6", mode="sync")`
- >20 files or security/architectural: `task(agent_type="omg:architect", model="claude-opus-4.6", mode="sync")`

The reviewer verifies against the SPECIFIC acceptance criteria from the PRD, not vague "is it done?"

### 8. On Approval

Report completion with summary of what was built.

### 9. On Rejection

1. Save rejection reasons to `.omg/reviews/ralph-review-{round}.md`
2. Extract specific items to fix
3. Delegate fixes to @omg:executor with focused prompts (file:line + specific issue + verification command)
4. Re-verify with the same reviewer

## Story State Persistence

Track progress persistently to survive context limits and session restarts:

1. **PRD:** `.omg/qa-logs/ralph-prd.json` — source of truth for stories + completion
2. **Progress log:** `.omg/qa-logs/ralph-progress.md` — what was done, files changed, learnings
3. **On startup:** check both files to resume from the correct story
4. **On reviewer rejection:** save to `.omg/reviews/ralph-review-{round}.md`

## Rules

- Fire independent work simultaneously — never wait sequentially for independent stories
- Run builds/tests in background when possible
- Deliver the FULL implementation: no scope reduction, no partial completion
- After 3+ iterations on the same story: report as potential fundamental problem
- PRD criteria must be task-specific (not generic boilerplate)
- Fresh evidence required for every completion claim

## Examples

**Good — PRD refinement:**
```
Auto-generated: acceptanceCriteria: ["Implementation is complete"]
After refinement: acceptanceCriteria: [
  "detectFlag('--no-prd') returns true",
  "detectFlag('fix this') returns false",  
  "TypeScript compiles (npm run build exit 0)"
]
```

**Good — Story-by-story verification:**
```
Story US-001: "Add flag detection"
  Criterion: "detectFlag returns true for --no-prd" → Run test → PASS
  Criterion: "TypeScript compiles" → Run build → PASS
  → Mark US-001 passes: true
Story US-002: "Wire into bridge.ts" → Continue...
```

**Bad — Completion without evidence:**
```
"All changes look good, the implementation should work correctly. Task complete."
→ Uses "should" and "look good" — no fresh evidence, no story verification
```

## Checklist

- [ ] PRD has task-specific acceptance criteria (not generic)
- [ ] All stories verified with fresh evidence
- [ ] All stories marked `passes: true`
- [ ] Progress recorded in `.omg/qa-logs/ralph-progress.md`
- [ ] Reviewer verified against PRD criteria
- [ ] Fresh test + build output shows success
- [ ] No scope reduction

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
