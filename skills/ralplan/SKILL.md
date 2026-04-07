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

## Workflow

Ralplan is consensus mode planning. It runs an iterative loop:

1. **@planner** creates initial plan with:
   - Principles (3-5)
   - Decision Drivers (top 3)
   - Viable Options (>=2) with pros/cons
2. **@architect** reviews for architectural soundness — must provide strongest counterargument against the favored option and meaningful trade-off tensions
3. **@critic** evaluates quality — must verify testable acceptance criteria, fair alternative exploration, and concrete verification steps
4. **Re-review loop** (max 5 iterations) — if critic rejects, planner revises, back to architect
5. **On approval** — final plan includes ADR: Decision, Drivers, Alternatives considered, Why chosen, Consequences, Follow-ups

After approval, hand off to team or ralph for execution.

## Review History Tracking

Each iteration must be logged so the planner sees full feedback history:

1. **After each architect+critic round:** append to `.omg/reviews/ralplan-{plan-name}-log.md`:
   ```
   ## Round N
   ### Architect Review
   [key findings, antithesis, trade-offs]
   ### Critic Verdict: ACCEPT/REVISE/REJECT
   [critical findings, required changes]
   ```
2. **Before each revision:** planner reads the full log to avoid re-introducing previously flagged issues
3. **On REVISE:** planner must add a "Changes from Round N" section in the revised plan addressing each CRITICAL finding by number

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
