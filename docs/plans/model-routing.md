# Auto-Model-Routing Plan

**Issue:** #37
**Status:** Design

---

## Context

Copilot CLI supports 20+ models from 4 providers:

| Provider | Models | Strengths |
|----------|--------|-----------|
| **Anthropic** | Claude Opus 4.6, Sonnet 4.6, Haiku 4.5 | Reasoning, instruction following |
| **OpenAI** | GPT-5.4, GPT-5.3-Codex, GPT-5 mini, GPT-4.1 | Speed, structured output |
| **Google** | Gemini 3.1 Pro, Gemini 3 Flash, Gemini 2.5 Pro | Long context, multimodal |
| **xAI** | Grok Code Fast 1 | Fast code generation |
| **Fine-tuned** | Raptor mini, Goldeneye | Specialized coding tasks |

Copilot has built-in **auto model selection** that "intelligently chooses models based on real-time system health and model performance." Task-based optimization is coming soon.

## Design Principle

> **Don't fight the platform. Enhance it.**

We should NOT hardcode specific model IDs. Instead, define **intent classes** that map to the right model tier — and let Copilot's auto-selection handle provider choice within that tier.

## Proposed Architecture

### Layer 1: Intent Classes in Agent Definitions

Replace specific model IDs in agent frontmatter with intent classes:

```yaml
# Current (brittle, single-provider)
model: claude-opus-4.6

# Proposed (intent-based, provider-agnostic)
model: claude-opus-4.6  # default
model-class: reasoning   # intent hint
```

Intent classes:

| Class | Intent | Example Models |
|-------|--------|---------------|
| `fast` | Quick lookup, search, I/O | Haiku 4.5, GPT-5 mini, Gemini 3 Flash, Grok Code Fast |
| `standard` | Implementation, reviews | Sonnet 4.6, GPT-5.3-Codex, Gemini 3.1 Pro |
| `reasoning` | Architecture, deep analysis | Opus 4.6, GPT-5.4, Gemini 2.5 Pro |

### Layer 2: Task-Level Routing in AGENTS.md

Update Delegation Routing to use classes:

```markdown
| Need | Agent | Model Class | Default Model |
|------|-------|-------------|---------------|
| Fast search | omg:explore | fast | claude-haiku-4.5 |
| Implement code | omg:executor | standard | claude-sonnet-4.6 |
| Architecture review | omg:architect | reasoning | claude-opus-4.6 |
```

The `model` field in task() calls uses the default. But orchestrators CAN override based on task complexity:

```
# Standard task
task(agent_type="omg:executor", model="claude-sonnet-4.6", ...)

# Complex task → upgrade
task(agent_type="omg:executor", model="claude-opus-4.6", ...)

# Simple task → downgrade
task(agent_type="omg:executor", model="claude-haiku-4.5", ...)
```

### Layer 3: Copilot Auto-Selection Integration

When Copilot's task-based auto-selection launches, we can:
1. Remove explicit `model` from task() calls
2. Let Copilot choose based on the prompt complexity
3. Keep `model-class` as a hint for manual override

### Layer 4: User Override

Users can always override via CLI:
```bash
copilot -p "..." --agent omg:architect --model gpt-5.4
```

## Implementation Plan

### Phase 1: Document current model assignments (immediate)
- Map all 28 agents to intent classes
- No code changes — just documentation

### Phase 2: Add model-class metadata to agents (v0.4)
- Add `model-class:` to agent frontmatter (non-breaking, metadata only)
- Update AGENTS.md Delegation Routing with class column

### Phase 3: Multi-provider examples in skills (v0.4)
- Update skill descriptions to mention provider-agnostic capabilities
- "The architect agent uses a reasoning-class model" not "uses claude-opus-4.6"

### Phase 4: Dynamic routing in orchestrators (v0.5)
- Orchestrator agents analyze task complexity before delegating
- Simple subtask → fast model, complex → reasoning model
- Requires Copilot auto-selection to be stable

## Agent → Intent Class Mapping

### Orchestrators (9)

| Agent | Current Model | Intent Class |
|-------|--------------|-------------|
| autopilot | claude-sonnet-4.6 | standard |
| ralph | claude-sonnet-4.6 | standard |
| team | claude-sonnet-4.6 | standard |
| ralplan | claude-opus-4.6 | reasoning |
| ultrawork | claude-sonnet-4.6 | standard |
| research-to-pr | claude-sonnet-4.6 | standard |
| sciomc | claude-sonnet-4.6 | standard |
| self-improve | claude-sonnet-4.6 | standard |
| deep-dive | claude-sonnet-4.6 | standard |

### Specialists (19)

| Agent | Current Model | Intent Class |
|-------|--------------|-------------|
| explore | claude-haiku-4.5 | fast |
| writer | claude-haiku-4.5 | fast |
| executor | claude-sonnet-4.6 | standard |
| debugger | claude-sonnet-4.6 | standard |
| verifier | claude-sonnet-4.6 | standard |
| test-engineer | claude-sonnet-4.6 | standard |
| designer | claude-sonnet-4.6 | standard |
| git-master | claude-sonnet-4.6 | standard |
| scientist | claude-sonnet-4.6 | standard |
| tracer | claude-sonnet-4.6 | standard |
| document-specialist | claude-sonnet-4.6 | standard |
| qa-tester | claude-sonnet-4.6 | standard |
| architect | claude-opus-4.6 | reasoning |
| analyst | claude-opus-4.6 | reasoning |
| planner | claude-opus-4.6 | reasoning |
| critic | claude-opus-4.6 | reasoning |
| code-reviewer | claude-opus-4.6 | reasoning |
| security-reviewer | claude-opus-4.6 | reasoning |
| code-simplifier | claude-opus-4.6 | reasoning |

## Risk Assessment

| Risk | Mitigation |
|------|-----------|
| Model-class not supported in frontmatter | Use as metadata, not enforced field |
| Auto-selection picks wrong model | Keep explicit model as default, class as hint |
| Provider-specific behaviors differ | Test critical workflows across providers |
| Cost increase from reasoning-class | Monitor usage, document cost implications |

## Sources

- [Supported AI models](https://docs.github.com/en/copilot/reference/ai-models/supported-models)
- [Auto model selection](https://docs.github.com/en/copilot/concepts/auto-model-selection)
- [BYOK and local models](https://github.blog/changelog/2026-04-07-copilot-cli-now-supports-byok-and-local-models/)
