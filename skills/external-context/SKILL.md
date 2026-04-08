---
name: external-context
description: "External documentation and web research via parallel document-specialist agents"
tags:
  - research
  - documentation
---

## When to Use

- Need to look up external documentation, API references, or official docs
- User says "external context", "look up docs", "what does the API say"
- Need version compatibility info or migration guides
- Comparing library options or evaluating packages

## When NOT to Use

- Codebase-internal search → use @omg:explore
- Root cause analysis → use trace skill
- Full investigation → use deep-dive skill

## Workflow

### 1. Parse the Research Need

Identify: what specific information? Which library/API/framework? What version?

### 2. Research via Document Specialists

Research the topic using `web_fetch` or by delegating to @omg:document-specialist agents. For broad research, run multiple searches in parallel. For comparative research (e.g., "Redis vs Memcached"), investigate each option separately and compare.

### 3. Synthesize

Combine findings:
- Merge sources, resolve conflicts
- Flag version-specific information
- Note outdated docs (>2 years old)

### 4. Persist

Save to `.omg/research/external-{topic}.md` for future reference.
Index via `store_memory` key `omg:research-{topic}`.

## Output Format

```markdown
## Research: {topic}

### Answer
{direct answer with source URL}

### Code Example
{working code example if applicable}

### Version Notes
{compatibility information}

### Sources
- [Title](URL) — {brief description}
```

## Rules

- Always cite sources with URLs
- Prefer official documentation over blog posts
- Flag information older than 2 years
- Note version compatibility explicitly

## Checklist

- [ ] Sources cited with URLs
- [ ] Official docs preferred
- [ ] Version compatibility noted
- [ ] Research saved to `.omg/research/`

## Trigger Keywords

external context, look up docs, what does API say

## Example

```bash
copilot -i "external-context: vitest snapshot testing API"
```

## Quality Contract

- Sources cited with URLs, official docs preferred
