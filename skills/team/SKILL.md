---
name: team
description: "N coordinated agents on shared task list — parallel multi-agent execution with staged pipeline"
tags:
  - execution-mode
  - parallel
---

## When to Use

- Multiple independent tasks can be distributed across agents
- User says "team", "assemble a team", "team N", or wants coordinated parallel execution
- Task benefits from specialization (e.g., one agent per module, one per feature)
- Large task that would benefit from a plan → execute → verify pipeline

## When NOT to Use

- Single sequential task → delegate to @omg:executor
- Full autonomous pipeline from idea → use autopilot
- Need persistence/verification loop → use ralph
- Quick one-shot fix → delegate directly to @omg:executor

## Usage

```
team <task description>
team N <task description>
team N:agent-type <task description>
team ralph <task description>
```

Parameters:
- **N** — number of agents (1–20). Optional. If omitted, auto-sized based on task decomposition.
- **agent-type** — which agent to spawn for execution stage. Default: executor. Options: executor, debugger, designer, test-engineer.
- **task** — the high-level task to decompose and distribute
- **ralph** — modifier: wrap the pipeline in ralph's persistence loop (retry on failure, architect verification)

Examples:
```
team 5 fix all TypeScript errors across the project
team 3:debugger investigate build failures in src/
team 4:designer implement responsive layouts for all page components
team refactor the auth module with security review
team ralph build a complete REST API for user management
```

## Plan Discovery

Before decomposing, check for an existing plan:
1. Check `store_memory` for key `omg:active-plan` — if found, read the plan file
2. Check `.omg/plans/` directory via `glob`
3. If a plan exists, derive subtasks from its steps — do NOT re-plan from scratch

## Staged Pipeline

The team skill runs a fixed 5-stage pipeline. Each stage gates on completion before the next begins.

```
team-plan → team-prd → team-exec → team-verify → team-fix (loop)
```

### Stage 1: team-plan

Decompose the task into subtasks:
1. If no existing plan: invoke `task(agent_type="omg:architect", model="claude-opus-4.6", mode="sync")` to analyze scope and produce decomposition
2. If plan exists in `.omg/plans/`: read it and extract steps as subtasks
3. Identify file-level dependencies: if two subtasks touch the same file, make one depend on the other
4. Determine N (number of agents): one agent per independent subtask cluster, up to the requested max
5. Save decomposition to `.omg/plans/team-plan-{slug}.md`

**Auto-sizing:** If N not specified, count the independent subtask clusters. Cap at 10 by default.

### Stage 2: team-prd

Generate a Product Requirements Document for the execution:
1. For each subtask, define:
   - **Acceptance criteria** — testable, specific (not "implementation is complete")
   - **File scope** — which files will be created or modified
   - **Dependencies** — which other subtasks must complete first
2. Save as `.omg/plans/team-prd-{slug}.json`:
   ```json
   {
     "tasks": [
       {
         "id": "T1",
         "name": "...",
         "agent": "executor",
         "acceptanceCriteria": ["...", "..."],
         "files": ["src/..."],
         "dependsOn": []
       }
     ]
   }
   ```

### Stage 3: team-exec

Execute all subtasks:
1. **Independent tasks** (no dependsOn): invoke all simultaneously via parallel `task` calls
2. **Dependent tasks**: invoke after their prerequisites complete
3. **Agent routing by subtask type:**

| Subtask Type | Agent | Model |
|-------------|-------|-------|
| Implementation | @omg:executor | sonnet |
| Bug investigation | @omg:debugger | sonnet |
| UI/layout | @omg:designer | sonnet |
| Test writing | @omg:test-engineer | sonnet |
| Architecture decisions | @omg:architect | opus |
| External docs lookup | @omg:document-specialist | sonnet |

4. Track all task invocations and completions in `.omg/qa-logs/team-log.md`

**Parallel invocation pattern:**
```
# These run simultaneously (no dependsOn):
task(agent_type="omg:executor", prompt="Implement T1: ...", model="claude-sonnet-4.6")
task(agent_type="omg:executor", prompt="Implement T2: ...", model="claude-sonnet-4.6")
task(agent_type="omg:executor", prompt="Implement T3: ...", model="claude-sonnet-4.6")

# After T1 and T2 complete, T4 can run:
task(agent_type="omg:executor", prompt="Implement T4 (depends on T1, T2): ...", model="claude-sonnet-4.6")
```

### Stage 4: team-verify

Verify all subtasks meet acceptance criteria:
1. Run build via `bash`: `npm run build` (or project equivalent)
2. Run tests via `bash`: `npm test` (or project equivalent)
3. Run lint via `bash`: `npm run lint` (or project equivalent)
4. Invoke `task(agent_type="omg:verifier", model="claude-sonnet-4.6", mode="sync")` to check acceptance criteria from team-prd
5. Check `.omg/qa-logs/team-log.md` for any failed subtasks

If ALL subtasks pass and build/tests pass → proceed to done.
If any subtask fails → proceed to team-fix.

### Stage 5: team-fix (loop, max 5 iterations)

Fix failing subtasks:
1. Identify which subtask(s) failed from verifier output
2. Invoke `task(agent_type="omg:debugger", model="claude-sonnet-4.6", mode="sync")` for each failing subtask
3. Re-run verification (Stage 4)
4. Repeat up to 5 total fix iterations
5. If still failing after 5 iterations: report the blocker and stop

## Team + Ralph Composition

When `ralph` modifier is present:
- Wrap stages 3–5 in ralph's persistence loop
- Ralph retries the fix loop with no artificial cap (ralph manages its own prd.json)
- Add architect verification before declaring completion
- Invoke `task(agent_type="omg:ralph", model="claude-sonnet-4.6", mode="sync")` with the team-prd as context

```
team-plan → team-prd → ralph(team-exec + team-verify + team-fix) → architect-verify → done
```

## Dependency & Conflict Management

1. **Before assigning tasks:** check for file overlap via `glob`. If two tasks modify the same file, make them sequential
2. **For dependent tasks:** pass the output of the prerequisite task in the dependent task's prompt
3. **After all parallel tasks complete:** run `bash "git diff --stat HEAD"` to verify no unintended interactions
4. **Track in log:** append task assignments + completions to `.omg/qa-logs/team-log.md`

## Rules

- Fire all independent tasks simultaneously — never serialize independent work
- Route to the right agent type: debugger for bugs, designer for UI, test-engineer for tests
- Every subtask must have testable acceptance criteria before execution begins
- If a subtask fails 3+ times, escalate to @omg:architect for analysis
- Always check for an existing plan before decomposing from scratch

## Checklist

- [ ] Plan checked (existing plan used if found, or new plan created)
- [ ] Task decomposed into independent subtasks with acceptance criteria (team-prd)
- [ ] File-level dependencies identified and serialized
- [ ] All subtasks invoked in parallel where possible (team-exec)
- [ ] Build passes
- [ ] Tests pass
- [ ] Verifier confirmed acceptance criteria met
- [ ] Progress log written to `.omg/qa-logs/team-log.md`
- [ ] Summary reported to user

## Worker Prompt Template

When spawning workers, use this structured prompt:

```
task(agent_type="omg:executor", model="claude-sonnet-4.6", mode="background",
  prompt="TEAM WORKER: {worker-id}

SUBTASK: {description}
FILES IN SCOPE: {file list — ONLY these files}
ACCEPTANCE CRITERIA:
- {criterion 1}
- {criterion 2}

CONSTRAINTS:
- Do NOT modify files outside your scope
- Run verification on your files after changes
- Report: files changed, lines changed, verification result

DEPENDS ON: {none | worker-{N} output}")
```

## Monitoring Pattern

While workers run, the lead polls:
```
1. Check background agent status (completion notifications)
2. Read .omg/qa-logs/team-log.md for worker reports
3. Detect conflicts: did two workers touch the same file?
4. On conflict: revert later worker, re-run with updated context
```

## Error Recovery

| Error | Recovery |
|-------|---------|
| Worker fails to complete | Retry once with same prompt. If still fails, mark subtask FAILED. |
| Worker edits wrong files | Revert via `bash: git checkout -- {wrong files}`. Re-run with stricter scope. |
| Build breaks after workers | Invoke @omg:debugger to identify which worker's change broke it. Revert that worker only. |
| Two workers conflict | Revert the later one. Re-run it with the first worker's output as dependency. |
