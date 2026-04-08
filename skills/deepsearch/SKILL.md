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

1. Search from 5+ angles: exact name, camelCase/snake_case variants, usages, tests, docs, config. Delegate to @omg:explore for thorough codebase mapping.
2. Cross-validate findings across search strategies
3. If results are insufficient, follow up with targeted `grep`/`glob` searches
3. For symbol-level search: check imports, exports, type definitions, test mocks
4. Present structured findings with relationships

## Output

Follows @omg:explore output format: Findings, Impact, Relationships, Recommendation, Next Steps.

## Trigger Keywords

deepsearch, exhaustive search, find everything

## Example

```bash
copilot -i "deepsearch: find all error handling patterns"
```

## Quality Contract

- 5+ search angles, cross-validated, absolute paths
