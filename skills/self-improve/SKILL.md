---
name: self-improve
description: "Autonomous code improvement engine — research, plan, execute, benchmark, tournament-select"
tags:
  - optimization
  - autonomous
---

## When to Use

- User says "self-improve" or wants autonomous iterative code improvement
- Performance optimization requiring multiple experimental approaches
- Want to try competing strategies and keep only what measurably improves

## When NOT to Use

- Single targeted fix → use @omg:executor
- Need to understand before changing → use deep-dive or trace
- No benchmark/metric to measure improvement → define one first

## Architecture

```
Setup → Research → Plan → Execute → Benchmark → Tournament → Repeat
```

Each iteration:
1. Multiple agents propose improvements (competing strategies)
2. Each strategy is implemented and benchmarked
3. Tournament selection keeps the best performer
4. History tracks what worked and what didn't

## Workflow

### Phase 1: Setup

1. **Define goal:** What metric to improve? (latency, memory, test coverage, bundle size, etc.)
2. **Define benchmark:** Command that produces a measurable number
   ```
   bash: "npm run bench | grep 'ops/sec'"
   bash: "npm run build && stat -f%z dist/cli.js"
   ```
3. **Run baseline:** Execute benchmark, record starting score
4. **Define constraints:**
   - Sealed files (benchmark code cannot be modified)
   - Max iterations
   - Minimum improvement threshold to keep

Save config to `.omg/research/self-improve-config.json`.

### Phase 2: Research (per iteration)

Spawn @omg:architect to analyze the codebase and generate improvement hypotheses:
```
task(agent_type="omg:architect", prompt="Analyze {target area} for {goal}. Generate 2-3 specific improvement hypotheses with expected impact.", model="claude-opus-4.6", mode="sync")
```

### Phase 3: Plan (per iteration)

For each hypothesis, create an implementation plan:
```
task(agent_type="omg:planner", prompt="Create implementation plan for hypothesis: {hypothesis}", model="claude-opus-4.6", mode="sync")
```

Submit plans to @omg:critic for review. Reject plans that violate constraints.

### Phase 4: Execute (per iteration)

For each approved plan, implement in parallel:
```
task(agent_type="omg:executor", prompt="Implement plan: {plan}. Do NOT modify sealed files.", model="claude-sonnet-4.6", mode="background")
```

After implementation, run the benchmark command via `bash`.

### Phase 5: Tournament

Compare all candidates against baseline:
- If improvement > threshold → candidate wins
- If multiple winners → keep the best
- If no improvement → log and continue to next iteration
- Merge winning changes via @omg:git-master

### Phase 6: Iterate or Stop

**Stop conditions:**
- Max iterations reached
- Improvement < threshold for 3 consecutive rounds
- User says "stop"
- Benchmark error (investigation needed)

**Continue:** Loop back to Phase 2 with updated codebase.

### State Tracking

Track all state in `.omg/research/self-improve/`:
```
.omg/research/self-improve/
├── config.json          # Goal, benchmark, constraints
├── baseline.json        # Initial benchmark score
├── history/             # Per-iteration results
│   ├── round-1.json     # Hypotheses, plans, scores
│   └── round-2.json
└── progress.md          # Human-readable progress log
```

## Rules

- Run fully autonomously once started — no pausing between iterations
- Sealed files (benchmark code) cannot be modified
- Every change must be benchmarked before acceptance
- On agent failure: retry once, then skip and continue
- Log everything for reproducibility

## Examples

**Good:** "self-improve reduce bundle size. Benchmark: npm run build && stat -f%z dist/cli.js. Target: 20% reduction."
→ Clear metric, measurable benchmark, specific target.

**Bad:** "self-improve make the code better"
→ No metric, no benchmark, no target. Ask for specifics first.

## Checklist

- [ ] Goal and benchmark defined
- [ ] Baseline recorded
- [ ] Sealed files specified
- [ ] Each iteration logged to `.omg/research/self-improve/history/`
- [ ] Tournament selection applied (only winners merged)
- [ ] Stop condition documented
