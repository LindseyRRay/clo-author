# CLAUDE.MD -- Applied Econometrics Research with Claude Code

<!-- HOW TO USE: Replace [BRACKETED PLACEHOLDERS] with your project info.
     Customize Beamer environments for your talk preamble.
     Keep this file under ~150 lines — Claude loads it every session.
     See the guide at https://hsantanna88.github.io/clo-author/ for full documentation. -->

**Project:** [YOUR PROJECT NAME]
**Institution:** [YOUR INSTITUTION]
**Branch:** main

---

## Core Principles

- **Plan first** -- enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** -- compile and confirm output at the end of every task
- **Single source of truth** -- Paper `main.tex` is authoritative; talks and supplements derive from it
- **Quality gates** -- weighted aggregate score; nothing ships below 80/100; see `scoring-protocol.md`
- **Worker-critic pairs** -- every creator has a paired critic; critics never edit files
- **[LEARN] tags** -- when corrected, save `[LEARN:category] wrong → right` to MEMORY.md

---

## Folder Structure

```
[YOUR-PROJECT]/
├── CLAUDE.MD                    # This file
├── .claude/                     # Rules, skills, agents, hooks
├── Bibliography_base.bib        # Centralized bibliography
├── Paper/                       # Main LaTeX manuscript (source of truth)
│   ├── main.tex                 # Primary paper file
│   └── online_appendix.tex      # Online appendix
├── Slides/                      # Beamer presentations
│   ├── job_market_talk.tex      # 45-60 min, full results
│   ├── seminar_talk.tex         # 30-45 min, standard seminar
│   ├── short_talk.tex           # 15 min, conference session
│   └── lightning_talk.tex       # 5 min, spiel/elevator pitch
├── src/                         # Analysis code (R, Stata, Python, Julia)
├── Preambles/header.tex         # LaTeX headers / shared preamble
├── templates/                   # Session log, quality report templates
├── quality_reports/             # Plans, session logs, reviews, scores
├── explorations/                # Research sandbox (see rules)
├── docs/                        # Data documentation, codebooks, code review log
└── updates/                     # Progress updates for collaborators, lab notebooks

[EMPIRICS_ROOT]/                 # May be external (e.g. Dropbox) — see note below
├── Data/RawData/                # Raw data only. Never modified after initial placement.
├── Data/WorkingData/            # Cleaned, merged, and manipulated datasets for analysis.
├── Output/Figures/              # Generated figures
├── Output/Tables/               # Generated tables
└── Replication/                 # Replication package for deposit
```

> **Note:** `[EMPIRICS_ROOT]` may be a separate folder (e.g. a Dropbox folder) rather than a sub-folder of the repo, to avoid versioning large datasets. Document the path and access instructions above. Use `DATA_PATH` from `config.py` to reference the empirics root so paths are consistent and easily updated. Figures and Tables use YYYY-MM-DD sub-folders organized by output date (e.g. `DATA_PATH / 'Output/Figures/2025-01-04'`).

---

## Commands

```bash
# paper compilation (3-pass, XeLaTeX only)
cd paper && TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex
BIBINPUTS=..:$BIBINPUTS bibtex main
TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex
TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex

# Talk compilation
cd slides && TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode talk.tex
```

---

## Quality Thresholds

| Score | Gate | Applies To |
|-------|------|------------|
| 80 | Commit | Weighted aggregate (blocking) |
| 90 | PR | Weighted aggregate (blocking) |
| 95 | Submission | Aggregate + all components >= 80 |
| -- | Advisory | Talks (reported, non-blocking) |

See `scoring-protocol.md` for weighted aggregation formula.

---

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| `/new-project [topic]` | Full pipeline: idea → paper (orchestrated) |
| `/interview-me [topic]` | Interactive research interview → spec + domain profile |
| `/lit-review [topic]` | Librarian + Editor: literature search + synthesis |
| `/find-data [question]` | Explorer + Surveyor: data discovery + assessment |
| `/identify [question]` | Strategist + Econometrician: design identification strategy |
| `/data-analysis [dataset]` | Coder + Debugger: end-to-end analysis |
| `/draft-paper [section]` | Writer: draft paper sections + humanizer pass |
| `/econometrics-check [file]` | Econometrician: 4-phase causal inference audit |
| `/review-code [file]` | Debugger: code quality review (standalone) |
| `/proofread [file]` | Proofreader: 6-category manuscript review |
| `/paper-excellence [file]` | Multi-agent parallel review + weighted score |
| `/review-paper [file]` | 2 Referees + Editor: simulated peer review |
| `/respond-to-referee [report]` | Revision routing per revision-protocol |
| `/target-journal [paper]` | Editor: journal targeting + submission strategy |
| `/submit [journal]` | Final gate: score >= 95, all components >= 80 |
| `/create-talk [format]` | Storyteller + Discussant: Beamer talk from paper |
| `/pre-analysis-plan [spec]` | Strategist: draft PAP (AEA/OSF/EGAP) |
| `/audit-replication [dir]` | Verifier: 10-check submission audit |
| `/data-deposit` | Coder + Verifier: AEA replication package |
| `/humanizer [file]` | Strip 24 AI writing patterns |
| `/journal` | Research journal timeline |
| `/validate-bib` | Cross-reference citations |
| `/commit [msg]` | Stage, commit, PR, merge |
| `/research-ideation [topic]` | Research questions + strategies |
| `/visual-audit [file]` | Slide layout audit |
| `/learn` | Extract session discoveries into skills |
---

<!-- CUSTOMIZE: Replace the example entries below with your own
     Beamer environments for talks. -->

## Beamer Custom Environments (Talks)

| Environment       | Effect        | Use Case       |
|-------------------|---------------|----------------|
| `[your-env]`      | [Description] | [When to use]  |

---

## Current Project State

| Component | File | Status | Description |
|-----------|------|--------|-------------|
| Paper | `Paper/main.tex` | [draft/submitted/R&R] | [Brief description] |
| Data | `src/` | [complete/in-progress] | [Analysis description] |
| Replication | `Replication/` | [not started/ready] | [Deposit status] |
| Job Market Talk | `Slides/job_market_talk.tex` | -- | [Status] |
