# omg Plugin — Lessons Learned

Empirical findings from E2E testing against Copilot CLI v1.0.18.
These inform plugin design decisions and future improvements.

## Architecture Findings (2026-04-06)

### 1. Plugin Agents Are Prompt Templates, Not Standalone Agents

**Discovery:** `--agent omg:executor` gives only `skill` + `report_intent` tools. No `bash`, `view`, `edit`.

**Root cause:** Plugin agents run in a restricted sandbox. Full tools are only available via the `task` tool (subagent spawning).

**Impact:** All agent prompts must be designed for the `read_agent` → `task` pattern, not for `--agent` direct invocation.

**Resolution:** Documented in ARCHITECTURE.md. Agent prompts reference Copilot-native tool names. Tested and confirmed working via `task` subagent spawning.

### 2. Model Routing via Frontmatter Is Ignored

**Discovery:** `model: claude-opus-4.6` in agent frontmatter has no effect. All agents run on the default model.

**Root cause:** Copilot CLI v1.0.18 does not support per-agent model selection via frontmatter.

**Impact:** Model routing only works via `task(model="claude-opus-4.6")` — the calling agent must specify the model.

**Resolution:** Model hints added to delegation guides in agent prompts. Agent-catalog skill documents ideal model per agent.

### 3. Hooks and MCP Don't Work Globally in Plugins

**Discovery:** Plugin hooks don't fire from other directories. Plugin `.mcp.json` doesn't auto-register MCP servers.

**Root cause:** Copilot CLI plugin hooks/MCP appear to be CWD-scoped, not global.

**Impact:** No hook enforcement, no MCP-based persistence in plugins.

**Resolution:** Hooks dropped (empty `hooks.json`). MCP server code removed entirely. Persistence via Copilot-native `store_memory` + `.omg/` files.

### 4. Copilot Tool Names Differ from Documentation

**Discovery:** Actual CLI tools are `bash`, `view`, `edit`, `create`, `grep`, `glob`, `task` — not `read_file`, `search_files`, `run_in_terminal`, `edit_file`, `invoke_agent`.

**Impact:** All agent prompts needed tool name updates.

**Resolution:** All 19 agents + 34 skills use Copilot-native tool names.

### 5. Agent Prefix Namespacing

**Discovery:** Plugin agents are prefixed with `omg:` (e.g., `omg:executor`, not `executor`).

**Resolution:** All `@agent` references updated to `@omg:agent`.

## Behavioral Test Findings (2026-04-06)

### 6. File Persistence Works Cross-Session

**Test:** Planner writes `.omg/plans/add-dry-run.md` in session 1. New session 2 reads it successfully.

**Conclusion:** `.omg/` file-based persistence is reliable for cross-session handoffs. This is the primary persistence mechanism.

### 7. `store_memory` Persists Cross-Session — CONFIRMED

**Test (2026-04-06 21:17):** Session A wrote `store_memory(key="omg-test-persistence", value="written-at-211731")`. Separate Session B read it back correctly: key, value, and citations all preserved.

**Conclusion:** `store_memory` IS reliable cross-session. Both persistence mechanisms work:
- `.omg/` files: reliable, auditable, git-trackable
- `store_memory`: reliable, automatic discovery by Copilot

**Design implication:** The dual strategy (files for data, `store_memory` for index) is validated. Both are first-class persistence.

### 8. Skill Auto-Triggering Can Be Over-Eager

**Test:** Prompt containing "analyze" triggered `skill(autopilot)` multiple times in early tests.

**Root cause:** Copilot auto-discovers skills by description keywords. Broad descriptions match too aggressively.

**Mitigation:** Keep skill descriptions specific. Avoid generic verbs like "analyze", "build" in descriptions if they're not the primary trigger.

### 9. `-p` Mode Background Agents May Not Return Output

**Test:** Team coordination test with 2 background agents completed (exit 0) but synthesis was not written to stdout.

**Root cause:** `-p` (non-interactive prompt) mode ends the session on the main agent's completion. Background agents may still be running.

**Mitigation:** For multi-agent orchestration, prefer `sync` mode for the final agent in the chain. Or test in interactive mode.

### 10. Deep Interview Works as Designed

**Test:** Given "improve error handling", the skill correctly:
- Detected brownfield, explored codebase patterns
- Scored ambiguity at 76%, identified Success Criteria as weakest
- Asked ONE Socratic question referencing specific code findings
- Did not batch questions or ask codebase facts

**Conclusion:** Well-specified skills with concrete protocols produce correct behavior. Vague skills produce vague behavior.

### 11. TDD Skill Enforces Iron Law

**Test:** RED phase produced 5 meaningful tests that correctly fail. No production code written.

**Conclusion:** The "Iron Law" instruction in the TDD skill is effective at preventing premature implementation.

## Design Principles Validated

1. **Files over memory** — `.omg/` directories are the reliable persistence layer. `store_memory` is supplementary.
2. **Specific over vague** — Skills with detailed protocols (deep-interview, TDD) work well. Thin skills produce inconsistent behavior.
3. **Copilot-native only** — Dropping non-native features (hooks, MCP) was correct. They don't work in plugins.
4. **Agent-catalog as hub** — The catalog-driven delegation test (security-reviewer) worked perfectly. Central directory > distributed knowledge.
5. **Task tool is the key** — Everything revolves around `task(agent_type, prompt, model, mode)`. This is the only working delegation mechanism.

## Open Questions

- [ ] Does `store_memory` persist across Copilot sessions? (Need more testing)
- [x] Can `/fleet` be invoked from within a `task` subagent? → NO. /fleet is IDE-only. Use `task(mode="background") × N` instead (confirmed parallel).
- [ ] What's the max context a `task` subagent receives? (Large prompts may truncate)
- [ ] Does Copilot CLI support `task` with custom agents in interactive mode differently than `-p` mode?
