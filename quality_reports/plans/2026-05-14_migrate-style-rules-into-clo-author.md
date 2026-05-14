# Plan: Move the slide/paper style migration into clo-author (tracked)

**Status:** IN PROGRESS — Phases A–E done (approved 2026-05-14); F next, then G
**Date:** 2026-05-14
**Author:** Claude (Opus 4.7)
**Supersedes:** `CopilotCode/quality_reports/plans/2026-05-13_migrate-style-rules-to-skills.md` (retargeted to clo-author)

## Why this plan exists

The rules-to-skills migration was being done in `CopilotCode/.claude/`, which is **gitignored** — every artifact (`template.tex`, 7 section templates, the slide rules) is untracked and would be lost. `clo-author` (`github.com/LindseyRRay/clo-author`) is the canonical, GitHub-tracked Claude setup. This plan retargets the whole migration into clo-author so it is version-controlled.

User decisions (2026-05-14):
- **Scope:** whole migration → clo-author (Phases 1–4).
- **Planning docs:** plan, spec, session log move into `clo-author/quality_reports/`.

## Starting state

| Repo | `.claude/` | This migration's files |
|------|-----------|------------------------|
| `clo-author` | tracked (92 files); `create-talk/SKILL.md`, `draft-paper/SKILL.md`, `storyteller.md`, `writer.md` all present and **identical** to CopilotCode's | none yet; `slides/examples/` already **staged** |
| `CopilotCode` | real dir, **gitignored**, diverged only slightly | `template.tex`, `draft-paper/templates/*.md` (7), `rules/slide-deck-{style,structure}.md` — all untracked |

clo-author has **no** `slide-deck-style.md` / `slide-deck-structure.md` as rules — so there is nothing to "slim to a pointer" there. The content simply becomes skill files that load on-demand. That is cleaner than the original plan's pointer-stub step.

## Phase A — Land Phase 1 deliverables in clo-author

Copy the finished Phase 1 artifacts from `CopilotCode/.claude/` into `clo-author/.claude/`:

| Source (CopilotCode) | Destination (clo-author) |
|----------------------|--------------------------|
| `.claude/skills/create-talk/template.tex` | `.claude/skills/create-talk/template.tex` |
| `.claude/skills/draft-paper/templates/*.md` (7 files) | `.claude/skills/draft-paper/templates/` |

Move the planning docs (currently untracked in CopilotCode):

| Source (CopilotCode) | Destination (clo-author) |
|----------------------|--------------------------|
| `quality_reports/plans/2026-05-13_migrate-style-rules-to-skills.md` | `clo-author/quality_reports/plans/` |
| `quality_reports/specs/2026-05-13_style_rule_audit.md` | `clo-author/quality_reports/specs/` (mkdir) |
| `quality_reports/session_logs/2026-05-13_migrate-style-rules-to-skills.md` | `clo-author/quality_reports/session_logs/` |

This plan file already lives in clo-author. Delete the CopilotCode originals after the move.

## Phase B — Create the migrated skill content in clo-author

| New file | From | Notes |
|----------|------|-------|
| `.claude/skills/create-talk/style.md` | `CopilotCode/.claude/rules/slide-deck-style.md` | Verbatim + whitespace/heading cleanup. Audit verdict was "no functional change." |
| `.claude/skills/create-talk/structure.md` | `CopilotCode/.claude/rules/slide-deck-structure.md` | Verbatim. |
| `.claude/skills/draft-paper/style.md` | new | Research-writing notation conventions + section-length norms drawn from the example papers. Does not duplicate the user-level `~/.claude/rules/writing-style.md` — references it. |

## Phase C — Wire the skills + agents to load the style files

| File | Edit |
|------|------|
| `.claude/skills/create-talk/SKILL.md` | Add a step before dispatching Storyteller: read `style.md` + `structure.md`; pass `template.tex` path. |
| `.claude/skills/draft-paper/SKILL.md` | Add a step before dispatching Writer: read `style.md`; pass the relevant `templates/*.md` path. |
| `.claude/agents/storyteller.md` | Replace inline slide guidance with: read `create-talk/{style,structure}.md` + `template.tex` before drafting. |
| `.claude/agents/writer.md` | Replace inline section standards with: read `draft-paper/style.md` + the section template before drafting. |

## Phase D — Prompt-router hook

| File | Action |
|------|--------|
| `.claude/hooks/style-context-router.py` | CREATE — `UserPromptSubmit` hook, nudge mode. Greps the prompt for slide/paper keywords; prints a one-line hint to invoke `create-talk` / `draft-paper`. Exit 0, non-blocking. Never fires on Stata/Python/git prompts. |
| `.claude/settings.json` | Register the hook under `hooks.UserPromptSubmit`. (clo-author's `settings.json`, not CopilotCode's.) |

## Phase E — Verify

- Hook: 6 sample prompts — 3 match ("draft the intro", "build the seminar deck", "rewrite results section"), 3 don't ("fix typo in main.tex", "update Stata code", "rerun the regression").
- Dry-run `/create-talk` and `/draft-paper` reasoning: confirm SKILL.md now points at the style files.
- `grep -r` in `clo-author/.claude/` for dangling references.

## Phase F — Commit + push clo-author

Two commits on clo-author (has `origin` → GitHub):
1. **Phases A–C** — migration content + skill/agent wiring + planning docs + staged `slides/examples/`.
2. **Phases D–E** — hook + settings.

Push both.

## Phase G — CopilotCode cleanup (stop the always-load bloat here)

`CopilotCode/.claude/` is gitignored and not symlinked, so it needs its own handling:

- Slim `CopilotCode/.claude/rules/slide-deck-style.md` and `slide-deck-structure.md` to ~10-line pointers (the original goal: stop them auto-loading into every Copilot conversation). Pointer text: "Slide style/structure now live in the `create-talk` skill — see clo-author. Loaded on-demand."
- Sync the new skill content into `CopilotCode/.claude/skills/` so `/create-talk` and `/draft-paper` still work in this project (copy `style.md`, `structure.md`, `template.tex`, `templates/`, and the edited SKILL.md/agent files).
- Delete the now-redundant untracked planning docs from `CopilotCode/quality_reports/` (moved to clo-author in Phase A).

## Out of scope

- **Consolidating CopilotCode/.claude into a symlink to clo-author.** The dirs diverge in `commands/`, `settings.json`, two hooks, and `latex-tables/SKILL.md` — a clean re-symlink needs per-file reconciliation. Separate task; flag for later.
- Editing the user-level `~/.claude/rules/writing-style.md` (stays put, per the original approved decision).
- Editing `paper/` or `slides/` content.

## Files touched

**clo-author (tracked, committed):** `skills/create-talk/{style,structure,template.tex}`, `skills/create-talk/SKILL.md`, `skills/draft-paper/style.md`, `skills/draft-paper/templates/*.md` (7), `skills/draft-paper/SKILL.md`, `agents/{storyteller,writer}.md`, `hooks/style-context-router.py`, `settings.json`, `quality_reports/{plans,specs,session_logs}/2026-05-13_*` + this plan, `slides/examples/*` (already staged).

**CopilotCode (gitignored, local only):** `rules/slide-deck-{style,structure}.md` → pointers; `skills/` synced; planning docs deleted.
