---
name: ralplan
description: "Consensus planning — iterative Planner/Architect/Critic loop until agreement"
tags:
  - planning
  - consensus
---

## When to Use

- User says "ralplan" or "consensus"
- High-stakes decisions needing multi-perspective validation
- Complex tasks where approach agreement matters before execution

## Mandatory Persistence

**You MUST persist artifacts at every step. This is not optional.**

| When | Action | Path |
|------|--------|------|
| After EVERY architect+critic round | Append round log | `.omg/reviews/ralplan-{plan-name}-log.md` |
| On approval | Write final plan | `.omg/plans/ralplan-{name}.md` |
| On approval | Index plan | `store_memory` key `omg:active-plan` |
| On approval | Write ADR | `.omg/research/adr-{name}.md` |

## Workflow

Ralplan is consensus mode planning. It runs an iterative loop:

### Step 1: Planner creates initial plan

```
task(agent_type="omg:planner", prompt="Create plan with RALPLAN-DR summary: Principles (3-5), Decision Drivers (top 3), Viable Options (>=2) with pros/cons.", model="claude-opus-4.6", mode="sync")
```

### Step 2: Architect reviews

```
task(agent_type="omg:architect", prompt="Review plan: {plan}. Provide antithesis + trade-offs.", model="claude-opus-4.6", mode="sync")
```

### Step 3: Critic evaluates

```
task(agent_type="omg:critic", prompt="Evaluate plan: {plan} + architect review: {review}", model="claude-opus-4.6", mode="sync")
```

### Step 4: PERSIST THE ROUND (mandatory)

**Immediately after Step 3**, append to `.omg/reviews/ralplan-{plan-name}-log.md`:

```markdown
## Round N
### Architect Review
[key findings, antithesis, trade-offs]
### Critic Verdict: ACCEPT/REVISE/REJECT
[critical findings, required changes]
```

Use `edit` to create/append this file. Do NOT skip this step.

### Step 5: Loop or finalize

- **If REVISE/REJECT:** Planner reads the full log, revises plan addressing each CRITICAL finding by number. Back to Step 2. Max 5 iterations.
- **If ACCEPT:** Write final plan to `.omg/plans/ralplan-{name}.md`, index via `store_memory` with key `omg:active-plan`, write ADR to `.omg/research/adr-{name}.md`.

After approval, hand off to team or ralph for execution.

## Detailed Consensus Protocol

### RALPLAN-DR Summary (emitted by planner before review)

```markdown
### Principles (3-5)
1. {principle with rationale}

### Decision Drivers (top 3)
1. {driver — the most important constraint or goal}

### Viable Options (≥2)

#### Option A: {name}
- Pros: {bounded list, max 5}
- Cons: {bounded list, max 5}

#### Option B: {name}
- Pros: ...
- Cons: ...

If only 1 viable option remains:
> **Invalidation rationale:** Option B was rejected because {specific reason with evidence}.
```

### Architect Review Requirements

The architect MUST provide:
1. **Antithesis** — strongest argument against the favored option
2. **Trade-off tension** — a real tension that cannot be wished away
3. **Synthesis** (if viable) — path that preserves strengths from competing options

### Critic Gate Checks

The critic MUST verify:
- [ ] Principle-option consistency (options align with stated principles)
- [ ] Alternatives fairly explored (not straw-manned)
- [ ] Risk mitigations are concrete (not "we'll handle it later")
- [ ] Acceptance criteria are testable
- [ ] Verification steps are concrete

### ADR Output (on approval)

```markdown
## ADR: {Decision Title}
- **Decision:** {what was decided}
- **Drivers:** {top 3 decision drivers}
- **Alternatives considered:** {options that were evaluated}
- **Why chosen:** {rationale with evidence}
- **Consequences:** {what follows from this decision}
- **Follow-ups:** {what needs to happen next}
```

### Plan Persistence

On approval, save the final plan for downstream consumption:

1. Write plan to `.omg/plans/ralplan-{name}.md`
2. Index via `store_memory` with key `omg:active-plan` → path to the plan file
3. Write ADR to `.omg/research/adr-{name}.md`
