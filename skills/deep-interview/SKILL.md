---
name: deep-interview
description: "Socratic deep interview with ambiguity scoring — crystallize vague ideas into clear specs before execution"
tags:
  - requirements
  - interview
  - socratic
---

## When to Use

- User has a vague idea and wants thorough requirements gathering before execution
- User says "deep interview", "interview me", "ask me everything", "don't assume"
- User says "socratic", "I have a vague idea", "not sure exactly what I want"
- Task is complex enough that jumping to code would waste cycles on scope discovery

## When NOT to Use

- User has a detailed, specific request with file paths or acceptance criteria — execute directly
- User wants to explore options — use plan skill
- User wants a quick fix — delegate to @omg:executor or use ralph
- User says "just do it" — respect their intent
- User already has a plan file — use ralph or autopilot with that plan

## The 3-Stage Pipeline

```
Stage 1: Deep Interview    →    Stage 2: Ralplan           →    Stage 3: Autopilot
Socratic Q&A                    Consensus planning               Execution
Ambiguity scoring               Architect + Critic review        QA + Validation
Challenge agents                ADR + alternatives               Working code
Gate: ≤20% ambiguity            Gate: Critic ACCEPT              Gate: Tests pass
Output: .omg/research/spec-*.md Output: .omg/plans/*.md          Output: working code
```

Each stage gates on a different quality dimension:
1. **Deep Interview** gates on *clarity* — does the user know what they want?
2. **Ralplan** gates on *feasibility* — is the approach architecturally sound?
3. **Autopilot** gates on *correctness* — does the code work and pass review?

## Phase 1: Initialize

1. **Parse the user's idea** from the prompt
2. **Detect brownfield vs greenfield:**
   - Explore the current directory to check if it has existing source code (@omg:explore can help)
   - If source files exist AND user's idea references modifying something: **brownfield**
   - Otherwise: **greenfield**
3. **For brownfield:** map relevant codebase areas before asking the user (@omg:explore can help)
4. **Initialize tracking:** create `.omg/research/interview-{slug}-state.json`:
   ```json
   {
     "interview_id": "<slug>",
     "type": "greenfield|brownfield",
     "initial_idea": "<user input>",
     "rounds": [],
     "current_ambiguity": 1.0,
     "threshold": 0.2
   }
   ```
5. **Announce:** "Starting deep interview. I'll ask targeted questions to understand your idea. After each answer, I'll show your clarity score. We proceed once ambiguity drops below 20%."

## Phase 2: Interview Loop

Repeat until `ambiguity ≤ threshold` OR user exits early:

### Step 2a: Generate Next Question

- Identify the dimension with the LOWEST clarity score
- State why this dimension is the bottleneck before asking
- Questions should expose ASSUMPTIONS, not gather feature lists
- For brownfield: cite the repo evidence that triggered the question

**Question styles by dimension:**

| Dimension | Question Style | Example |
|-----------|---------------|---------|
| Goal Clarity | "What exactly happens when...?" | "When you say 'manage tasks', what action does a user take first?" |
| Constraint Clarity | "What are the boundaries?" | "Should this work offline, or is internet assumed?" |
| Success Criteria | "How do we know it works?" | "What would make you say 'yes, that's it'?" |
| Context (brownfield) | "How does this fit?" | "I found JWT auth in `src/auth/`. Should this extend or diverge?" |

### Step 2b: Ask ONE Question

Use `ask_user` with the question. Present with ambiguity context:

```
Round {n} | Targeting: {weakest_dimension} | Ambiguity: {score}%

{question}
```

**NEVER batch multiple questions.** One question per round.

### Step 2c: Score Ambiguity

After the answer, score clarity across all dimensions (0.0 to 1.0):

1. **Goal Clarity:** Is the primary objective unambiguous?
2. **Constraint Clarity:** Are boundaries and non-goals clear?
3. **Success Criteria Clarity:** Could you write a test that verifies success?
4. **Context Clarity (brownfield only):** Do we understand the existing system?

**Calculate ambiguity:**
- Greenfield: `ambiguity = 1 - (goal × 0.40 + constraints × 0.30 + criteria × 0.30)`
- Brownfield: `ambiguity = 1 - (goal × 0.35 + constraints × 0.25 + criteria × 0.25 + context × 0.15)`

### Step 2d: Report Progress

```
Round {n} complete.

| Dimension | Score | Gap |
|-----------|-------|-----|
| Goal | {s} | {gap or "Clear"} |
| Constraints | {s} | {gap or "Clear"} |
| Success Criteria | {s} | {gap or "Clear"} |
| Context (brownfield) | {s} | {gap or "Clear"} |
| **Ambiguity** | **{score}%** | |

Next target: {weakest_dimension}
```

### Step 2e: Update State

Append round to `.omg/research/interview-{slug}-state.json` via `edit`.

### Step 2f: Check Limits

- **Round 3+:** Allow early exit ("enough", "let's go", "build it")
- **Round 10:** Soft warning: "10 rounds. Current ambiguity: {score}%. Continue?"
- **Round 20:** Hard cap: proceed with current clarity

## Phase 3: Challenge Agents

At specific thresholds, shift the questioning perspective (used ONCE each):

### Round 4+: Contrarian Mode
> Challenge the core assumption. "What if the opposite were true?" or "What if this constraint doesn't actually exist?"

### Round 6+: Simplifier Mode
> Probe whether complexity can be removed. "What's the simplest version that would still be valuable?"

### Round 8+: Ontologist Mode (if ambiguity still > 0.3)
> Ask "What IS this, really?" — find the core entity among the noise.

## Phase 4: Crystallize Spec

When ambiguity ≤ threshold (or hard cap / early exit):

1. **Generate specification** from the full interview transcript
2. **Write to file:** `.omg/research/spec-{slug}.md`
3. **Index:** `store_memory` with key `omg:active-spec`

**Spec structure:**

```markdown
# Deep Interview Spec: {title}

## Metadata
- Rounds: {count}
- Final Ambiguity: {score}%
- Type: greenfield | brownfield

## Goal
{crystal-clear goal statement}

## Constraints
- {constraint 1}

## Non-Goals
- {explicitly excluded scope}

## Acceptance Criteria
- [ ] {testable criterion 1}
- [ ] {testable criterion 2}

## Assumptions Exposed & Resolved
| Assumption | Challenge | Resolution |
|------------|-----------|------------|

## Technical Context
{brownfield: codebase findings | greenfield: technology choices}

## Key Entities
| Entity | Type | Relationships |
|--------|------|---------------|
```

## Phase 5: Execution Bridge

Present execution options via `ask_user`:

**"Your spec is ready (ambiguity: {score}%). How would you like to proceed?"**

1. **Ralplan → Autopilot (Recommended)** — 3-stage: consensus-refine, then execute. Maximum quality.
2. **Autopilot (skip consensus)** — Full pipeline, faster but without consensus.
3. **Ralph** — Persistence loop with verification.
4. **Team** — Parallel agents for large specs.
5. **Refine further** — Continue interviewing.

**IMPORTANT:** Invoke the chosen skill. Do NOT implement directly.

## Spec Persistence

1. Save spec to `.omg/research/spec-{slug}.md`
2. Index via `store_memory` with key `omg:active-spec` and value `{ "path": "...", "title": "...", "ambiguity": "{score}%", "created": "YYYY-MM-DD" }`
3. Downstream skills (plan, autopilot, ralph, team) check `store_memory` for `omg:active-spec`

## Tool Usage

- Use `ask_user` for each interview question (one at a time)
- Explore the codebase (@omg:explore can help) for brownfield codebase exploration — run BEFORE asking user
- Use `edit`/`create` to save state and spec to `.omg/research/`
- Use `store_memory` to index the spec for downstream consumption

## Examples

**Good — Targeting weakest dimension:**
```
Scores: Goal=0.9, Constraints=0.4, Criteria=0.7
→ Targets Constraints (lowest at 0.4):
"You mentioned this should 'work on mobile'. Does that mean a native app,
a responsive web app, or a PWA?"
```

**Good — Codebase facts before asking:**
```
[spawns omg:explore: "find auth implementation"]
[receives: "Auth in src/auth/ using JWT + passport.js"]

"I found JWT auth in src/auth/. Should this new feature extend it or diverge?"
```

**Good — Contrarian mode:**
```
Round 5 | Contrarian Mode | Ambiguity: 42%
"You said 10K concurrent users. What if only 100? Would architecture change,
or is 10K an assumption, not a requirement?"
```

**Bad:** "What do you want? What framework? What database?" — Batched questions, asked codebase facts.

## Checklist

- [ ] One question per round (never batched)
- [ ] Weakest dimension targeted each round
- [ ] Codebase facts via @omg:explore, not asked to user
- [ ] Ambiguity score shown after every round
- [ ] Spec saved to `.omg/research/spec-{slug}.md`
- [ ] Spec indexed via `store_memory` key `omg:active-spec`
- [ ] Execution bridged via skill, not direct implementation

## Trigger Keywords

deep interview, interview me, socratic

## Quality Contract

- Ambiguity scoring, spec persisted when clarity sufficient
