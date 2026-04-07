---
name: deepsearch
description: "Deep codebase search — thorough multi-angle exploration with cross-validation"
tags:
  - search
  - exploration
---

## When to Use

- User says "deepsearch" or wants an exhaustive codebase search
- Need to find all occurrences of a pattern, not just the first match
- Complex search requiring multiple strategies (name, usage, tests, docs)

## Workflow

1. Spawn @omg:explore with thoroughness=high:
   ```
   task(agent_type="omg:explore", prompt="THOROUGH search: {query}. Search from 5+ angles: exact name, camelCase/snake_case variants, usages, tests, docs, config. Cross-validate findings. Report ALL matches with absolute paths.", model="claude-haiku-4.5", mode="sync")
   ```
2. If results are insufficient, follow up with targeted searches via `grep`/`glob`
3. For symbol-level search: check imports, exports, type definitions, test mocks
4. Present structured findings with relationships

## Output

Follows @omg:explore output format: Findings, Impact, Relationships, Recommendation, Next Steps.
