---
name: btw
description: "Quick side-question without derailing the current task — answers in a separate context to keep the main conversation clean"
tags:
  - utility
  - context
  - ephemeral
---

## When to Use

- User says "btw", "by the way", "quick question", "nebenbei", "kurze Frage"
- User wants to ask something unrelated to the current task
- User needs a quick lookup without losing their place

## How It Works

Answer the user's question **directly and briefly** (max 5 sentences). Then say:

```
(btw answered — continuing with your task)
```

## Rules

- **Be brief.** Max 5 sentences. This is a side-channel, not a deep dive.
- **Do NOT use tools.** Answer from knowledge only — no file reads, no bash, no edits.
- **Do NOT change the current task.** After answering, the user's previous task continues.
- **Do NOT reference the btw question in later responses.** Treat it as ephemeral.
- **Match the user's language.** If they ask in German, answer in German.

## Examples

```
User: btw what's the difference between vitest and jest?
Agent: vitest is built on Vite with native ESM support and near-instant
HMR. jest uses custom transforms and is slower for TypeScript projects.
Both have similar APIs — vitest is compatible with most jest tests.
(btw answered — continuing with your task)

User: nebenbei, was ist TF-IDF?
Agent: TF-IDF (Term Frequency–Inverse Document Frequency) gewichtet
Wörter nach Häufigkeit im Dokument vs. Seltenheit im Gesamtkorpus.
Häufige aber seltene Wörter bekommen hohe Scores.
(btw beantwortet — weiter mit deiner Aufgabe)
```
