---
name: omg
description: "omg entry point — routes requests to the right agent or skill. Say 'omg' followed by what you need."
tags:
  - router
  - entry-point
  - meta
---

## When to Use

- User prefixes with "omg" — e.g., "omg review this code", "omg fix the bug"
- User says "omg" standalone (show help)

## Routing

Analyze the user's request after "omg" and route to the appropriate agent:

| User says | Route to |
|-----------|----------|
| omg review / security / audit / production readiness | @omg:security-reviewer + @omg:code-reviewer |
| omg fix / debug / error / broken | @omg:debugger |
| omg build / create / implement / autopilot | @omg:autopilot |
| omg plan / design / how should we | @omg:planner or @omg:ralplan |
| omg search / find / explore | @omg:explore |
| omg test / tdd / coverage | @omg:test-engineer |
| omg refactor / simplify / clean | @omg:code-simplifier |
| omg research / investigate | @omg:research-to-pr or @omg:deep-dive |
| omg team / parallel | @omg:team |
| omg (standalone, no task) | Show help skill content |

## Multi-Agent Routing

For broad requests like "review for production readiness", spawn MULTIPLE agents:

1. @omg:security-reviewer — security audit
2. @omg:code-reviewer — code quality
3. @omg:architect — architecture review

Present combined findings.

## Language Handling

The user may speak any language. Translate intent to English keywords internally, then route.

Example: "omg Sicherheitsüberprüfung" → intent: "security review" → @omg:security-reviewer
