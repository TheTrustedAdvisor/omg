---
name: ccg
description: "Claude-Codex-Gemini tri-model orchestration — get three perspectives, then synthesize"
tags:
  - multi-ai
  - research
---

## When to Use

- Complex decision needing multiple AI perspectives
- User says "ccg" or wants tri-model analysis
- Architecture decisions, design trade-offs, or contentious technical choices

## Workflow

1. Send the same question to all three AIs via `bash`:
   - Claude (current session) — analyze directly
   - Codex: `codex -p "question"` (if installed)
   - Gemini: `gemini -p "question"` (if installed)
2. Collect all three responses
3. Synthesize: identify agreement, disagreements, and unique insights
4. Present unified recommendation with attribution

## Prerequisites

Requires Codex CLI and Gemini CLI for full tri-model. Falls back to available models if one is missing.
