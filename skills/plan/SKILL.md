---
name: plan
description: "Strategic planning — interview workflow, direct planning, consensus mode, or plan review"
tags:
  - planning
  - requirements
---

## When to Use

- User wants to plan before implementing — "plan this", "let's plan"
- User wants structured requirements gathering for a vague idea
- User wants an existing plan reviewed
- User wants multi-perspective consensus — "consensus", "ralplan"

## When NOT to Use

- User wants autonomous execution → use autopilot
- User wants to start coding with a clear task → use ralph or @omg:executor
- Simple question → just answer it

## Modes

| Mode | Trigger | Behavior |
|------|---------|----------|
| Interview | Default for broad requests | Interactive requirements gathering |
| Direct | Detailed request | Skip interview, generate plan directly |
| Consensus | "consensus", "ralplan" | Planner → Architect → Critic loop |
| Review | "review this plan" | Critic evaluation of existing plan |

## Interview Mode (Broad Requests)

### How to Detect
Broad requests have: vague verbs ("improve", "add"), no specific files/functions, touches 3+ areas.

### Protocol

1. **Classify** the request — broad triggers interview mode
2. **Gather codebase facts FIRST** — explore the codebase (use @omg:explore if available) before asking the user
3. **Ask ONE focused question** at a time using `ask_user`
   - NEVER batch multiple questions
   - Each question builds on the previous answer
   - Only ask about preferences/priorities/scope — NOT codebase facts
4. **Consult @omg:analyst** for hidden requirements and edge cases — perform a gap analysis on requirements gathered so far, focusing on missing constraints and edge cases
5. **Create plan** when user signals readiness ("create the plan", "I'm ready")

### Question Classification

| Type | Examples | Action |
|------|----------|--------|
| Codebase Fact | "What patterns exist?", "Where is X?" | Explore first, do NOT ask user |
| User Preference | "Priority?", "Timeline?" | Ask user via `ask_user` |
| Scope Decision | "Include feature Y?" | Ask user |
| Requirement | "Performance constraints?" | Ask user |

## Direct Mode (Detailed Requests)

1. **Run @omg:analyst pre-flight** (not optional): perform a brief gap analysis on the request, focusing on missing acceptance criteria, ambiguous scope, and untestable requirements (2-3 key findings). @omg:analyst can help with this.
   This sharpens acceptance criteria and catches scope gaps — cross-platform testing showed plans without analyst consultation produce vague criteria.
2. Generate comprehensive work plan incorporating analyst findings
3. Optional @omg:critic review for high-risk changes

## Consensus Mode (Ralplan)

Full iterative loop with structured deliberation:

1. **@omg:planner** creates initial plan with:
   - Principles (3-5)
   - Decision Drivers (top 3)
   - Viable Options (≥2) with bounded pros/cons
   - If only 1 option survives: explicit invalidation rationale
   Create the initial plan with a RALPLAN-DR summary. @omg:planner can help with this.

2. **@omg:architect** reviews for architectural soundness — MUST provide:
   - Strongest steelman antithesis against favored option
   - At least one meaningful trade-off tension
   - Synthesis path (if viable)
   Review the plan for architectural soundness, providing antithesis and trade-offs. @omg:architect can help with this.
   **Complete the architect review before proceeding to the critic.**

3. **@omg:critic** evaluates quality — MUST verify:
   - Principle-option consistency
   - Fair alternative exploration
   - Testable acceptance criteria
   - Concrete verification steps
   Evaluate the plan and architect review together. @omg:critic can help with this.

4. **Re-review loop** (max 5 iterations):
   - If critic rejects: collect ALL feedback, revise plan, return to step 2
   - Each iteration: planner addresses every CRITICAL finding
   - Include "Changes from Round N" section in revised plan

5. **On approval**: final plan includes ADR:
   - Decision, Drivers, Alternatives considered, Why chosen, Consequences, Follow-ups

### Review History Tracking

Each iteration logged to `.omg/reviews/ralplan-{name}-log.md`:
```
## Round N
### Architect Review
[key findings, antithesis, trade-offs]
### Critic Verdict: ACCEPT/REVISE/REJECT
[critical findings, required changes]
```

Planner reads full log before each revision.

## Review Mode

1. Read plan file from `.omg/plans/`
2. Invoke @omg:critic for evaluation
3. Return verdict: APPROVED, REVISE, or REJECT

## Plan Persistence

All plans are persisted for downstream consumption:
1. **Save to file:** `.omg/plans/{slugified-name}.md` via `edit`/`create`
2. **Index in memory:** `store_memory` with key `omg:active-plan` → `{ "path": "...", "title": "...", "steps": N, "created": "YYYY-MM-DD" }`
3. **Downstream:** autopilot/ralph/team check for existing plans before starting

## Plan Quality Standards

- 80%+ claims cite specific file references
- 90%+ acceptance criteria are testable (pass/fail, not subjective)
- No vague terms without metrics ("fast" → "p99 < 200ms")
- All risks have mitigations
- 3-6 actionable steps with acceptance criteria

## Design Option Presentation

When presenting design choices, chunk them:
1. Overview (2-3 sentences)
2. Option A with trade-offs → wait for reaction
3. Option B with trade-offs → wait for reaction
4. Recommendation (only after options discussed)

## Rules

- Never ask the user about codebase facts — use @omg:explore
- Ask ONE question at a time
- Wait for explicit user confirmation before handing off
- In consensus: architect BEFORE critic (sequential, not parallel)
- NEVER implement directly — hand off to execution skills

## Checklist

- [ ] Plan has testable acceptance criteria
- [ ] Plan references specific files where applicable
- [ ] All risks have mitigations
- [ ] User confirmed the plan
- [ ] Plan saved to `.omg/plans/` and indexed via `store_memory`
- [ ] In consensus: ADR included, review log maintained
