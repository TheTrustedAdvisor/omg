# omg Best Practices — Dos & Don'ts

Empirical findings from 1,200+ tests and real-world usage.

---

## Dos

### Do: Be specific in your request
```bash
# Good — clear scope and action
copilot -i "autopilot: add input validation to src/commands/init.ts"

# Bad — too vague, agent guesses
copilot -i "improve the code"
```

### Do: Use the right agent for the job
| Need | Say this |
|------|----------|
| Full feature | `autopilot: build X` |
| Must finish with proof | `ralph: fix all lint errors` |
| Quick question | `btw what is X?` |
| Security check | `review security of src/` |
| Plan first | `plan: how to add authentication` |

### Do: Let agents complete before interrupting
Agents work in phases. Give them time to explore → plan → implement → verify. Interrupting mid-phase loses context.

### Do: Use `/delegate` for PR creation
```bash
# After local investigation:
/delegate implement the fix and create a PR
```
The cloud agent inherits your conversation context — no need to re-explain.

### Do: Check `.omg/` for persisted artifacts
```bash
ls .omg/plans/     # Work plans
ls .omg/research/  # Analysis output
ls .omg/reviews/   # Review verdicts
ls .omg/qa-logs/   # Iteration state
```
These survive across sessions. Agents check them before starting fresh.

### Do: Speak your language
German, French, Japanese, Spanish, Italian — omg translates intent to English internally and responds in your language.

---

## Don'ts

### Don't: Prescribe HOW — describe WHAT
```bash
# Bad — prescribing agent chain
copilot -i "use omg:analyst then omg:planner then omg:executor to add auth"

# Good — describe the outcome
copilot -i "autopilot: add JWT authentication to the API"
```
The orchestrator decides which agents to use. Prescribing the chain doesn't work (Copilot ignores skill-prescribed task() sequences).

### Don't: Expect deterministic agent routing
Copilot's auto-routing is LLM-based, not rule-based. The same prompt may route to different agents on different runs. This is by design — the LLM picks what it considers most effective.

### Don't: Rely on model: for cost optimization (yet)
The `model:` field in agent frontmatter is not yet honored for plugin agents (fix shipping after Copilot CLI v1.0.21). All agents currently run on the session default model.

### Don't: Put orchestration logic in skills
Skills are **context**, not **programs**. They describe capabilities, not prescribe steps. Orchestration belongs in agents.

```
# Wrong: skill with task() calls
task(agent_type="omg:executor", model="claude-sonnet-4.6", ...)

# Right: skill describes the outcome
"The agent should implement the change and verify with tests."
```

### Don't: Modify user project files from the plugin
omg integrates invisibly via AGENTS.md (loaded every session). Don't auto-create `.github/copilot-instructions.md` or other user files.

### Don't: Expect /fleet in non-interactive mode
`/fleet` exists in Copilot CLI but dispatches via batch tool calls, not subagents, in `-p` mode. For programmatic parallel execution, use `task(mode="background")`.

### Don't: Forget to bump plugin.json version
Users can't update via `copilot plugin update omg` if the version number hasn't changed.

---

## Architecture Principles

### Agents orchestrate, skills provide capabilities
- **Agents** (.agent.md) = WHO + HOW (persona, tools, delegation decisions)
- **Skills** (SKILL.md) = WHAT (focused capability, auto-loaded when relevant)

### Delegate to specialists
Each agent does one thing well. Don't build Swiss Army knife agents — use the routing table.

### Evidence over claims
"Tests pass" means you ran `npm test` and saw green — not "it should work."

### Persist everything
Every plan, review, and research output goes to `.omg/` before proceeding. If the session ends, the next session can resume.

### Platform-first
Use Copilot-native features (task(), /delegate, store_memory) instead of custom workarounds. When the platform improves, omg improves automatically.

---

## Skill Documentation Standard

Every skill MUST include:

```markdown
---
name: skill-name
description: "One-line action-oriented description"
tags:
  - category
---

## When to Use
- Trigger keywords and user intents

## Activation
- What happens when the skill activates

## Trigger Keywords
- Comma-separated list

## Quality Contract
- What the user can expect

## Example
- Copy-paste command + expected output

## Diagram (where applicable)
- Mermaid diagram showing the workflow
```

## Documentation Standards

Every document in the omg project MUST include:

### 1. Visual overview (Mermaid)
Use Mermaid diagrams to visualize:
- **Flowcharts** for decision trees and routing
- **Sequence diagrams** for multi-agent interactions
- **Graph TD/LR** for architecture and data flow

```markdown
## Example Mermaid usage:

` ` `mermaid
graph LR
    User --> Agent --> Skill --> Result
` ` `
```

### 2. Copy-paste example
Every feature, skill, or agent MUST have a runnable example:
```bash
copilot -i "command here"
```
With expected output shown below.

### 3. Cross-references
Link to related docs using relative paths:
```markdown
See [Architecture](../docs/architecture/pipeline.md) for details.
```

### 4. Animated demos (for key features)
Record with asciinema, convert with agg:
```bash
asciinema rec demo.cast --command "copilot -p '...' -s --yolo"
agg demo.cast demo.gif --theme dracula --font-size 16 --speed 2
```
Embed: `![demo](assets/demo.gif)`
