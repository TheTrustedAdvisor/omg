---
name: ccg
description: "Claude-Codex-Gemini tri-model orchestration — decompose, query, synthesize"
tags:
  - multi-ai
  - research
---

## When to Use

- Complex decisions needing multiple AI perspectives
- Architecture decisions, design trade-offs, or contentious technical choices
- Cross-validation where different models may disagree
- User says "ccg", "tri-model", or wants multi-perspective analysis

## Workflow

Delegates to @omg:ccg agent, which executes the 3-phase protocol:

1. **Decompose:** Split the request into specialized prompts (Codex: architecture/security, Gemini: UX/alternatives)
2. **Query:** Run advisors in parallel via CLI:
   - `codex exec "<prompt>" --ephemeral -o /dev/stdout`
   - `gemini -p "<prompt>"`
3. **Synthesize:** Unify all perspectives (Codex + Gemini + Claude's own) with attribution and action checklist

## Prerequisites

Full tri-model requires Codex CLI and Gemini CLI. Falls back to available models if one is missing.

- Codex: `npm install -g @openai/codex`
- Gemini: `npm install -g @google/gemini-cli`

## Trigger Keywords

ccg, tri-model, three perspectives

## Example

```
@omg:ccg Should I use a message queue or direct HTTP between microservices?
```

## Quality Contract

- Decomposed prompts tailored to each model's strengths
- All perspectives synthesized with attribution
- Action checklist in output
