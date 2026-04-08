---
name: research-to-pr
description: "Activates deep investigation → cloud agent PR creation (Copilot-exclusive)"
tags:
  - strategic
  - differentiator
  - autonomous
---

## Activation

This skill activates the **research-to-pr agent** — omg's flagship workflow.

The agent will:
- Investigate the problem from multiple angles (parallel research)
- Synthesize findings with file:line evidence
- Implement fix or hand off to cloud agent via `/delegate`
- Cloud agent creates PR automatically

## What Makes This Unique

Combines three Copilot-exclusive capabilities:
1. **task subagents** — parallel deep investigation
2. **GitHub MCP tools** — search code, read issues, understand PRs
3. **/delegate** — async cloud agent → automatic PR

## Trigger Keywords

research and fix, investigate and PR, find bug and send PR, research-to-pr

## Persistence

- Research: `.omg/research/research-to-pr-{slug}.md`
- Review: `.omg/reviews/pr-{slug}.md`

## When NOT to Use

- Quick fix → use @omg:executor
- Need user input during implementation → use ralph
- Want to review code before PR → use plan + executor locally

## Example

```bash
copilot -i "research-to-pr: fix the auth token expiry bug"
```

## Quality Contract

- Research locally, /delegate creates PR automatically
