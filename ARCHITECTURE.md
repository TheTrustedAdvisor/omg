# omg Plugin Architecture

Comprehensive architecture documentation for the omg Copilot CLI Plugin.
Covers the plugin structure, agent orchestration model, tool access architecture,
delegation patterns, and the relationship to the omg build pipeline.

---

## 1. High-Level Overview

The omg plugin delivers OMC's multi-agent orchestration to GitHub Copilot CLI.
The pipeline compiles OMC source material into Copilot-native format.

```mermaid
graph LR
    subgraph Sources
        OMC[OMC Repo<br/>19 agents, 36 skills]
        MS[Microsoft Skills<br/>6 repos]
        AC[awesome-copilot<br/>Community index]
    end

    subgraph Pipeline["omg Pipeline (Build Tool)"]
        IMP[Importers] --> IR[Intermediate<br/>Representation]
        IR --> MER[Merge]
        MER --> MAT[Match]
        MAT --> ENH[Enhance]
        ENH --> VAL[Validate]
        VAL --> EXP[Exporters]
    end

    subgraph Output["omg Plugin (Product)"]
        PJ[plugin.json]
        AG[19 agents/*.agent.md]
        SK[28 skills/*/SKILL.md]
        HK[hooks.json]
        LM[LIMITATIONS.md]
    end

    OMC --> IMP
    MS --> IMP
    AC --> IMP
    EXP --> PJ
    EXP --> AG
    EXP --> SK
    EXP --> HK

    subgraph User["User's Copilot"]
        INST[copilot plugin install ./plugin]
        INST --> USE[19 agents + 28 skills active]
    end

    Output --> INST
```

## 2. Plugin Structure

```
plugin/
├── plugin.json                          ← Manifest: name, version, paths
├── ARCHITECTURE.md                      ← This file
├── LIMITATIONS.md                       ← Known gaps + "improve when" triggers
├── hooks.json                           ← Lifecycle hooks (currently empty)
├── agents/                              ← 19 specialized agents
│   ├── executor.agent.md                ← sonnet, FULL tools
│   ├── debugger.agent.md                ← sonnet, FULL tools
│   ├── verifier.agent.md                ← sonnet, verification
│   ├── architect.agent.md               ← opus, READ-ONLY
│   ├── critic.agent.md                  ← opus, READ-ONLY
│   ├── planner.agent.md                 ← opus, planning
│   ├── analyst.agent.md                 ← opus, READ-ONLY
│   ├── explore.agent.md                 ← haiku, READ-ONLY, fast
│   ├── code-reviewer.agent.md           ← opus, READ-ONLY
│   ├── security-reviewer.agent.md       ← opus, READ-ONLY
│   ├── writer.agent.md                  ← haiku, docs
│   ├── git-master.agent.md              ← sonnet, git ops
│   ├── test-engineer.agent.md           ← sonnet, TDD
│   ├── designer.agent.md               ← sonnet, UI/UX
│   ├── document-specialist.agent.md     ← sonnet, external docs
│   ├── code-simplifier.agent.md         ← opus, refactoring
│   ├── qa-tester.agent.md               ← sonnet, interactive testing
│   ├── scientist.agent.md               ← sonnet, data analysis
│   └── tracer.agent.md                  ← sonnet, causal tracing
└── skills/                              ← 28 workflow skills
    ├── autopilot/SKILL.md               ← Full autonomous lifecycle
    ├── ralph/SKILL.md                   ← Persistent execution + verification
    ├── team/SKILL.md                    ← Parallel multi-agent coordination
    ├── ultrawork/SKILL.md               ← Parallel execution engine
    ├── plan/SKILL.md                    ← Strategic planning + consensus
    ├── ralplan/SKILL.md                 ← Consensus planning alias
    ├── ultraqa/SKILL.md                 ← QA cycling until green
    ├── deep-interview/SKILL.md          ← Socratic requirements interview
    ├── deep-dive/SKILL.md               ← Trace → interview pipeline
    ├── deepinit/SKILL.md                ← Codebase documentation
    ├── sciomc/SKILL.md                  ← Parallel research
    ├── external-context/SKILL.md        ← External doc lookup
    ├── debug/SKILL.md                   ← Structured debugging
    ├── verify/SKILL.md                  ← Evidence-based verification
    ├── trace/SKILL.md                   ← Causal tracing
    ├── ai-slop-cleaner/SKILL.md         ← Clean AI-generated code
    ├── visual-verdict/SKILL.md          ← Screenshot QA
    ├── learner/SKILL.md                 ← Extract reusable skill
    ├── skillify/SKILL.md                ← Convert workflow to SKILL.md
    ├── self-improve/SKILL.md            ← Prompt optimization
    ├── cancel/SKILL.md                  ← Stop active mode
    ├── release/SKILL.md                 ← Release automation
    ├── remember/SKILL.md                ← Persistent notes
    ├── writer-memory/SKILL.md           ← Story element tracking
    ├── project-session-manager/SKILL.md ← Branch/session management
    ├── ask/SKILL.md                     ← Multi-AI routing
    ├── ccg/SKILL.md                     ← Tri-model orchestration
    └── configure-notifications/SKILL.md ← Alert setup
```

## 3. Copilot CLI Tool Access Architecture

This is the most critical architectural finding. Plugin agents do NOT have
standalone tool access. Understanding this model is essential.

```mermaid
graph TB
    subgraph TopLevel["Top-Level Session (--agent omg:X)"]
        TL_TOOLS["Tools: skill, report_intent ONLY"]
        TL_NOTE["⚠ No bash, view, edit, grep, glob"]
    end

    subgraph DefaultAgent["Default Agent (no --agent flag)"]
        DA_TOOLS["Tools: bash, view, edit, create,<br/>grep, glob, task, web_fetch,<br/>store_memory, skill, read_agent,<br/>list_agents, GitHub MCP tools"]
    end

    subgraph SubAgent["Subagent (spawned via task tool)"]
        SA_TOOLS["Tools: bash, view, edit, create,<br/>grep, glob, web_fetch<br/>(full CLI tool access)"]
    end

    DefaultAgent -->|"task(agent_type='omg:executor')"| SubAgent
    DefaultAgent -->|"read_agent('omg:architect')"| ReadPrompt[Reads agent prompt<br/>as instructions]

    style TopLevel fill:#fee,stroke:#c00
    style DefaultAgent fill:#efe,stroke:#0a0
    style SubAgent fill:#efe,stroke:#0a0
```

### Key Rules

| Access Path | Tools Available | Use Case |
|------------|----------------|----------|
| `copilot --agent omg:X` | `skill` + `report_intent` only | Advisory conversation, no file ops |
| `copilot` (default agent) | **All tools** (40+) | Orchestration hub, reads plugin agents |
| `task(agent_type="omg:X")` | **All CLI tools** | Real subagent with full capabilities |
| `task(agent_type="general-purpose")` | **All CLI tools** | Generic subagent (no plugin prompt) |
| `task(agent_type="explore")` | Read-only tools | Fast research subagent |

### Correct Usage Pattern

```
# WRONG: Plugin agent as top-level (no tools)
copilot --agent omg:executor -p "fix the bug"

# RIGHT: Default agent spawns plugin agent as subagent
copilot -p "Use the omg:executor agent to fix the bug in auth.ts"
# → Default agent calls: task(agent_type="omg:executor", prompt="fix auth.ts bug")
# → Subagent has full tools: bash, view, edit, grep, glob
```

## 4. Agent Delegation Model

Agents delegate to each other via the `task` tool. The `task` tool supports
model selection, background execution, and parallel dispatch.

```mermaid
sequenceDiagram
    participant User
    participant Default as Default Agent<br/>(all tools)
    participant Planner as omg:planner<br/>(via task)
    participant Explore as omg:explore<br/>(via task)
    participant Analyst as omg:analyst<br/>(via task)
    participant Architect as omg:architect<br/>(via task)
    participant Critic as omg:critic<br/>(via task)
    participant Executor as omg:executor<br/>(via task)

    User->>Default: "plan authentication feature"
    Default->>Planner: task(agent_type="omg:planner",<br/>model="claude-opus-4.6")

    Note over Planner: Interview phase
    Planner->>Explore: task(agent_type="omg:explore",<br/>mode="background",<br/>model="claude-haiku-4.5")
    Explore-->>Planner: Auth is in src/auth/ using JWT

    Planner->>User: "Should auth be OAuth2 or session-based?"
    User->>Planner: "OAuth2"

    Note over Planner: Consensus mode
    Planner->>Analyst: task(model="claude-opus-4.6")
    Analyst-->>Planner: Gap analysis: missing token refresh spec

    Planner->>Architect: task(model="claude-opus-4.6")
    Architect-->>Planner: Architecture review: APPROVE with notes

    Planner->>Critic: task(model="claude-opus-4.6")
    Critic-->>Planner: ACCEPT-WITH-RESERVATIONS

    Note over Planner: Plan approved
    Planner->>Executor: task(agent_type="omg:executor",<br/>mode="background")
    Executor-->>Planner: Implementation complete
```

### task() Tool Schema

```jsonc
{
  "name": "string",           // Short identifier (used in logs)
  "prompt": "string",         // Full task context (agents are stateless)
  "agent_type": "string",     // "omg:executor", "explore", "general-purpose"
  "description": "string",    // 3-5 word label for UI
  "mode": "background|sync",  // background = non-blocking, sync = wait
  "model": "string"           // Optional model override
}
```

### Model Routing via task()

The `model:` frontmatter field is ignored for `--agent` top-level sessions,
but the `task` tool's `model` parameter works for subagent spawning:

```mermaid
graph LR
    subgraph ModelTiers["Model Routing"]
        OPUS["claude-opus-4.6<br/>Deep reasoning"]
        SONNET["claude-sonnet-4.6<br/>Balanced"]
        HAIKU["claude-haiku-4.5<br/>Fast/cheap"]
    end

    subgraph OpusAgents["Opus Agents"]
        A1[architect]
        A2[critic]
        A3[analyst]
        A4[code-reviewer]
        A5[security-reviewer]
        A6[code-simplifier]
    end

    subgraph SonnetAgents["Sonnet Agents"]
        S1[executor]
        S2[debugger]
        S3[verifier]
        S4[test-engineer]
        S5[designer]
        S6[git-master]
        S7[qa-tester]
        S8[scientist]
        S9[tracer]
        S10[document-specialist]
    end

    subgraph HaikuAgents["Haiku Agents"]
        H1[explore]
        H2[writer]
    end

    OPUS --- OpusAgents
    SONNET --- SonnetAgents
    HAIKU --- HaikuAgents
```

## 5. Skill Orchestration Patterns

Skills are workflow templates that guide multi-agent orchestration.
They are advisory documents — the executing agent reads the skill
instructions and follows the workflow using `task` for delegation.

### Execution Mode Hierarchy

```mermaid
graph TB
    AP[autopilot<br/>Full lifecycle] --> RP[ralph<br/>Persistence + verification]
    RP --> UW[ultrawork<br/>Parallel execution]
    UW --> EX[task → omg:executor<br/>Single agent work]

    AP -->|Phase 0| AN[analyst + architect<br/>Spec expansion]
    AP -->|Phase 1| PL[planner + critic<br/>Plan + validate]
    AP -->|Phase 3| UQ[ultraqa<br/>QA cycling]
    AP -->|Phase 4| VAL[architect + security-reviewer<br/>+ code-reviewer<br/>Multi-perspective validation]

    style AP fill:#f9f,stroke:#333
    style RP fill:#ff9,stroke:#333
    style UW fill:#9ff,stroke:#333
```

### Autopilot Full Pipeline

```mermaid
graph LR
    subgraph Phase0["Phase 0: Expansion"]
        P0A[analyst<br/>Requirements] --> P0B[architect<br/>Technical spec]
    end

    subgraph Phase1["Phase 1: Planning"]
        P1A[architect<br/>Create plan] --> P1B[critic<br/>Validate plan]
    end

    subgraph Phase2["Phase 2: Execution"]
        P2A[executor × N<br/>Parallel via task(background) × N]
    end

    subgraph Phase3["Phase 3: QA"]
        P3A[bash: test/build/lint] -->|fail| P3B[debugger: diagnose]
        P3B --> P3C[executor: fix]
        P3C -->|retry| P3A
        P3A -->|pass| P3D[✓ Green]
    end

    subgraph Phase4["Phase 4: Validation"]
        P4A[architect<br/>Completeness]
        P4B[security-reviewer<br/>Vulnerabilities]
        P4C[code-reviewer<br/>Quality]
    end

    Phase0 --> Phase1 --> Phase2 --> Phase3 --> Phase4

    style Phase0 fill:#e8f4fd
    style Phase1 fill:#e8f4fd
    style Phase2 fill:#e8fde8
    style Phase3 fill:#fde8e8
    style Phase4 fill:#f4e8fd
```

### Ralph Persistence Loop

```mermaid
graph TB
    START[Start: Break task into stories] --> PICK[Pick next incomplete story]
    PICK --> IMPL[executor: Implement story]
    IMPL --> VERIFY{All acceptance<br/>criteria met?}
    VERIFY -->|No| IMPL
    VERIFY -->|Yes| MARK[Mark story complete]
    MARK --> CHECK{All stories<br/>done?}
    CHECK -->|No| PICK
    CHECK -->|Yes| REVIEW[architect: Verify against criteria]
    REVIEW --> APPROVED{Approved?}
    APPROVED -->|No| FIX[Fix issues] --> REVIEW
    APPROVED -->|Yes| DONE[✓ Complete]

    style DONE fill:#afa
```

### Team Parallel Execution

```mermaid
graph TB
    LEAD[Team Lead<br/>Decomposes task] --> T1[task: Subtask 1<br/>executor, background]
    LEAD --> T2[task: Subtask 2<br/>executor, background]
    LEAD --> T3[task: Subtask 3<br/>executor, background]
    LEAD --> T4[task: Subtask 4<br/>debugger, background]

    T1 --> COLLECT[Collect results]
    T2 --> COLLECT
    T3 --> COLLECT
    T4 --> COLLECT

    COLLECT --> VERIFY[verifier: Check all work]
    VERIFY --> DONE[✓ Complete]

    style LEAD fill:#ff9
    style T1 fill:#9ff
    style T2 fill:#9ff
    style T3 fill:#9ff
    style T4 fill:#9ff
```

### Consensus Planning (Ralplan)

```mermaid
graph TB
    START[User request] --> PLAN[planner: Create plan<br/>+ RALPLAN-DR summary]
    PLAN --> ARCH[architect: Review<br/>Antithesis + trade-offs]
    ARCH --> CRITIC[critic: Evaluate<br/>Quality gate]
    CRITIC --> DECISION{Verdict?}
    DECISION -->|REJECT/REVISE| PLAN
    DECISION -->|ACCEPT| ADR[Add ADR section]
    ADR --> EXEC{Execute via?}
    EXEC -->|team| TEAM["task(background) × N parallel dispatch"]
    EXEC -->|ralph| RALPH["Sequential + verified"]

    style DECISION fill:#ff9
    style ADR fill:#afa
```

## 6. Copilot-Native Tool Mapping

All agent prompts use Copilot-native tool names:

| Copilot Tool | Purpose | OMC Equivalent |
|-------------|---------|----------------|
| `bash` | Shell commands, builds, tests | Bash |
| `view` | Read file contents | Read |
| `edit` | Modify existing files | Edit |
| `create` | Create new files | Write |
| `grep` | Search file contents by pattern | Grep |
| `glob` | Find files by name pattern | Glob |
| `task` | Spawn subagents with full tools | Agent (Task) |
| `web_fetch` | Fetch URL content | WebFetch |
| `store_memory` | Persist data across sessions | state_write |
| `read_agent` | Read agent instructions | — |
| `list_agents` | List available agents | — |
| `skill` | Invoke a named skill | Skill |
| `ask_user` | Ask user with options | AskUserQuestion |
| `task(mode="background") × N` | Parallel multi-agent dispatch | tmux orchestration |
| `/delegate` | Cloud handoff (async) | — |

## 7. OMC → Copilot Translation Summary

The pipeline translates OMC's Claude Code prompts into Copilot-native format:

```mermaid
graph LR
    subgraph OMC["OMC Source"]
        O1["XML tags<br/>&lt;Agent_Prompt&gt;&lt;Role&gt;"]
        O2["OMC tools<br/>Read, Grep, Bash, Edit"]
        O3["OMC models<br/>opus, sonnet, haiku"]
        O4["OMC delegation<br/>Task(subagent_type=...)"]
        O5["OMC state<br/>state_read/write, notepad"]
        O6["OMC hooks<br/>27 lifecycle events"]
    end

    subgraph Copilot["Copilot Plugin"]
        C1["Markdown sections<br/>## Role, ## Constraints"]
        C2["Copilot tools<br/>view, grep, bash, edit"]
        C3["Model hints<br/>in task() delegation"]
        C4["task() tool<br/>with agent_type + model"]
        C5["store_memory<br/>(partial coverage)"]
        C6["hooks.json<br/>5 events (clean drop)"]
    end

    O1 -->|"XML → Markdown"| C1
    O2 -->|"Tool mapping"| C2
    O3 -->|"task(model=...)"| C3
    O4 -->|"Delegation"| C4
    O5 -->|"Partial"| C5
    O6 -->|"27 → 5"| C6
```

### What Was Dropped (Copilot-Native-First Leitsatz)

| OMC Feature | Status | Reason |
|-------------|--------|--------|
| LSP tools (hover, goto_definition, find_references, diagnostics) | Dropped | No Copilot equivalent — agents use grep/glob/view |
| AST tools (ast_grep_search, ast_grep_replace) | Dropped | No Copilot equivalent |
| python_repl | Dropped | Agents use `bash` + python instead |
| Session search | Dropped | No cross-session query in Copilot |
| Hook enforcement (27 events) | Reduced | 5 Copilot CLI events; untranslatable hooks documented |
| Notepad (priority/working/manual) | Partial | `store_memory` covers basic persistence |
| 8 OMC-internal skills | Dropped | Not portable (omc-setup, omc-doctor, hud, etc.) |

## 8. Parity Matrix

| OMC Feature | omg Implementation | Fidelity |
|-------------|-------------------|----------|
| 19 specialized agents | .agent.md files with Copilot-native tools | **Full** |
| 28 portable skills | SKILL.md files with auto-discovery | **Full** |
| Model routing | `task(model=...)` per subagent | **Full** (via delegation) |
| Agent delegation | `task(agent_type="omg:X")` | **Full** |
| Parallel dispatch | `task(mode="background") × N` | **Full** |
| Team orchestration | team skill + task tool | **Full** |
| Verification loops | ralph/autopilot skills + verifier agent | **Good** (advisory) |
| Consensus planning | ralplan skill (planner→architect→critic) | **Good** |
| Cross-session memory | `store_memory` tool | **Good** |
| Hook-enforced persistence | Not available — skills are advisory | **Partial** |
| LSP/AST tools | grep/glob/view as fallback | **Degraded** |
| Parallel agent dispatch | `task(mode="background") × N` (confirmed parallel: 3s not 9s) | **Good** |
| Session search | Not available | **None** |

**Overall: ~85% functional parity.** The 15% gap is: hook enforcement, LSP/AST tools, session search.

## 9. Build Pipeline → Plugin Relationship

```mermaid
graph TB
    subgraph Build["omg Build Pipeline (this repo)"]
        SRC[src/] --> PIPE[Pipeline: import → merge → match → enhance → validate → export]
        TEST[test/] --> CI[CI: lint + typecheck + test]
        FIX[test/fixtures/] --> PIPE
    end

    subgraph Plugin["omg Plugin (plugin/)"]
        PA[agents/*.agent.md]
        PS[skills/*/SKILL.md]
        PM[plugin.json]
    end

    subgraph Monitor["CI Auto-Sync (Phase 4)"]
        MON[monitor-omc-releases.yml<br/>Checks OMC every 6h]
        MON -->|New OMC version| PIPE
        PIPE -->|Regenerate| Plugin
        Plugin -->|PR with diff| REVIEW[Human review]
    end

    PIPE -->|"omg translate"| Plugin

    style Build fill:#e8f4fd
    style Plugin fill:#e8fde8
    style Monitor fill:#fde8e8
```

The pipeline is the **compiler**. The plugin is the **binary**. Users get the binary.
The pipeline + CI keeps the plugin in sync with OMC upstream automatically.
