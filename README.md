# The Clo-Author: Your Econ AI Research Assistant for Claude Code

> **Work in progress.** This repo is a packaging of my own interpretation of that, tailored to pure research.

**Forked from:** [hsantanna88.github.io/clo-author](https://hsantanna88.github.io/clo-author/)
<br>**Built on:** [Pedro Sant'Anna's claude-code-my-workflow](https://github.com/pedrohcgs/claude-code-my-workflow)

---

## Quick Start

```bash
# 1. Fork and clone
gh repo fork https://github.com/LindseyRRay/clo-author.git --clone
cd clo-author

# 2. Open Claude Code
claude
```

Then paste this prompt:

> Read CLAUDE.md and help me set up the project structure.


Claude reads the configuration, fills in your project details, and enters contractor mode — planning, implementing, reviewing, and verifying autonomously.

---

## What It Does

### Contractor Mode

You describe a task. Claude plans the approach, implements it, runs specialized review agents, fixes issues, re-verifies, and scores against quality gates — all autonomously. You approve the plan and see a summary when the work meets quality standards.

### 15 Specialized Agents in Worker-Critic Pairs

Every creator has a paired critic. Critics can't edit files; creators can't score themselves.

| Phase | Worker (Creates) | Critic (Reviews) |
|-------|-----------------|-----------------|
| Discovery | Librarian | Editor |
| Strategy | Strategist | Econometrician |
| Execution | Coder | Debugger |
| Paper | Writer | Proofreader |
| Peer Review | Referee (x2) | Editor |
| Presentation | Storyteller | Discussant |
| Infrastructure | Orchestrator, Verifier | — |

Additional standalone agents: **Explorer** (data finder), **Surveyor** (data critic).

### 26 Slash Commands

| Category | Commands |
|----------|----------|
| **Pipeline** | `/new-project`, `/interview-me`, `/lit-review`, `/find-data`, `/identify` |
| **Analysis** | `/data-analysis`, `/econometrics-check`, `/review-code` |
| **Writing** | `/draft-paper`, `/proofread`, `/humanizer` |
| **Review** | `/paper-excellence`, `/review-paper`, `/respond-to-referee` |
| **Submission** | `/target-journal`, `/submit`, `/data-deposit`, `/audit-replication`, `/pre-analysis-plan` |
| **Talks** | `/create-talk`, `/visual-audit` |
| **Infrastructure** | `/validate-bib`, `/commit`, `/learn`, `/journal`, `/research-ideation` |

### Quality Gates

Weighted aggregate scoring with per-component minimums:

| Score | Gate | Applies To |
|-------|------|------------|
| 80 | Commit | Weighted aggregate (blocking) |
| 90 | PR | Weighted aggregate (blocking) |
| 95 | Submission | Aggregate + all components >= 80 |
| -- | Advisory | Talks (reported, non-blocking) |

### Context Survival

Plans, specifications, and session logs survive auto-compression and session boundaries. MEMORY.md accumulates learning across sessions — patterns discovered in one session inform future work.

---

## Project Structure

```
your-project/
├── CLAUDE.md                    # Project configuration (fill in placeholders)
├── .claude/                     # 15 agents, 26 skills, 22 rules, 8 hooks
├── Bibliography_base.bib        # Centralized bibliography
├── Paper/                       # Main LaTeX manuscript (source of truth), sometimes synced to overleaf
│   ├── main.tex
│   └── online_appendix.tex
├── Slides/                      # Beamer presentations
├── src/                         # Analysis code
├── Preambles/                   # LaTeX headers / shared preamble
├── templates/                   # Session log, quality report templates
├── quality_reports/             # Plans, session logs, reviews, scores
├── explorations/                # Research sandbox
├── docs/                        # Data documentation, codebooks, code review log
└── updates/                     # Progress updates for collaborators, lab notebooks
```

Empirics may live in a separate folder (e.g. a Dropbox folder) rather than a sub-folder of the repo, to avoid versioning large datasets. If so, document the path and access instructions in `CLAUDE.md`.

```
[EMPIRICS_ROOT]/
├── Data/RawData/                # Raw data only. Never modified after initial placement.
├── Data/WorkingData/            # Cleaned, merged, and manipulated datasets for analysis.
├── Output/Figures/              # Generated figures
├── Output/Tables/               # Generated tables
└── Replication/                 # Replication package for deposit
```

Figures and Tables are organized in sub-folders by date (YYYY-MM-DD). The date is set for the output, not the input, so you can re-run old code and have outputs organized by when they were generated.
I will often use `DATA_PATH` from `config.py` to reference the empirics root, so that paths are consistent and easily updated if the location changes.
I will also sometimes specify the date folder underwhich output should be placed, e.g. `DATA_PATH / 'Output/Figures/2025-01-04'` — this keeps outputs organized by generation date, not input date.

---

## Prerequisites

| Tool                                                          | Required For | Install |
|---------------------------------------------------------------|-------------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Everything | `npm install -g @anthropic-ai/claude-code` |
| XeLaTeX                                                       | Paper compilation | [TeX Live](https://tug.org/texlive/) or [MacTeX](https://tug.org/mactex/) |
| Python                                          | Analysis & figures | [python.org](https://www.python.org/) or `brew install python` (macOS) |
| Stata                                           | Regressions (econ convention) | [stata.com](https://www.stata.com/) (licensed) |
| [gh CLI](https://cli.github.com/)                             | GitHub integration | `brew install gh` (macOS) |

---

## Using Clo-Author in Existing Projects

You can add clo-author's infrastructure (agents, skills, rules, hooks) to any existing research project.

### Option A: Setup Script (recommended)

```bash
./setup-project.sh /path/to/your-project "Project Name" "Institution"
```

This copies `.claude/`, `CLAUDE.md` (with placeholders filled in), and `templates/` into your project, and creates the `quality_reports/` directory structure.

### Option B: Manual Setup

1. Copy the `.claude/` directory into your project
2. Copy `CLAUDE.md` and fill in the `[BRACKETED PLACEHOLDERS]`
3. Copy `templates/`
4. Create `quality_reports/plans/`, `quality_reports/session_logs/`, `quality_reports/specs/`, `quality_reports/strategy/`

### Why Copy Instead of Symlink?

You might be tempted to symlink `.claude/` so improvements propagate automatically. However, **Claude Code's skill registry does not follow symlinks** when scanning for `SKILL.md` files — skills will show "No skills found" and invocation fails with "Unknown skill." Copy the directory instead. To pick up updates from clo-author, re-run `setup-project.sh` or manually copy `.claude/` again.

### After Setup

1. **Fill in `CLAUDE.md`** — project name, institution, folder structure, data paths, current state
2. **Fill in the domain profile** (`.claude/rules/domain-profile.md`) — your field's journals, data sources, identification strategies, conventions, and seminal references. Use `/interview-me` to populate it interactively.
3. **Sync your paper from Overleaf** (optional) — clone your Overleaf project as `Paper/`:
   ```bash
   cd your-project
   git clone https://YOUR_EMAIL%40domain.com:YOUR_TOKEN@git.overleaf.com/PROJECT_ID Paper/
   ```
   Generate a Git token at [Overleaf Account Settings](https://www.overleaf.com/user/settings) under **Git Integration**. URL-encode the `@` in your email as `%40`.

---

## Adapting for Your Field

The Clo-Author is designed for applied econometrics, but the infrastructure (contractor mode, quality gates, adversarial review) works for any quantitative research field. Python is the default language, with Stata often used for regressions.

---

## Origin

The core infrastructure (contractor mode, quality gates, context survival, session logging) comes from the original template. The adversarial worker-critic architecture, econometrics-specific agents, paper drafting skills, and submission workflow are new.
---

## License

MIT License. Fork it, customize it, make it yours.
