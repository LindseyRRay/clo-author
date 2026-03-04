---
name: create-talk
description: >-
  Generates Beamer presentations by dispatching the Storyteller agent (creator)
  and Discussant agent (critic). Supports 4 formats — job market, seminar,
  short, lightning. Derives all content from the paper. Triggers on: "create
  talk", "make slides", "build presentation", "job market talk".
argument-hint: "[format: job-market | seminar | short | lightning] [paper path (optional)]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Create Talk

Generate a Beamer presentation by dispatching the **Storyteller** (creator) and **Discussant** (critic).

**Input:** `$ARGUMENTS` — format name, optionally followed by paper path.

**Paper:** !`test -f Paper/main.tex && echo "found" || echo "not found"`
**Existing talks:** !`ls Slides/*.tex 2>/dev/null | head -5`
**Preamble:** !`test -f Preambles/header.tex && echo "found" || echo "not found"`

---

## Workflow

### Step 1: Parse Arguments

- **Format** (required): `job-market` | `seminar` | `short` | `lightning`
- **Paper path** (optional): defaults to `Paper/main.tex`
- If no format specified, ask the user.

### Format Constraints

| Format | Slides | Duration | Content Scope |
|--------|--------|----------|---------------|
| Job market | 40-50 | 45-60 min | Full story, all results, mechanism, robustness |
| Seminar | 25-35 | 30-45 min | Motivation, main result, 2 robustness checks |
| Short | 10-15 | 15 min | Question, method, key result, implication |
| Lightning | 3-5 | 5 min | Hook, one result, so-what |

### Step 2: Gather Context

Before dispatching the Storyteller, read:

1. The paper at the resolved path
2. `.claude/rules/domain-profile.md` for field conventions and audience calibration
3. The Beamer Custom Environments table in `CLAUDE.md` for available environments
4. `Preambles/header.tex` if it exists, for shared preamble setup

### Step 3: Launch Storyteller Agent

Delegate to the `storyteller` agent via Task tool:

```
Prompt: Create a [format] talk from [paper].
Read the paper and extract: research question, identification strategy, main result,
secondary results, robustness checks, key figures/tables, institutional background.
Design narrative arc for [format] format.
Build Beamer .tex file using shared preamble and custom environments from CLAUDE.md.
Save to Slides/[format]_talk.tex
Do NOT compile — compilation is handled separately.
```

The Storyteller follows these principles:
- One idea per slide
- Figures > tables (tables in backup)
- Build tension: motivation → question → method → findings → implications
- Transition slides between major sections
- All claims must appear in the paper (single source of truth)

### Step 4: Compile

After the Storyteller saves the `.tex` file, compile:

```bash
cd slides && TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode [format]_talk.tex && TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode [format]_talk.tex
```

### Step 5: Launch Discussant Agent (Talk Critic)

After compilation, delegate to the `discussant` agent:

```
Prompt: Review the talk at Slides/[format]_talk.tex.
Check 5 categories:
  1. Narrative flow — does the story build properly?
  2. Visual quality — overflow, readability, consistency
  3. Content fidelity — every claim traceable to paper
  4. Scope for format — right amount of content for duration
  5. Compilation — review the .log for warnings
Score as advisory (non-blocking).
Save report to quality_reports/YYYY-MM-DD_[format]_talk_review.md
```

### Step 6: Fix Critical Issues

If Discussant finds Critical issues (compilation failures, content not in paper):
1. Re-dispatch Storyteller with specific fixes (max 3 rounds per three-strikes.md)
2. Re-compile and re-run Discussant to verify

### Step 7: Present Results

1. Generated `.tex` file path
2. Slide count and format compliance
3. Discussant score (advisory, non-blocking)
4. TODO items (missing figures, tables not yet generated)

---

## Output

Save to `Slides/[format]_talk.tex` (e.g., `Slides/seminar_talk.tex`).

---

## Principles

- **Paper is authoritative.** Every claim must appear in the paper.
- **Less is more.** Especially for short and lightning — ruthlessly cut.
- **Audience calibration.** Job market = rigor. Seminar = interesting result. Lightning = sell the idea.
- **Advisory scoring.** Talk scores don't block commits.
- **Worker-critic pairing.** Storyteller creates, Discussant critiques. Never skip the review.
