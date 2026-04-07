---
name: deep-analyze
description: "Deep analysis mode — multi-agent investigation of complex systems or problems"
tags:
  - analysis
  - investigation
---

## When to Use

- User says "deep-analyze" or "deep analyze"
- Complex system needs thorough understanding from multiple angles
- Architecture review, performance analysis, or security audit

## Workflow

1. **Explore** — map the area under analysis:
   ```
   task(agent_type="omg:explore", prompt="Map all files and patterns related to: {topic}", model="claude-haiku-4.5", mode="background")
   ```

2. **Analyze from multiple perspectives** (parallel):
   ```
   task(agent_type="omg:architect", prompt="Architectural analysis of: {topic}", model="claude-opus-4.6", mode="background")
   task(agent_type="omg:security-reviewer", prompt="Security analysis of: {topic}", model="claude-opus-4.6", mode="background")
   task(agent_type="omg:code-reviewer", prompt="Code quality analysis of: {topic}", model="claude-opus-4.6", mode="background")
   ```

3. **Synthesize** findings from all perspectives:
   - Areas of agreement
   - Areas of disagreement
   - Prioritized recommendations

4. **Persist** analysis to `.omg/research/analysis-{topic}.md`

## Output

Structured multi-perspective report with evidence, trade-offs, and prioritized action items.
