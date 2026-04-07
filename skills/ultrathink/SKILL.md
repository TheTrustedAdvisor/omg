---
name: ultrathink
description: "Deep reasoning mode — engage opus-class model for complex analysis requiring extended thinking"
tags:
  - reasoning
  - analysis
---

## When to Use

- User says "ultrathink" or needs deep reasoning on a complex problem
- Architectural decisions with multiple trade-offs
- Debugging issues where the cause is non-obvious
- Design decisions requiring careful analysis

## Workflow

1. Spawn @omg:architect with opus model for deep analysis:
   ```
   task(agent_type="omg:architect", prompt="DEEP ANALYSIS: {problem}. Consider all angles. Trace through the code. Identify trade-offs. Take your time.", model="claude-opus-4.6", mode="sync")
   ```
2. If the problem is a bug: spawn @omg:tracer instead for evidence-driven causal tracing
3. If the problem is a plan: spawn @omg:critic for multi-perspective review
4. Present analysis with evidence and trade-offs

## When to Combine

- ultrathink + deep-dive: for problems needing both deep reasoning AND requirements crystallization
- ultrathink + ralplan: for architectural decisions needing consensus
