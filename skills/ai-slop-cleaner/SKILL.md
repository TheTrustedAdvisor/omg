---
name: ai-slop-cleaner
description: "Clean AI-generated code — remove unnecessary abstractions, verbose comments, over-engineering"
tags:
  - code-quality
  - cleanup
  - refactoring
---

## When to Use

- Code has AI-generated patterns: excessive abstractions, verbose comments, unnecessary error handling
- User says "clean slop", "deslop", "anti-slop"
- After a large generation pass that needs tightening
- Ralph post-implementation cleanup

## AI Slop Patterns to Remove

| Pattern | Example | Fix |
|---------|---------|-----|
| **Verbose comments** | `// This function adds two numbers` above `add(a, b)` | Remove — code is self-evident |
| **Unnecessary abstractions** | `createHelperFactory()` used once | Inline the logic |
| **Over-engineered error handling** | try/catch around `2 + 2` | Remove — can't fail |
| **Feature flags for nothing** | `if (ENABLE_ADDITION) { a + b }` | Remove flag, keep code |
| **Premature generalization** | `BaseAbstractProcessor<T>` with one impl | Remove base class |
| **Backwards-compat shims** | `const _oldName = newName // removed` | Delete entirely |
| **Empty catch blocks** | `catch (e) { /* TODO */ }` | Handle or remove |
| **Console.log debris** | `console.log('DEBUG:', value)` | Remove |

## Workflow

### 1. Identify Changed Files

Determine scope:
- If invoked after ralph/autopilot: use the files changed in that session
- If invoked standalone: ask user for scope, or use `bash: git diff --name-only HEAD~1`

### 2. Analyze

Review the identified files for AI slop patterns: unnecessary abstractions, verbose comments restating code, over-engineered error handling, debug artifacts. Simplify without changing behavior. Delegate to @omg:code-simplifier for systematic cleanup.

### 3. Verify

After cleanup:
- Run build via `bash` — must still compile
- Run tests via `bash` — must still pass
- If anything breaks: revert the specific change

### 4. Report

```
## Slop Cleanup Report

Files cleaned: N
Patterns removed:
- 3× verbose comments (file.ts:12, file.ts:45, file.ts:89)
- 1× unused abstraction (helper.ts → inlined into caller)
- 2× console.log debris

Lines removed: X
Verification: build PASS, tests PASS
```

## Review-Only Mode

If invoked with "review" or "scan": analyze but do NOT make changes. Report findings only.

## Checklist

- [ ] Scope defined (changed files or user-specified)
- [ ] Each change preserves functionality
- [ ] Build passes after cleanup
- [ ] Tests pass after cleanup
- [ ] Report lists every change with file:line
