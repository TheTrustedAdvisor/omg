---
name: remember
description: "Save persistent notes and context that survive across sessions"
tags:
  - utility
  - persistence
---

## When to Use

- User wants to save information for future sessions
- User says "remember this", "save for later", "note this"
- Important context that should persist across conversations

## Workflow

1. Extract the key information to remember
2. Use `store_memory` to persist it
3. Confirm what was saved

## Notes

Copilot CLI's `store_memory` tool provides cross-session persistence. Saved items can be recalled in future sessions automatically.
