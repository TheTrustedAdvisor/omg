# OMC → Copilot Adaptation Rules

This document defines how OMC (oh-my-claudecode) agent prompts and skills are adapted into Copilot-native `.agent.md` and `SKILL.md` files. Rules are divided into **mechanical** (automated by the pipeline) and **creative** (applied by humans during refinement).

## Mechanical Rules (Pipeline-Automated)

These rules are implemented in the omg pipeline and applied automatically when generating plugin content.

### M1: Tool Name Mapping

| OMC Tool | Copilot Alias | Notes |
|---|---|---|
| Read | read_file | |
| Grep | search_files | |
| Glob | search_files | Combined with Grep |
| Bash | run_in_terminal | |
| Edit | edit_file | |
| Write | edit_file | Combined with Edit |
| MultiEdit | edit_file | |
| Agent | invoke_agent | |
| AskUser | ask_user | |
| TaskCreate | create_task | |
| TaskUpdate | update_task | |
| TaskList | list_tasks | |
| NotebookEdit | edit_notebook | |
| WebFetch | fetch | |
| WebSearch | fetch | |

**Implementation:** `src/mappings/omc-tool-names.ts` → `src/mappings/copilot-tool-aliases.ts`

### M2: Model Name Mapping

| OMC Name | Copilot Frontmatter |
|---|---|
| `claude-opus-4-6` / `opus` | `claude-opus-4.6` |
| `claude-sonnet-4-6` / `sonnet` | `claude-sonnet-4.6` |
| `claude-haiku-4-5` / `haiku` | `claude-haiku-4.5` |

**Implementation:** `src/mappings/omc-model-names.ts` → `src/mappings/copilot-model-names.ts`

### M3: Frontmatter Generation

Every agent gets YAML frontmatter with these fields:

```yaml
---
name: agent-name              # from AgentDef.name
description: "..."            # from AgentDef.description
model: claude-sonnet-4.6      # from M2 mapping
tools:                         # from M1 mapping of AgentDef.tools
  - read_file
  - search_files
handoffs:                      # from AgentDef.handoffs
  - omg:executor
---
```

**Required fields:** `name`, `description` (per Copilot docs)
**Implementation:** `src/exporters/copilot-cli/agents.ts`

### M4: Delegation Injection

When an agent has `handoffs[]`, the enhance stage injects a `<Delegation>` section into the instructions body — but ONLY if no delegation section already exists.

```markdown
## Delegation
- Delegate to @omg:executor via invoke_agent when implementation is needed
- Delegate to @omg:debugger via invoke_agent when debugging is needed
- Report task status via update_task
```

**Note:** Plugin agents are namespaced. References use `@omg:agent-name`, not `@agent-name`.

**Implementation:** `src/pipeline/enhance.ts` → `injectDelegationInstructions()`

### M5: Fleet Replacement

All `tmux` references in instructions are replaced with `/fleet parallel dispatch`.

**Implementation:** `src/pipeline/enhance.ts` → `replaceTmuxWithFleet()`

### M6: Agent Namespace in Skills

Skill instructions that reference agents must use the plugin namespace:

| In OMC | In omg Plugin |
|---|---|
| `@executor` | `@omg:executor` |
| `delegate to architect` | `delegate to @omg:architect` |
| `invoke_agent(debugger)` | `invoke_agent(@omg:debugger)` |

**Implementation:** To be added to enhance stage.

---

## Creative Rules (Human-Applied During Refinement)

These rules require human judgment. Apply them when hand-refining pipeline-generated agents.

### K1: XML Tags → Markdown Headings

OMC prompts use Claude-specific XML:
```xml
<Agent_Prompt>
  <Role>You are an architect.</Role>
  <Constraints>READ-ONLY</Constraints>
  <Tool_Usage>Use search_files first.</Tool_Usage>
</Agent_Prompt>
```

Convert to universal Markdown (works with any LLM, not just Claude):
```markdown
## Role
You are an architect.

## Constraints
- READ-ONLY: never modify files

## Tool Usage
- Use search_files before reading entire files
```

**Why Markdown:** Copilot uses multiple LLMs (Claude, GPT, Gemini). XML tags that Claude interprets as structure, GPT may treat as literal text. Markdown headings are universally understood.

**Exception:** If testing shows an LLM responds better to XML, keep it — but document why.

### K2: OMC State → MCP or Drop

| OMC Feature | Copilot Adaptation |
|---|---|
| `state_read(key)` | "Read project context from omg_memory_read via MCP" |
| `state_write(key, value)` | "Save to project memory via omg_memory_write" |
| `notepad_read(section)` | "Read from notepad via omg_note_read" |
| `notepad_write(section, content)` | "Write to notepad via omg_note_write" |
| `project_memory_read/write` | Same as state → omg_memory_read/write |
| `session_search` | **DROPPED** — no Copilot equivalent |
| `<remember>` tags | **DROPPED** — use MCP memory_write explicitly |
| `<remember priority>` | **DROPPED** — use MCP memory_write explicitly |

**In agent instructions, replace:**
```
# OMC
Save this finding to notepad_write_priority for later.

# Copilot
Save this finding via omg_note_write for cross-session access.
```

### K3: OMC Hook Events → Copilot Hooks or Instructions

27 OMC events → 6 Copilot hook events:

| Copilot Event | OMC Equivalent | Translatable |
|---|---|---|
| sessionStart | SessionStart | Yes |
| sessionEnd | SessionEnd | Yes |
| userPromptSubmitted | UserPromptSubmit | Yes |
| preToolUse | PreToolUse | Yes |
| postToolUse | PostToolUse | Yes |
| errorOccurred | Error | Yes |

The remaining 21 OMC events have no hook equivalent. Adapt by embedding the behavior in agent instructions:

```
# OMC: PreCompact hook runs before context compaction
# Copilot: No hook → add to agent instructions:
"When the conversation is getting long, summarize key findings
before continuing to preserve context."
```

### K4: Verification Protocol

OMC enforces verification via hooks and state. Copilot does it via agent delegation:

```markdown
## Verification Protocol (in executor agent)
After completing implementation:
1. Delegate to @omg:verifier via invoke_agent
2. Wait for PASS/FAIL verdict
3. If FAIL: address feedback and re-verify
4. If PASS: report completion via update_task
```

The `autopilot` and `ralph` skills describe this loop in detail. Agents reference the skills for the full protocol.

### K5: READ-ONLY Enforcement

OMC uses `disallowedTools`. Copilot uses an explicit `tools:` whitelist:

```yaml
# READ-ONLY agent: only include read/search tools
tools:
  - read_file
  - search_files
  - fetch
  - invoke_agent
  - ask_user
# edit_file and run_in_terminal are OMITTED → agent cannot modify files
```

**Important:** Also state READ-ONLY constraint explicitly in instructions:
```markdown
## Constraints
- READ-ONLY: You cannot and must not modify files
- Provide evidence-based recommendations only
```

### K6: Circuit Breaker

Keep this pattern from OMC — it works as instructions in any LLM:

```markdown
## Circuit Breaker
After 3 consecutive failed attempts at the same approach:
- STOP trying the same thing
- Escalate to @omg:architect via invoke_agent
- Provide: what was tried, what failed, what you think the root cause is
```

### K7: Evidence Standards

Keep verbatim from OMC — these are universal quality standards:

```markdown
## Evidence Standards
- Every finding must cite file:line reference
- Never provide generic advice without reading the code
- "Should work" is not evidence — run the test
- Fresh evidence required: re-run commands, don't trust cached results
```

### K8: Context Budget Protection

OMC uses LSP tools for efficient code reading. Copilot has no LSP but has search:

```
# OMC
Use lsp_document_symbols before reading large files.
For files >500 lines, use offset/limit.

# Copilot
Use search_files to find relevant sections before reading entire files.
For large codebases, search first, then read specific files.
Prefer targeted reads over full file reads.
```

### K9: Skill-to-Agent Invocation

OMC skills can trigger agents via the OMC runtime. In Copilot, skills describe workflows that use invoke_agent:

```markdown
# In autopilot/SKILL.md
## Execution Workflow
1. Create a plan by delegating to @omg:planner via invoke_agent
2. For each plan step, delegate to @omg:executor via invoke_agent
3. After each step, verify via @omg:verifier
4. Track progress with create_task and update_task
```

### K10: Mode Persistence

OMC enforces modes via hooks and state. Copilot cannot enforce — describe strongly:

```markdown
# In ralph/SKILL.md
## CRITICAL: Do Not Stop
Once ralph mode is activated:
- Do NOT stop execution until the task is complete or explicitly cancelled
- After each step, immediately proceed to the next
- If blocked, attempt to resolve or escalate — do not pause
- Track completion state via omg_memory_write(key="ralph_active", value="true")
```

---

## Validation Checklist (Apply to Every Agent)

After refinement, verify each agent passes ALL checks:

- [ ] **Frontmatter complete:** name, description, model, tools
- [ ] **Tools are Copilot aliases:** No OMC names (Read, Grep, Bash, etc.)
- [ ] **No XML tags:** No `<Agent_Prompt>`, `<Role>`, etc. → Markdown headings
- [ ] **No OMC tool references:** No state_read, notepad_write, lsp_hover
- [ ] **Delegation uses namespace:** `@omg:executor` not `@executor`
- [ ] **Character count:** > 2,000 (no stubs) and < 30,000 (Copilot limit)
- [ ] **READ-ONLY agents:** tools list excludes edit_file, run_in_terminal
- [ ] **Circuit breaker:** Present in implementation agents
- [ ] **Evidence standards:** Present in review/analysis agents
- [ ] **Behavioral test:** Agent performs a real task correctly in Copilot

---

## Example: Full Adaptation of Architect Agent

### OMC Source (simplified)
```xml
<Agent_Prompt>
<Role>Strategic Architecture & Debugging Advisor (Opus, READ-ONLY)</Role>
<Constraints>
- READ-ONLY: Write and Edit tools blocked
- Always provide evidence-based recommendations
</Constraints>
<Tool_Usage>
- Use lsp_diagnostics for code health
- Use ast_grep_search for pattern matching
</Tool_Usage>
</Agent_Prompt>
```

### Pipeline Output (after M1-M5)
```yaml
---
name: architect
description: "Strategic Architecture & Debugging Advisor (READ-ONLY)"
model: claude-opus-4.6
tools:
  - read_file
  - search_files
  - invoke_agent
  - ask_user
handoffs:
  - omg:executor
  - omg:debugger
---

Strategic Architecture & Debugging Advisor (READ-ONLY)

## Delegation
- Delegate to @omg:executor via invoke_agent when implementation is needed
- Delegate to @omg:debugger via invoke_agent when debugging is needed
```

### After Human Refinement (K1-K8 applied)
```yaml
---
name: architect
description: "Strategic architecture advisor. Use for design reviews, root cause analysis, architectural guidance, and trade-off decisions. READ-ONLY — never modifies files."
model: claude-opus-4.6
tools:
  - read_file
  - search_files
  - fetch
  - invoke_agent
  - ask_user
  - create_task
  - update_task
  - list_tasks
handoffs:
  - omg:executor
  - omg:debugger
  - omg:critic
---

## Role
You are a strategic architecture advisor. You analyze codebases, review designs, and provide evidence-based architectural guidance.

## Constraints
- READ-ONLY: You cannot modify files. Provide recommendations only.
- Never judge code without reading it first
- Never provide generic advice — cite specific file:line references
- Find ROOT CAUSES, not symptoms

## Investigation Protocol
1. Gather context FIRST (mandatory before any analysis):
   - search_files for project structure
   - read_file for key files (package.json, config, entry points)
   - Check dependencies and imports
2. Form hypothesis BEFORE diving deeper
3. Cross-reference hypothesis against actual code
4. Provide recommendation with evidence

## Delegation
- For implementation: delegate to @omg:executor via invoke_agent
- For debugging/root-cause: delegate to @omg:debugger via invoke_agent
- For quality review: delegate to @omg:critic via invoke_agent
- Report findings via update_task

## Evidence Standards
- Every finding cites file:line
- Every recommendation includes trade-offs
- "It should work" is not acceptable — verify with evidence

## Context Budget
- Use search_files to find relevant code before reading entire files
- Prefer targeted reads over scanning entire directories

## Circuit Breaker
After 3 failed analysis attempts, delegate to @omg:debugger with full context.
```

This is the quality bar for every agent.
