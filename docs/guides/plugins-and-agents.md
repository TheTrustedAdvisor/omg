# Plugins and Agent Delegation Guide

## Copilot Plugin Format

omg generates output in the native Copilot CLI plugin format. Every `omg add` or `omg translate` produces a `plugin.json` alongside the agents, skills, hooks, and MCP config.

### Plugin Structure

```
your-project/
├── plugin.json                         # Plugin manifest
├── .github/
│   ├── agents/
│   │   ├── architect.agent.md          # Strategic advisor (read-only)
│   │   ├── executor.agent.md           # Task executor (full tools)
│   │   └── debugger.agent.md           # Root-cause analyst
│   ├── skills/
│   │   ├── autopilot/SKILL.md          # Autonomous execution
│   │   └── ralph/SKILL.md              # Sequential + verified
│   ├── hooks/
│   │   └── hooks.json                  # Lifecycle hooks
│   ├── copilot-instructions.md         # Global instructions
│   └── instructions/                   # Contextual rules
└── .copilot/
    └── mcp-config.json                 # MCP server config
```

### Installing as a Plugin

```bash
# Install from local project
copilot plugin install /path/to/your-project

# Install from GitHub
copilot plugin install TheTrustedAdvisor/omg

# Verify
copilot plugin list

# Uninstall
copilot plugin uninstall omg
```

### plugin.json Format

```json
{
  "name": "omg",
  "description": "OMC for GitHub Copilot — agents, skills, model selection, MCP servers",
  "version": "0.1.0",
  "agents": "agents/",
  "skills": ["skills/"],
  "hooks": "hooks.json",
  "mcpServers": ".mcp.json"
}
```

omg generates this automatically. Component paths are only included when the corresponding components exist in the output.

## Agent Format (.agent.md)

Each agent is a Markdown file with YAML frontmatter:

```markdown
---
name: architect
description: "Strategic Architecture & Debugging Advisor (READ-ONLY)"
model: claude-opus-4.6
tools:
  - read_file
  - search_files
  - invoke_agent
  - ask_user
  - create_task
handoffs:
  - omc/executor
  - omc/debugger
---

<Agent_Prompt>
<Role>
You are a strategic architecture advisor.
</Role>

<Delegation>
- When implementation is needed, delegate to @executor via invoke_agent
- When debugging is needed, delegate to @debugger via invoke_agent
</Delegation>
</Agent_Prompt>
```

### Required Frontmatter Fields

| Field | Required | Description |
|---|---|---|
| `name` | Yes | Agent identifier (lowercase, hyphens) |
| `description` | Yes | What the agent does + when to use it |
| `model` | No | LLM model (dot format: `claude-opus-4.6`) |
| `tools` | No | Available tools (defaults to all) |
| `handoffs` | No | Agent IDs this agent can delegate to |

## Agent-to-Agent Delegation

Agents delegate to each other using Copilot's native `invoke_agent` tool. This enables team-like orchestration without custom runtime code.

### How It Works

```
User asks: "Build a REST API with tests"
     ↓
Architect agent (activated)
  - Designs the API structure
  - Delegates implementation → invoke_agent(@executor)
     ↓
Executor agent
  - Implements the code
  - Delegates testing → invoke_agent(@debugger)
     ↓
Debugger agent
  - Runs tests, finds issues
  - Delegates fixes → invoke_agent(@executor)
     ↓
Executor fixes issues
  - Reports completion via update_task
```

### Delegation Graph

```
architect ←→ executor ←→ debugger
    ↕                        ↕
    └────────────────────────┘
```

Every agent can delegate to any other agent via `invoke_agent`. The delegation is bidirectional — the debugger can ask the architect for review, the architect can ask the executor to implement.

### How omg Generates Delegation

1. **Explicit (from OMC fixtures):** Agents with `<Delegation>` sections in their instructions are exported as-is.

2. **Automatic (from handoffs):** The enhance pipeline stage (`injectDelegationInstructions`) reads the `handoffs[]` array and auto-generates a `<Delegation>` section if one doesn't exist:

```
Agent has handoffs: ["omc/executor", "omc/debugger"]
     ↓ enhance stage
Appends to instructions:
<Delegation>
- Delegate to @executor via invoke_agent when their expertise is needed
- Delegate to @debugger via invoke_agent when their expertise is needed
- Report task status via update_task
</Delegation>
```

### Task Tracking Across Agents

Agents use Copilot's native task tools to coordinate:

| Tool | Purpose |
|---|---|
| `create_task` | Create a task for another agent |
| `update_task` | Report progress or completion |
| `list_tasks` | See all tasks across agents |

## Skill Format (SKILL.md)

```markdown
---
name: autopilot
description: >
  Autonomous end-to-end task execution. Use when the user wants
  hands-off completion of a complex task.
---

Instructions for autonomous execution...
```

### Required Frontmatter

| Field | Required | Description |
|---|---|---|
| `name` | Yes | Skill identifier (lowercase, hyphens) |
| `description` | Yes | Triggers Copilot's auto-discovery |

### Auto-Discovery

Copilot automatically discovers skills by matching the user's prompt against skill descriptions. No routing table needed — write good descriptions.

### Resource Files

Skills can include additional files in their directory:

```
skills/deploy/
├── SKILL.md
├── deploy.sh          # Referenced in instructions
└── config-template.yaml
```

Copilot makes all files in the skill directory available alongside the instructions.

## Hooks (hooks.json)

```json
{
  "version": 1,
  "hooks": {
    "postToolUse": [
      {
        "type": "command",
        "bash": "eslint --fix $TOOL_INPUT_PATH",
        "timeoutSec": 10
      }
    ]
  }
}
```

### Available Events

| Event | CLI | VS Code | When |
|---|---|---|---|
| `sessionStart` | Yes | Yes | Session begins |
| `sessionEnd` | Yes | Yes | Session ends |
| `userPromptSubmitted` | Yes | Yes | User sends message |
| `preToolUse` | Yes | Yes | Before tool execution |
| `postToolUse` | Yes | Yes | After tool execution |
| `errorOccurred` | Yes | Yes | Error raised |
| `subagentStart` | No | Yes | Subagent started |
| `subagentStop` | No | Yes | Subagent stopped |

### Hook Command Fields

| Field | Required | Description |
|---|---|---|
| `type` | Yes | Must be `"command"` |
| `bash` | Yes | Shell command to execute |
| `powershell` | No | Windows PowerShell alternative |
| `cwd` | No | Working directory |
| `timeoutSec` | No | Timeout in seconds (default: 30) |
| `env` | No | Environment variables |

## Validation

Run `omg validate` to check all generated files:

```bash
omg validate /path/to/output
# ✓ 9 files validated — no issues found
```

Checks:
- `plugin.json`: name, description, version required
- `.agent.md`: name + description in frontmatter required
- `SKILL.md`: name + description in frontmatter required
- `hooks.json`: version:1, valid event names, command format
- `mcp-config.json`: JSON schema validation
