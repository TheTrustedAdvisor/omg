---
name: trace
description: "Evidence-driven tracing — orchestrate competing hypotheses to explain observed outcomes"
tags:
  - debugging
  - analysis
  - causal
---

## When to Use

- User says "trace" or wants root cause analysis
- Ambiguous problem with multiple possible explanations
- Runtime bugs, regressions, performance issues
- Architecture or orchestration behavior explanation
- "Given this output, trace back the likely causes"

## When NOT to Use

- User knows the cause and just needs a fix → use debug skill
- Clear, specific bug with obvious location → use @omg:debugger directly
- Need requirements, not explanation → use deep-interview

## Core Contract

Every trace preserves these 7 elements:

1. **Observation** — what was actually observed (no interpretation)
2. **Hypotheses** — competing explanations (at least 2)
3. **Evidence For** — what supports each explanation
4. **Evidence Against / Gaps** — what contradicts or is missing
5. **Current Best Explanation** — the leading explanation with evidence
6. **Critical Unknown** — the missing fact keeping top hypotheses apart
7. **Discriminating Probe** — the highest-value next step

## Evidence Strength Hierarchy

Rank evidence from strongest to weakest:
1. Controlled reproduction / direct experiment
2. Primary artifacts with tight provenance (logs, traces, metrics, git history, file:line)
3. Multiple independent sources converging
4. Single-source code-path inference
5. Weak circumstantial clues (timing, naming, stack position)
6. Intuition / analogy / speculation

Higher-ranked evidence overrides lower-ranked.

## Workflow

### Phase 1: Observe

Invoke @omg:tracer:
```
task(agent_type="omg:tracer", prompt="TRACE: Observation: {what happened}. Restate precisely. Generate 3+ competing hypotheses from different frames (code-path, config/env, measurement artifact). Gather evidence for and against each.", model="claude-sonnet-4.6", mode="sync")
```

### Phase 2: Falsify

For each top hypothesis, actively seek disconfirming evidence:
- "What should be present if this is true?" → check
- "What would be hard to explain if this is true?" → check
- Prefer probes that distinguish between hypotheses

### Phase 3: Rank

Down-rank hypotheses that:
- Are contradicted by direct evidence
- Require extra unverified assumptions
- Fail to make distinctive predictions

### Phase 4: Synthesize

Produce trace report. Persist to `.omg/research/trace-{slug}.md`.

### Phase 5: Action Path

After trace:
- If confidence HIGH: suggest "Proceed to fix?" → invoke debug skill with Best Explanation + file:line
- If confidence LOW: recommend Discriminating Probe as next step
- Do NOT auto-fix unless user explicitly requests

## Do NOT Collapse Into

- A generic fix-it coding loop (trace explains, it doesn't fix)
- A generic debugger summary
- Fake certainty when evidence is incomplete
- A raw dump of search results

## Checklist

- [ ] Observation stated before interpretation
- [ ] At least 2 competing hypotheses
- [ ] Evidence for AND against each hypothesis
- [ ] Evidence ranked by strength (not flat)
- [ ] Disconfirmation attempted on favored explanation
- [ ] Critical Unknown named
- [ ] Discriminating Probe recommended
- [ ] Report saved to `.omg/research/trace-{slug}.md`
