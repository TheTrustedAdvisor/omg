---
name: skillify
description: "Convert a successful workflow into a reusable SKILL.md file"
tags:
  - meta
  - skill-creation
---

## When to Use

- A multi-step workflow was executed successfully and should be reusable
- User says "skillify" or "make this a skill"
- Similar to learner but produces a complete SKILL.md with proper structure

## Workflow

1. Analyze the conversation to extract the workflow pattern
2. Identify: trigger conditions, steps, agents used, tools used, success criteria
3. Generate a complete SKILL.md with:
   - Frontmatter (name, description, tags)
   - When to Use / When NOT to Use
   - Step-by-step workflow
   - Delegation guide (which agents, which models)
   - Checklist
4. Save to `plugin/skills/{name}/SKILL.md` via `edit`
5. Report: reinstall plugin to activate the new skill

## Trigger Keywords

skillify, make this a skill

## Example

```bash
copilot -i "skillify: create a skill from the test workflow"
```

## Quality Contract

- Generates valid SKILL.md with frontmatter
