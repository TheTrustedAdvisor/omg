---
name: visual-verdict
description: "Screenshot-based visual QA — compare implementation against design references"
tags:
  - qa
  - visual
  - design
---

## When to Use

- Need to compare a UI implementation against a design reference
- User provides screenshots for visual comparison
- User says "visual verdict", "compare screenshots", "does this match the design?"
- After @omg:designer implements a component

## Workflow

### 1. Collect Images

Ask user for:
- **Reference:** design mockup, Figma export, or previous version screenshot
- **Implementation:** current screenshot of the built UI

### 2. Compare

Analyze across 6 dimensions:

| Dimension | What to Check |
|-----------|--------------|
| **Layout** | Component positioning, spacing, alignment, grid conformance |
| **Typography** | Font family, size, weight, line-height, letter-spacing |
| **Color** | Background, text, accent colors, gradients, opacity |
| **Spacing** | Margins, padding, gaps between elements |
| **Interactive states** | Hover, focus, active, disabled appearances |
| **Responsive** | Does it hold at different viewport widths? |

### 3. Score

Rate each dimension:
- **MATCH** — implementation matches reference
- **MINOR** — small deviation, acceptable
- **MAJOR** — noticeable difference, should fix
- **MISSING** — element not implemented

### 4. Verdict

```markdown
## Visual Verdict

**Reference:** {description}
**Implementation:** {description}

### Score Card

| Dimension | Status | Notes |
|-----------|--------|-------|
| Layout | MATCH | Grid alignment correct |
| Typography | MINOR | Font-weight slightly lighter |
| Color | MATCH | Palette matches |
| Spacing | MAJOR | Card gap 8px, should be 16px |
| Interactive | MISSING | No hover state on buttons |
| Responsive | MATCH | Holds at 768px and 375px |

### Verdict: NEEDS WORK (1 MAJOR, 1 MISSING)

### Fix List
1. [MAJOR] Increase card gap from 8px to 16px in `.card-grid`
2. [MISSING] Add hover state: `.btn:hover { background: var(--accent-hover) }`
```

### 5. Fix Delegation

If fixes needed:
```
task(agent_type="omg:designer", model="claude-sonnet-4.6", mode="sync",
  prompt="Fix these visual issues: {fix list from verdict}")
```

Re-run visual verdict after fixes to confirm.

## Checklist

- [ ] Reference and implementation images provided
- [ ] All 6 dimensions assessed
- [ ] Each deviation categorized (MATCH/MINOR/MAJOR/MISSING)
- [ ] Fix list with specific CSS/code changes
- [ ] Verdict is clear (PASS/NEEDS WORK)
