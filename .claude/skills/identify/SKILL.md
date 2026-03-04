---
name: identify
description: >-
  Designs identification strategy by dispatching the Strategist agent (proposer)
  and Econometrician agent (critic). Produces strategy memo, pseudo-code,
  robustness plan, and falsification tests. Triggers on: "identify the effect",
  "design the strategy", "write the strategy memo", "what's the identification".
argument-hint: "[research question or research-spec file path]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Identify

Design an identification strategy by dispatching the **Strategist** (proposer) and **Econometrician** (critic).

**Input:** `$ARGUMENTS` — research question, description of available variation, or path to research spec.

**Research spec:** !`ls -t quality_reports/specs/*.md 2>/dev/null | head -1`
**Literature review:** !`ls -t quality_reports/*lit_review*.md 2>/dev/null | head -1`
**Data assessment:** !`ls -t quality_reports/*data_exploration*.md 2>/dev/null | head -1`
**Domain profile:** !`test -f .claude/rules/domain-profile.md && echo "found" || echo "not found"`

---

## Workflow

### Step 1: Context Gathering

1. Read research spec if it exists in `quality_reports/specs/`
2. Read literature review if it exists in `quality_reports/`
3. Read data assessment if it exists in `quality_reports/`
4. Read `.claude/rules/domain-profile.md` for common identification strategies in the field

### Step 2: Launch Strategist Agent

Delegate to the `strategist` agent via Task tool:

```
Prompt: Design identification strategy for "[research question]".
Available data: [from context gathering].
Available variation: [from research spec or user description].

Produce:
  1. Strategy memo — design choice, estimand, assumptions, comparison group
  2. Pseudo-code — implementation sketch (what the Python/Stata code will do)
  3. Robustness plan — ordered list of robustness checks with rationale
  4. Falsification tests — what SHOULD NOT show effects (and why)
  5. Referee objection anticipation — top 5 objections with pre-emptive responses

If multiple credible strategies exist, present the top 2-3 with trade-offs.
Save strategy memo to quality_reports/strategy_memo_[topic].md
```

### Step 3: Launch Econometrician Agent (Strategy Review Mode)

After Strategist returns, delegate to the `econometrician` agent:

```
Prompt: Review the strategy memo at quality_reports/strategy_memo_[topic].md.
Mode: Strategy review (Phase 2 focus — core design validity).
Check:
  - Are the identifying assumptions stated and defensible?
  - Is the estimand clearly defined (ATT/ATE/LATE)?
  - Are the biggest threats acknowledged?
  - Does the robustness plan address the right concerns?
  - Are the falsification tests well-chosen?
Score the strategy. Flag CRITICAL issues that must be resolved before coding.
Save review to quality_reports/strategy_memo_[topic]_econometrics_review.md
```

### Step 4: Iterate if Needed

If Econometrician finds CRITICAL issues:
1. Present issues to user
2. Re-dispatch Strategist with specific fixes (max 3 rounds per three-strikes.md)
3. Re-run Econometrician to verify

If unresolved after 3 rounds: escalate to user with both perspectives.

### Step 5: Present Results

Present the strategy summary with: design type, estimand, key assumptions, Econometrician assessment and score, ordered robustness plan, and next steps (e.g., implement via `/data-analysis`).

---

## Principles

- **Strategist proposes, Econometrician critiques.** The adversarial pairing catches design flaws early.
- **Strategy memo is the contract.** Once approved, the Coder implements it faithfully.
- **Catch problems before coding.** A flawed strategy caught now saves weeks of wasted analysis.
- **Multiple strategies are OK.** Present trade-offs and let the user choose.
- **The user decides.** If Strategist and Econometrician disagree after 3 rounds, the user resolves it.
