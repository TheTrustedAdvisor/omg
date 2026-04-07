---
name: learner
description: "Extract a reusable skill from the current conversation — learn from what just worked"
tags:
  - meta
  - skill-creation
---

## When to Use

- A workflow was just executed successfully and should be captured as a reusable pattern
- User says "learn this", "save as skill", "remember how we did this"
- A multi-step process worked well and should be repeatable

## Workflow

### 1. Analyze Conversation

Review the conversation to identify the successful pattern:
- What was the goal?
- What steps were taken?
- Which agents were involved?
- What tools were used?
- What made it succeed vs. generic approaches?

### 2. Extract Pattern

Identify the reusable elements:
- **Trigger conditions:** When should this skill activate?
- **Steps:** Ordered workflow (not just a list of actions)
- **Agent routing:** Which agents for which steps, with model hints
- **Persistence:** What state to save and where
- **Success criteria:** How to know it worked
- **Failure modes:** What can go wrong and how to handle it

### 3. Generate SKILL.md

Create a complete SKILL.md with proper structure:

```markdown
---
name: {skill-name}
description: "{one-line description}"
tags:
  - {relevant-tags}
---

## When to Use
{trigger conditions}

## When NOT to Use
{anti-patterns}

## Workflow
{step-by-step protocol}

## Tool Usage
{which tools and agents, with task() examples}

## Examples
{good and bad examples from the conversation}

## Checklist
{success verification}
```

### 4. Save

Write to `plugin/skills/{name}/SKILL.md` via `edit`/`create`.
Report: "New skill saved. Reinstall plugin to activate: `copilot plugin install ./plugin`"

## What Makes a Good Learned Skill

- **Specific enough** to be useful (not "do good things")
- **General enough** to apply beyond this one conversation
- **Protocol-driven** with concrete steps (not vague advice)
- **Tested** — the conversation proved it works

## Checklist

- [ ] Successful pattern identified from conversation
- [ ] Trigger conditions defined
- [ ] Steps are concrete and ordered
- [ ] Agent routing specified with model hints
- [ ] Examples included from actual conversation
- [ ] SKILL.md saved with proper frontmatter
