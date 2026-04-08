---
name: sciomc
description: "Activates parallel research — staged scientist agents investigate from multiple angles"
tags:
  - research
  - analysis
  - parallel
---

## Activation

This skill activates the **sciomc agent** for comprehensive parallel research.

The agent will:
- Decompose the research goal into 3-7 investigation stages
- Spawn scientist agents at tiered models (haiku → sonnet → opus)
- Cross-validate findings across stages
- Synthesize into a unified research report

## Trigger Keywords

sciomc, research, parallel analysis, multi-angle investigation

## Usage

```
sciomc <research goal>
sciomc AUTO: <goal>    (fully autonomous, no checkpoints)
```

## Persistence

- Decomposition: `.omg/research/sciomc-{slug}-decomposition.md`
- Stage results: `.omg/research/sciomc-{slug}-stage-{N}.md`
- Final synthesis: `.omg/research/sciomc-{slug}.md`

## When NOT to Use

- Single quick lookup → use @omg:explore
- External documentation → use external-context skill
- Root cause analysis → use trace skill

## Example

```bash
copilot -i "sciomc: analyze test coverage patterns"
```

## Quality Contract

- Staged parallel investigation, cross-validated findings
