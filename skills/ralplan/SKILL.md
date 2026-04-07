---
name: ralplan
description: "Consensus planning — iterative Planner/Architect/Critic loop until agreement"
tags:
  - planning
  - consensus
---

## Instructions

Execute these steps IN ORDER. Do NOT skip steps. Do NOT substitute different agents.

### 1. INIT

```bash
mkdir -p .omg/reviews .omg/plans .omg/research
```

### 2. PLANNER

```
task(agent_type="omg:planner", model="claude-opus-4.6", mode="sync", prompt="Create a structured plan for: {user's topic}. Include: Principles (3-5), Decision Drivers (top 3), Viable Options (>=2) with pros/cons.")
```

### 3. ARCHITECT

```
task(agent_type="omg:architect", model="claude-opus-4.6", mode="sync", prompt="Review this plan. Provide: (1) Antithesis against the favored option, (2) Trade-off tensions, (3) Synthesis if viable. Plan: {step 2 output}")
```

### 4. CRITIC

```
task(agent_type="omg:critic", model="claude-opus-4.6", mode="sync", prompt="Evaluate this plan + review. Start with VERDICT: ACCEPT or REVISE or REJECT. Number each finding. Plan: {step 2 output}. Architect review: {step 3 output}")
```

### 5. SAVE ROUND

```
task(agent_type="omg:executor", model="claude-haiku-4.5", mode="sync", prompt="Append to file .omg/reviews/ralplan-log.md. Create it if missing. Content to append: ## Round {N}\n### Architect\n{step 3 output}\n### Critic\n{step 4 output}\n---")
```

### 6. DECIDE

- If verdict is REVISE or REJECT AND round < 5: go to step 2 with feedback
- If verdict is ACCEPT: go to step 7

### 7. FINALIZE (only on ACCEPT)

```
task(agent_type="omg:executor", model="claude-haiku-4.5", mode="sync", prompt="Write the approved plan to .omg/plans/ralplan-result.md: {final plan}")
```

Then call:
```
store_memory key="omg:active-plan" value='{"path":".omg/plans/ralplan-result.md"}'
```

Show the user the final plan and mention saved files.
