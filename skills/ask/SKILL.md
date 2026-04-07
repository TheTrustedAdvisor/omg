---
name: ask
description: "Route questions to Claude, Codex, or Gemini for multi-perspective answers"
tags:
  - multi-ai
  - research
---

## When to Use

- User wants a second opinion from a different AI
- User says "ask codex", "ask gemini", or wants multi-model input
- Complex question that benefits from multiple perspectives

## Workflow

1. Route the question to the specified AI via `bash`:
   - `codex -p "question"` — OpenAI Codex CLI
   - `gemini -p "question"` — Google Gemini CLI
2. Capture the response
3. Present the answer (or synthesize if multiple models queried)

## Prerequisites

Requires the target CLI to be installed:
- Codex: `npm install -g @openai/codex`
- Gemini: `npm install -g @google/gemini-cli`

If the target CLI is not available, note the limitation and answer with available resources.
