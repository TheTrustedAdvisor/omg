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

1. **Explore** — map all files and patterns related to the topic. @omg:explore can help with this.

2. **Analyze from multiple perspectives** (in parallel where possible):
   - Review for architectural soundness, trade-offs, and design patterns. @omg:architect can help.
   - Review for security vulnerabilities and threat surface. @omg:security-reviewer can help.
   - Review for code quality, maintainability, and anti-patterns. @omg:code-reviewer can help.

3. **Synthesize** findings from all perspectives:
   - Areas of agreement
   - Areas of disagreement
   - Prioritized recommendations

4. **Persist** analysis to `.omg/research/analysis-{topic}.md`

## Output

Structured multi-perspective report with evidence, trade-offs, and prioritized action items.
