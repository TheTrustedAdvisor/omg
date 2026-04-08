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

1. Perform deep analysis of the problem using opus-class reasoning (claude-opus-4.6). Consider all angles, trace through the code, identify trade-offs. @omg:architect can help with architectural depth.
2. If the problem is a bug: delegate to @omg:tracer for evidence-driven causal tracing
3. If the problem is a plan: delegate to @omg:critic for multi-perspective review
4. Present analysis with evidence and trade-offs

## When to Combine

- ultrathink + deep-dive: for problems needing both deep reasoning AND requirements crystallization
- ultrathink + ralplan: for architectural decisions needing consensus

## Trigger Keywords

ultrathink, deep reasoning, think deeply

## Example

```bash
copilot -i "ultrathink: should we use microservices or monolith?"
```

## Quality Contract

- Opus-class deep analysis with trade-offs
