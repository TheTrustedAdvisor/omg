---
name: writer-memory
description: "Agentic memory system for writers — track characters, relationships, scenes, themes, and maintain consistency"
tags:
  - writing
  - persistence
  - creative
---

## When to Use

- User is writing fiction or long-form content
- Need to track characters, relationships, plot threads, scenes
- User says "writer memory" or wants to manage story elements
- Consistency checking needed across chapters or scenes

## Operations

| Command | Description |
|---------|-------------|
| `add character [name]` | Create new character profile |
| `add scene [title]` | Log a new scene with setting, characters, events |
| `add relationship [A] [B]` | Define relationship between characters |
| `add theme [name]` | Track a recurring theme or motif |
| `check [text]` | Verify text against established facts |
| `synopsis` | Generate current story synopsis |
| `timeline` | Show chronological event timeline |
| `cast` | Show all characters with brief descriptions |

## Data Model

Story state persisted to `.omg/research/writer-memory.json`:

```json
{
  "title": "Story Title",
  "characters": [
    {
      "name": "Alice",
      "description": "Protagonist, 30s, software engineer",
      "traits": ["analytical", "stubborn"],
      "arc": "Learns to trust others",
      "firstAppearance": "Chapter 1",
      "relationships": [
        { "with": "Bob", "type": "colleague", "notes": "tension over project lead" }
      ]
    }
  ],
  "scenes": [
    {
      "title": "The Meeting",
      "chapter": 1,
      "setting": "Office conference room, Monday morning",
      "characters": ["Alice", "Bob"],
      "events": ["Project assigned", "Alice chosen as lead"],
      "mood": "tense"
    }
  ],
  "themes": [
    { "name": "Trust", "occurrences": ["Ch1: Alice won't delegate"] }
  ],
  "timeline": [
    { "event": "Project assigned", "when": "Monday", "scene": "The Meeting" }
  ]
}
```

## Consistency Check

When user requests a check:

1. Read `.omg/research/writer-memory.json`
2. Compare new text against established facts:
   - Character traits: "Alice suddenly trusts Bob" — contradicts established arc?
   - Timeline: "Tuesday morning meeting" — but scene says Monday?
   - Relationships: "Alice's boss Bob" — but relationship says colleague?
3. Report inconsistencies with references to source scenes

## Persistence

- **File:** `.omg/research/writer-memory.json` (source of truth)
- **Index:** `store_memory` with key `omg:writer-memory` → `{ "path": "...", "characters": N, "scenes": N }`
- Cross-session: file persists, memory index allows quick discovery

## Checklist

- [ ] Story state saved to `.omg/research/writer-memory.json`
- [ ] Characters have descriptions, traits, and arcs
- [ ] Relationships are bidirectional
- [ ] Scenes have setting, characters, events
- [ ] Consistency checks reference established facts

## Synopsis Generation

When user requests `synopsis`, generate from tracked data:

```markdown
# {title} — Synopsis

## Characters
{for each character: name, description, current arc status}

## Plot So Far
{chronological events from timeline}

## Active Threads
{unresolved plot points, open conflicts}

## Themes
{themes with latest occurrences}
```

## Relationship Web

Track bidirectional relationships:
```
Alice ←colleague→ Bob
Alice ←mentor→ Carol
Bob ←rival→ David
```

When adding `add relationship A B`:
1. Create A→B entry
2. Create B→A entry (mirror)
3. Flag if contradicts existing relationship

## Character Arc Tracking

Each character has an arc with phases:
```json
{
  "arc": "Learns to trust others",
  "phase": "resistance",
  "phases": ["introduction", "resistance", "catalyst", "transformation", "resolution"],
  "evidence": ["Ch1: refuses to delegate", "Ch3: forced to collaborate"]
}
```

When checking consistency, verify new actions match current arc phase.
