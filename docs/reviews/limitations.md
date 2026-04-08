<!-- Last verified: 2026-04-06 against Copilot CLI v1.0.18 -->
# omg Plugin — Known Limitations & Future Improvements

Documented gaps between OMC capabilities and Copilot CLI plugin features.
When Copilot CLI adds support for these, update the plugin accordingly.

## Resolved — Architecture Findings (Copilot CLI v1.0.18)

### Plugin Agents Are Prompt Templates, Not Standalone Agents

**Finding:** `--agent omg:executor` loads the agent prompt but gives only `skill` + `report_intent` tools. No `bash`, `view`, `edit`, etc.
**Resolution:** Plugin agents are designed to be spawned as subagents via the `task` tool from the default agent. The default agent has all tools (`bash`, `view`, `edit`, `grep`, `glob`, `task`, etc.) and reads plugin agent instructions via `read_agent`.

**Correct usage:**
```
# From the default agent or another agent with tools:
task(agent_type="omg:executor", prompt="implement feature X", mode="background")

# NOT as top-level:
copilot --agent omg:executor  # Limited tools — only for advisory/conversation
```

### Subagents Have Full Tool Access

**Finding:** The `task` tool spawns subagents with full CLI tools. `agent_type: "general-purpose"` gets all tools. Custom agents (`omg:*`) get tools based on their config.
**Parallel dispatch:** Multiple `task` calls run simultaneously. Multiple `task(mode="background")` calls provide native parallel execution (confirmed: 3×sleep(3) = ~3s).
**Model override:** `task` supports `model` parameter for per-subagent model selection.

### Copilot-Native Tool Names

The actual tool names differ from what GitHub docs suggest:

| Copilot Tool | Used for | OMC Equivalent |
|-------------|----------|----------------|
| `bash` | Shell commands, builds, tests | Bash |
| `view` | Read files | Read |
| `edit` | Modify files | Edit, Write |
| `create` | Create new files | Write |
| `grep` | Search file contents | Grep |
| `glob` | Find files by pattern | Glob |
| `task` | Spawn subagents | Agent |
| `web_fetch` | Fetch URLs | WebFetch |
| `store_memory` | Persist state | state_write |
| `read_agent` | Read agent instructions | — |
| `list_agents` | List available agents | — |
| `task(mode="background") × N` | Parallel agent dispatch | tmux orchestration |
| `/delegate` | Cloud handoff | — |

---

## Model Routing (Priority: Medium — partially solved)

**Status:** `model:` frontmatter field is ignored for `--agent` top-level usage.
**But:** `task` tool accepts `model` parameter for subagent spawning — model routing works via delegation.
**Current approach:** Model hints in agent delegation guides. Orchestrating agents (executor, planner, autopilot) specify model when spawning subagents.
**Improve when:** Copilot CLI supports `model:` in frontmatter for top-level `--agent` usage.

### Intended Model Assignment

| Agent | Intended Model | Reason |
|-------|---------------|--------|
| architect, critic, analyst, code-reviewer, security-reviewer, code-simplifier | opus | Deep reasoning, multi-perspective analysis |
| executor, debugger, verifier, test-engineer, designer, git-master, qa-tester, scientist, tracer, document-specialist | sonnet | Balanced speed + quality |
| explore, writer | haiku | Speed-critical, lightweight tasks |

## Agent Prefix Namespacing

**Status:** Copilot CLI prefixes all plugin agents with `omg:` (e.g., `omg:executor`)
**Resolution:** All prompts updated to use `@omg:agent` references.
**Improve when:** Copilot CLI supports unprefixed agent references within the same plugin.

## Hook Scope — TESTED: NOT GLOBAL

**Status:** Tested 2026-04-06. Plugin hooks do NOT fire globally. A sessionStart hook in an installed plugin produces no output when Copilot is started from a different directory.
**Decision:** Hooks cleanly dropped from plugin per Leitsatz. `hooks.json` kept as empty array `[]`.
**Improve when:** Copilot CLI supports global plugin hooks.

## MCP Server — REMOVED

**Status:** Tested 2026-04-06: plugin `.mcp.json` does NOT auto-register MCP servers. Additionally, all MCP features (memory, notepad) are covered by Copilot-native `store_memory` + `.omg/` file persistence.
**Decision:** MCP server code removed entirely. All 9 MCP tools (`omg_status`, `omg_search`, `omg_add`, `omg_sync`, `omg_report`, `omg_memory_*`, `omg_note_*`) replaced by CLI commands via `bash` or `store_memory` + `.omg/` files.
**Improve when:** Copilot CLI supports MCP auto-registration from plugins AND MCP provides value beyond native alternatives.

## LSP / AST Tools

**Status:** No Copilot equivalent
**OMC tools:** lsp_hover, lsp_goto_definition, lsp_find_references, lsp_diagnostics, ast_grep_search/replace
**Copilot:** Agents use `grep`/`glob`/`view` instead
**Improve when:** Copilot CLI exposes language server or AST tools to agents.

## State Persistence

**Status:** Partially available via `store_memory` tool
**OMC tools:** state_read/write, notepad_read/write, remember tags
**Copilot:** `store_memory` exists. MCP could extend this if auto-registration works.
**Improve when:** Full feature parity tested with `store_memory`.

## Session Search

**Status:** Not available — no Copilot equivalent
**OMC tool:** session_search for cross-session queries
**Improve when:** Copilot CLI adds session history features.
