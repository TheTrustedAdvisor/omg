---
name: sciomc
description: "Orchestrate parallel scientist agents for comprehensive research with staged analysis"
tags:
  - research
  - analysis
  - parallel
---

## When to Use

- Complex research goal requiring multiple perspectives
- User says "sciomc", "research", or wants parallel analysis
- Data analysis with competing hypotheses
- Codebase investigation requiring breadth + depth

## When NOT to Use

- Single quick lookup → use @omg:explore
- External documentation → use external-context skill
- Root cause analysis → use trace skill

## Usage

```
sciomc <research goal>
sciomc AUTO: <goal>    (fully autonomous, no checkpoints)
```

## Workflow

### Stage 1: Decompose

Break research goal into 3-7 independent investigation stages:

```
## Research Decomposition

Goal: <original goal>

### Stage 1: <name>
- Focus: What this stage investigates
- Hypothesis: Expected finding
- Scope: Files/areas to examine
- Tier: LOW | MEDIUM | HIGH
```

### Stage 2: Execute in Parallel

Fire independent stages simultaneously via `task`:

```
task(agent_type="omg:scientist", prompt="[STAGE:1] {focus}. Hypothesis: {hypothesis}.", model="claude-haiku-4.5", mode="background")  # LOW tier
task(agent_type="omg:scientist", prompt="[STAGE:2] {focus}. Hypothesis: {hypothesis}.", model="claude-sonnet-4.6", mode="background")  # MEDIUM tier
task(agent_type="omg:scientist", prompt="[STAGE:3] Deep analysis: {focus}.", model="claude-opus-4.6", mode="background")  # HIGH tier
```

**Model routing by tier:**

| Tier | Model | Use For |
|------|-------|---------|
| LOW | haiku | Data gathering, counting, listing |
| MEDIUM | sonnet | Standard analysis, correlation |
| HIGH | opus | Complex reasoning, hypothesis testing |

### Stage 3: Verify

Cross-validate findings:
- Do stages agree? Where do they conflict?
- Are statistical claims supported by evidence?
- Are there gaps that need additional investigation?

### Stage 4: Synthesize

Aggregate into a comprehensive report:

```
## Research Report: <goal>

### Key Findings
1. [FINDING] ... [STAT:ci] ... [STAT:p_value] ...
2. [FINDING] ...

### Consensus
[Where all stages agree]

### Conflicts
[Where stages disagree + which evidence is stronger]

### Limitations
[LIMITATION] ...

### Recommendations
[Prioritized next actions]
```

Save report to `.omg/research/sciomc-{slug}.md`.

## AUTO Mode

When invoked with `AUTO:` prefix:
- Skip user checkpoints between stages
- Run all stages → verify → synthesize autonomously
- Report results at the end

## State Tracking

- Decomposition: `.omg/research/sciomc-{slug}-decomposition.md`
- Stage results: `.omg/research/sciomc-{slug}-stage-{N}.md`
- Final report: `.omg/research/sciomc-{slug}.md`
- Index: `store_memory` key `omg:research-{slug}`

## Checklist

- [ ] Goal decomposed into 3-7 stages
- [ ] Each stage assigned correct model tier
- [ ] Independent stages fired in parallel
- [ ] Cross-validation completed
- [ ] Report saved to `.omg/research/`
- [ ] Every [FINDING] has [STAT:*] evidence
- [ ] [LIMITATION] markers included
