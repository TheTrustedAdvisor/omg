---
name: deep-dive
description: "2-stage pipeline: trace (causal investigation) then deep-interview (requirements crystallization) with evidence injection"
tags:
  - analysis
  - requirements
  - investigation
---

## When to Use

- User has a problem but doesn't know the root cause — needs investigation before requirements
- User says "deep dive", "deep-dive", "investigate deeply", "trace and interview"
- Bug investigation: "Something broke and I need to figure out why, then plan the fix"
- Feature exploration: "I want to improve X but first need to understand how it works"

## When NOT to Use

- User already knows the root cause — use deep-interview directly
- User has a clear, specific request — execute directly
- User wants only investigation, not requirements — use trace skill directly
- User already has a spec/PRD — use ralph or autopilot

## Why This Exists

Users who run trace and deep-interview separately lose context between steps. Deep Dive connects them with an injection mechanism that transfers trace findings directly into the interview.

## Architecture

```
Phase 1: Initialize → detect brownfield/greenfield, generate 3 trace lane hypotheses
Phase 2: Confirm Lanes → ask_user to confirm/adjust hypotheses
Phase 3: Trace (autonomous) → 3 parallel investigation lanes, synthesize findings
Phase 4: Deep Interview (interactive) → inject trace findings, Socratic Q&A, crystallize spec
Phase 5: Execution Bridge → hand off to plan/autopilot/ralph/team
```

## Phase 1: Initialize

1. Parse the problem from user prompt
2. Detect brownfield/greenfield via `task(agent_type="omg:explore", mode="background", model="claude-haiku-4.5")`
3. Generate 3 trace lane hypotheses:
   1. **Code-path / implementation cause**
   2. **Config / environment / orchestration cause**
   3. **Measurement / artifact / assumption mismatch**

## Phase 2: Confirm Lanes

Present hypotheses via `ask_user`. Allow user to adjust before proceeding.

## Phase 3: Trace (Autonomous)

Run 3 parallel traces:
```
task(agent_type="omg:tracer", prompt="Investigate: {lane 1}", model="claude-sonnet-4.6", mode="background")
task(agent_type="omg:tracer", prompt="Investigate: {lane 2}", model="claude-sonnet-4.6", mode="background")
task(agent_type="omg:tracer", prompt="Investigate: {lane 3}", model="claude-sonnet-4.6", mode="background")
```

Synthesize: rank hypotheses, identify **Best Explanation** + **Critical Unknown**.
Persist to `.omg/research/trace-{slug}.md`.

## Phase 4: Deep Interview (Interactive)

Inject trace findings at 3 points:

1. **Enriched Starting Context** — interview begins with traced root cause + evidence
2. **System Context** — brownfield context from trace exploration boosts Context Clarity score
3. **Seeded Questions** — first questions target the Critical Unknown, then validation

Follow normal deep-interview protocol (ambiguity scoring, challenge agents).

## Phase 5: Execution Bridge

Save spec to `.omg/research/spec-{slug}.md`, index via `store_memory` key `omg:active-spec`.
Present options: Ralplan → Autopilot (recommended), Autopilot, Ralph, Team.

## Stage Handoff

1. Trace report → `.omg/research/trace-{slug}.md`
2. Interview targets Critical Unknown first, references trace file
3. Spec → `.omg/research/spec-{slug}.md` + `store_memory` key `omg:active-spec`

## Checklist

- [ ] 3 trace lanes confirmed with user
- [ ] All 3 traces run in parallel
- [ ] Trace report saved to `.omg/research/trace-{slug}.md`
- [ ] Trace findings injected into interview
- [ ] Spec saved to `.omg/research/spec-{slug}.md`
- [ ] Execution bridged via skill invocation

## 3-Point Injection Detail

The key innovation of deep-dive over running trace + interview separately:

### Point 1: Enriched Starting Context

**Without deep-dive:** Interview starts from zero. "What do you want to change?"
**With deep-dive:** Interview starts with: "The trace found an off-by-one in token refresh at auth.ts:142. The config has 15min expiry but refresh logic subtracts 1 minute too early."

The interview skips redundant exploration and starts at the root cause.

### Point 2: System Context Boost

The trace phase explored the codebase and built a mental model. This feeds into the interview's dimension scoring:
- **Context Clarity** starts higher (trace already mapped the system)
- **Goal Clarity** gets a head start (the traced explanation seeds the goal)
- Fewer rounds needed to reach the 20% ambiguity threshold

### Point 3: Seeded Questions

Instead of generic "what do you want?", the first questions are laser-targeted:
1. "The trace identified {Critical Unknown}. Can you clarify: {specific question}?"
2. "The best explanation is {X}. Does this match what you observed?"
3. "Should we fix just this instance, or also address {N} similar patterns the trace found?"

This means deep-dive typically reaches spec clarity in 3-5 rounds instead of 8-10.

## When Deep-Dive Beats Separate trace + interview

| Scenario | Trace alone | Interview alone | Deep-dive |
|----------|------------|----------------|-----------|
| Bug with unknown cause | Finds cause, no action path | Gathers requirements, misses root cause | Finds cause → targets requirements |
| Performance regression | Identifies bottleneck | Asks generic questions | Bottleneck → specific optimization spec |
| "Something changed" | Traces the delta | Doesn't know what changed | Delta → spec for targeted fix |
