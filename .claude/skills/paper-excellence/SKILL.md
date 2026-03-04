---
name: paper-excellence
description: >-
  Runs multi-agent paper review dispatching Econometrician, Debugger,
  Proofreader, and Verifier in parallel. Computes weighted aggregate score per
  scoring-protocol.md. Triggers on: "paper excellence", "comprehensive review",
  "quality check", "score the paper".
argument-hint: "[paper .tex path OR 'all' for full project review]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Paper Excellence Review

Run all review agents in parallel for a comprehensive paper quality assessment. Computes the weighted aggregate score from `scoring-protocol.md`.

**Input:** `$ARGUMENTS` — path to paper `.tex` file, or `all` for full project review.

**Paper:** !`test -f Paper/main.tex && echo "found" || echo "not found"`
**Scripts:** !`ls src/*.py src/*.do 2>/dev/null | head -5`
**Talks:** !`ls Slides/*.tex 2>/dev/null | head -3`
**Domain profile:** !`test -f .claude/rules/domain-profile.md && echo "found" || echo "not found"`
**Existing reports:** !`ls -t quality_reports/*_review.md quality_reports/*_report.md 2>/dev/null | head -5`

---

## Workflow

### Step 1: Identify Targets

- If `$ARGUMENTS` is a `.tex` file: review that file
- If `$ARGUMENTS` is `all`: review `Paper/main.tex` + all scripts in `src/`
- Also scan for `Slides/*.tex` for auxiliary scoring

### Step 2: Gather Context

Before launching agents:
1. Read `.claude/rules/domain-profile.md` for field-specific calibration
2. Read `.claude/rules/scoring-protocol.md` for weight formula
3. Read any existing strategy memos in `quality_reports/`

### Step 3: Launch Review Agents (Parallel)

Launch up to 4 agents simultaneously via Task tool:

**Agent 1: Econometrician** (subagent_type: econometrician)
```
Review [paper.tex] through all 4 phases: claim, design validity, inference, polish.
Also check scripts in src/ for code-theory alignment.
Save report to quality_reports/[file]_econometrics_review.md
```
**Weight:** Identification 25% of aggregate score.

**Agent 2: Debugger** (subagent_type: debugger)
```
Review all scripts in src/ for code quality and correctness.
Run categories 4-12 (code quality) plus categories 1-3 (strategic) if strategy memo exists.
Save report to quality_reports/[script]_code_review.md
```
**Weight:** Code 15% of aggregate score.

**Agent 3: Proofreader** (subagent_type: proofreader)
```
Review [paper.tex] for grammar, writing quality, claims-evidence alignment,
notation consistency, and compilation. 6 check categories.
Save report to quality_reports/[file]_proofread_report.md
```
**Weight:** Paper 25% of aggregate score.

**Agent 4: Verifier** (subagent_type: verifier)
```
Run standard verification (checks 1-4): LaTeX compilation, script execution,
file integrity, output freshness.
Save report to quality_reports/[file]_verification.md
```
**Weight:** Replication 5% of aggregate score.

### Step 4: Launch Talk Review (Advisory, if talks exist)

If `Slides/*.tex` files exist, launch:

**Storyteller Review** — check notation matches paper, slide count within format range.
**Discussant Review** — narrative flow, visual quality, content fidelity.

Talk scores are **advisory, non-blocking**.

### Step 5: Compute Weighted Aggregate Score

Per `scoring-protocol.md`, compute:

```
Overall = Σ (weight_k × score_k) for available components
```

| Component | Weight | Agent |
|-----------|--------|-------|
| Literature | 10% | (skip if no lit review exists) |
| Data | 10% | (skip if no data review exists) |
| Identification | 25% | Econometrician |
| Code | 15% | Debugger |
| Paper | 25% | Proofreader |
| Polish | 10% | (from Proofreader writing quality subscore) |
| Replication | 5% | Verifier |

If components are missing, renormalize weights over available components.

### Step 6: Present Results

```markdown
# Paper Excellence Report: [Title]
**Date:** [YYYY-MM-DD]
**Aggregate Score:** [XX/100] — [gate status]

## Score Breakdown
| Component | Weight | Score | Issues | Agent |
|-----------|--------|-------|--------|-------|
| Identification | 25% | XX | N | Econometrician |
| Code | 15% | XX | N | Debugger |
| Paper | 25% | XX | N | Proofreader |
| Polish | 10% | XX | N | Proofreader |
| Replication | 5% | XX | PASS/FAIL | Verifier |

## Auxiliary: Talk Scores (non-blocking)
| Talk | Score | Issues |
|------|-------|--------|

## Priority Fixes (Top 5)
1. **[CRITICAL]** [Most important — from which agent]
2. **[MAJOR]** [Second priority]
...

## Full Reports
[Links to individual report files]
```

### Step 7: Gate Enforcement

Per `quality-gates.md`:
- **Score >= 95 + all components >= 80:** "Ready for top-5 submission."
- **Score >= 90:** "Ready for submission. Minor polish recommended."
- **Score >= 80:** "Commit-ready. Address major issues before submission."
- **Score < 80:** "Blocked. Must fix critical/major issues."

---

## Principles

- **Paper score is blocking.** Must pass quality gates.
- **Talk scores are advisory.** Reported but non-blocking.
- **Parallel execution.** All agents run simultaneously.
- **Weighted aggregation.** Uses scoring-protocol.md formula, not simple average.
- **Don't double-count.** Same issue in multiple reports counts once.
- **One unified report.** User sees one priority list, not separate reports.
