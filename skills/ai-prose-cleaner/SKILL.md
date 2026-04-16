---
name: ai-prose-cleaner
description: "Detect and clean AI-typical writing patterns in documents — em dashes, filler phrases, over-formality"
tags:
  - writing
  - cleanup
  - documents
---

## When to Use

- Documents sound "too AI" — em dashes, "delve", "it's worth noting", hedging stacks
- Before sending proposals, READMEs, or reports to clients/reviewers
- After AI-assisted writing that needs a human voice pass
- Batch scan agent/skill definitions for AI fingerprints
- User says "deslop prose", "clean AI writing", "humanize"

## Workflow

Delegates to @omg:ai-prose-cleaner agent, which operates in two modes:

1. **Detect (default):** Scan files, report AI patterns with line numbers, severity rating (LOW → HEAVY)
2. **Clean:** Rewrite flagged patterns in place, preserving meaning. Tier 1 patterns auto-fixed, Tier 3 structural changes suggested for manual review.

## Supported Languages

English and German AI patterns detected (Halbgeviert-Striche, "Es ist erwähnenswert", etc.)

## Trigger Keywords

clean AI writing, humanize, deslop prose, AI speech, prose cleaner

## Examples

```
@omg:ai-prose-cleaner scan docs/proposal.md
@omg:ai-prose-cleaner clean README.md
@omg:ai-prose-cleaner scan plugin/agents/*.md
```

## Quality Contract

- Every rewrite preserves factual content — only voice changes
- Report includes line numbers, pattern tier, and suggestions
- Rating scale: patterns per 1,000 words (LOW < 1, MILD 1-3, MODERATE 3-6, HEAVY > 6)
