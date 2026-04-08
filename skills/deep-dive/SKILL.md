---
name: deep-dive
description: "Activates investigation-to-requirements pipeline — trace root cause then crystallize into actionable spec"
tags:
  - analysis
  - requirements
  - investigation
---

## Activation

This skill activates the **deep-dive agent** for two-stage investigation.

The agent will:
1. **Trace** — investigate root cause with competing hypotheses and evidence ranking
2. **Interview** — crystallize findings into actionable requirements spec
3. **Bridge** — inject trace evidence into interview so nothing is lost

## Why This Exists

Users who run trace and deep-interview separately lose context between steps. Deep Dive connects them with an injection mechanism that transfers findings directly into the requirements process.

## Trigger Keywords

deep dive, deep-dive, investigate deeply, trace and interview

## Persistence

- Trace findings: `.omg/research/trace-{slug}.md`
- Requirements spec: `.omg/research/spec-{slug}.md`
- Index: `store_memory` key `omg:active-spec`

## Stage Handoff

Trace findings flow into interview as injected context — the user doesn't repeat information.

## When NOT to Use

- Already know root cause → use deep-interview directly
- Clear, specific request → execute directly
- Only want investigation → use trace skill
- Already have a spec → use ralph or autopilot

## Example

```bash
copilot -i "deep-dive: why is the build slow"
```

## Quality Contract

- Trace first, then crystallize into actionable spec
