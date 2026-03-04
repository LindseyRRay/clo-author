---
name: data-analysis
description: >-
  End-to-end empirical analysis: implement regressions, analyze data, run
  estimations, build analysis scripts, produce tables and figures. Dispatches
  Coder and Debugger agents. Defaults to Python; uses Stata when specified.
  Triggers on: "run the analysis", "analyze the data", "implement the
  regressions", "estimate the model", "run DiD", "run event study".
argument-hint: "[dataset path or description of analysis goal]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Data Analysis Workflow

Run an end-to-end data analysis by dispatching the **Coder** (implementer) and **Debugger** (code critic).

**Input:** `$ARGUMENTS` — a dataset path or description of the analysis goal. Data paths should reference `config.py` (e.g., `config.RAW_DATA_PATH / "source/file.csv"`).

**Existing scripts:** !`find src/ -name "*.py" -o -name "*.do" 2>/dev/null | head -10`
**Config:** !`find . -maxdepth 2 -name "config.py" -o -name "figure_settings.py" 2>/dev/null`
**Strategy memo:** !`ls -t quality_reports/ 2>/dev/null | grep -m1 -E 'strategy|memo'`
**Existing outputs:** !`find Output/ -name "*.tex" -o -name "*.pdf" -o -name "*.png" 2>/dev/null | head -10`

---

## Pre-Flight Check

**Arguments received:** `$ARGUMENTS`

If `$ARGUMENTS` is empty:
1. Check `quality_reports/plans/` for the most recent approved plan
2. Check `quality_reports/specs/` for the most recent spec
3. If a plan or spec exists, use it as the analysis goal
4. If neither exists, STOP and ask: "What dataset or analysis goal should I work from? Provide a file path, a description, or point me to an existing plan."

If `config.py` is MISSING:
1. Create `config.py` from the template at `~/.claude/templates/config.py`
2. STOP and ask the user to fill in `DATA_PATH` before proceeding

---

## Language Selection

Default to **Python** unless any of the following are true:
- The strategy memo specifies Stata commands (e.g., `reghdfe`, `xtabond2`, `ivreg2`)
- Existing scripts in `src/` are predominantly `.do` files
- `$ARGUMENTS` explicitly mentions Stata

If using Stata: follow `.do` file conventions, output `.tex` via `esttab`, intermediate data as `.dta`. Use the Stata skill (`~/.claude/skills/stata/SKILL.md`) for execution.

---

## Workflow

### Step 1: Launch Coder Agent

Delegate to the `coder` agent via Task tool. Include all necessary context in the prompt:

```
Prompt: Implement analysis for "[goal]" using data at "[path]".

Context to read first:
  - config.py for DATA_PATH and output directory conventions
  - figure_settings.py for plot styling (if it exists)
  - .claude/rules/domain-profile.md for field conventions
  - Any strategy memo in quality_reports/ (cross-reference code against stated design)
  - Existing scripts in src/ for project patterns

Follow 4 stages:
  Stage 0: Data cleaning (if raw data provided)
  Stage 1: Main specification (from strategy memo or user description)
  Stage 2: Robustness checks
  Stage 3: Publication-ready output

Save scripts to src/.
Use config.py for all data paths (DATA_PATH, FIGURES_DIR, TABLES_DIR).
Use figure_settings.py for plot styling if available; skip gracefully if missing.
Use the Python template at .claude/skills/data-analysis/references/python-template.py as a starting point.
```

### Step 2: Run Quality Pipeline

After the Coder returns scripts, run the Code Quality Pipeline defined in `~/.claude/CLAUDE.md` (ruff, mypy, pytest, then code-review skill for changes >5 lines).

### Step 3: Launch Debugger Agent (Strategy Critic)

Delegate to the `debugger` agent for strategy-level review:

```
Prompt: Review the scripts the Coder produced in src/.
Focus on strategic alignment:
  1. Code-strategy alignment — does the code implement the stated identification strategy?
  2. Sanity checks — are summary stats, balance tests, and diagnostic plots present?
  3. Robustness sufficiency — enough alternative specifications?
If strategy memo exists, cross-reference code against stated design.
Save report to quality_reports/YYYY-MM-DD_[script]_code_review.md
```

### Step 4: Fix Issues

If Debugger finds Critical or Major issues:
1. Re-dispatch Coder with specific fixes (max 3 rounds per `three-strikes.md`)
2. Re-run quality pipeline and Debugger to verify fixes

### Step 5: Present Results

Report the following:
- **Scripts created/modified:** paths and descriptions
- **Tables:** paths to `.tex` files
- **Figures:** paths to `.pdf`/`.png` files
- **Debugger score:** XX/100
- **Issues fixed:** summary of what was flagged and resolved
- **Known limitations:** missing data, unimplemented specifications from the strategy memo, or Debugger issues deferred for later
- **Next suggested step:** e.g., "Run `/proofread` to check that tables match manuscript"

---

## Principles

- **Reproduce, don't guess.** If the user specifies a regression, run exactly that.
- **Show your work.** Print summary statistics before jumping to regressions.
- **Strategy alignment.** If a strategy memo exists, the code MUST implement it faithfully.
- **Debugger review is mandatory.** After Coder returns, always dispatch Debugger before presenting results.
- **Persist intermediate DataFrames.** Save every cleaned or transformed DataFrame to parquet before the next stage.
- **Publication-ready output.** Tables (booktabs LaTeX) and figures should be directly includable in the paper.
