# Plan: Migrate style rules into skills + add prompt-router hook

**Status:** APPROVED 2026-05-13
**Date:** 2026-05-13
**Author:** Claude (Opus 4.7)

## Approved decisions
1. **User-level `~/.claude/rules/writing-style.md`:** leave alone. Draft-paper skill will add Copilot-specific section templates only; not duplicate the user-level rules.
2. **Hook mode:** nudge only (print hint suggesting the right skill).
3. **Commits:** two — (a) rules→skills migration; (b) hook + settings.

---

## Goal

Stop loading slide and paper style rules into every conversation's system prompt. Move them into the existing `create-talk` and `draft-paper` skills (on-demand). Re-audit against the example papers/decks to tighten the patterns. Add a `UserPromptSubmit` hook that nudges Claude to invoke the right skill when a writing-related prompt is detected.

## What's bloating right now

Three rules files auto-load into every system prompt:

| File | Size | Loads on… |
|------|------|-----------|
| `.claude/rules/slide-deck-style.md` | ~350 lines | every Copilot turn |
| `.claude/rules/slide-deck-structure.md` | ~200 lines | every Copilot turn |
| `~/.claude/rules/writing-style.md` (user-level) | ~80 lines | every turn, *every project* |

Cost: ~630 lines × every conversation. ~95%+ of turns don't need them (Stata edits, data pipeline, hook fixes, git ops, etc.).

## Examples to audit against

In `slides/examples/`:

| File | Type | Source |
|------|------|--------|
| `paper_GenerativeAIAtWork.tex` | paper | Brynjolfsson, Li, Raymond — QJE |
| `paper_MarketEffectsOfAlgorithms.pdf` | paper | Raymond — solo |
| `paper_HiringAsExploration.tex` | paper | Li, Raghavan, Mullainathan — RESTUD |
| `slides_GenerativeAIAtWork_seminar_2025-09.tex` | seminar deck (54 frames) | TASKS VII |
| `slides_MarketEffectsOfAlgorithms_seminar_2025-02.tex` | seminar deck (89 frames) | MIT Behavioral |
| `slides_PredictionPolicyWithATwist_lecture_2025-03.tex` | lecture (25 frames) | guest lecture |

---

## Phase 1 — Audit (target: ~1 hour)

For each rules file, read it side-by-side with the relevant examples and produce a delta list.

### Slide rules vs decks
- Verify every rule in `slide-deck-style.md` is actually used in ≥1 deck. Drop rules that aren't.
- Find patterns used in ≥2 decks that aren't yet captured. Add them.
- Confirm the 12-block structure in `slide-deck-structure.md` matches the actual GenAI / Market Effects decks frame-by-frame.

### Paper rules vs papers
- Verify every rule in `writing-style.md` is actually used in ≥1 paper. Drop rules that aren't.
- Compare intro structure across GenAI / Market Effects / HiringAsExploration — codify the consensus pattern in section-template form.
- Extract section-length norms (intro words, results words, etc.) from actual word counts.

### Deliverables (3)
1. `quality_reports/specs/2026-05-13_style_rule_audit.md` — table of edits to make.
2. `.claude/skills/create-talk/template.tex` — talk outline skeleton: full block-by-block scaffold (title → hook → paper intro → literature → agenda → setting → data → strategy → findings → framework → robustness → conclusion → backup) with TODO placeholders and inline comments showing which style rules apply where.
3. `.claude/skills/draft-paper/templates/` — one `.md` skeleton per paper section (intro, abstract, lit-review, data, empirical-strategy, results, conclusion). Each lays out paragraph-by-paragraph structure with prompts ("paragraph 1: hook — 1 paragraph on the phenomenon, …"). These are reference scaffolds the Writer agent reads when drafting.

---

## Phase 2 — Migrate rules into skills (~1 hour)

### New files
- `.claude/skills/create-talk/style.md` — tightened `slide-deck-style.md`
- `.claude/skills/create-talk/structure.md` — tightened `slide-deck-structure.md`
- `.claude/skills/draft-paper/style.md` — tightened writing-style + section templates

### Edits to existing files
- `.claude/skills/create-talk/SKILL.md` — add "Step 2a: Read style.md + structure.md" before dispatching Storyteller. Pass both file paths to the agent prompt.
- `.claude/skills/draft-paper/SKILL.md` — add "Step 1a: Read style.md" before dispatching Writer.
- `.claude/agents/storyteller.md` — replace inline style guidance with `Read .claude/skills/create-talk/{style,structure}.md before drafting`.
- `.claude/agents/writer.md` — replace inline section standards with `Read .claude/skills/draft-paper/style.md before drafting`.

### Slim down rules files
- `.claude/rules/slide-deck-style.md` → 10-line pointer ("For slide style, see `.claude/skills/create-talk/style.md`. Loaded on-demand via `/create-talk` or the prompt-router hook.")
- `.claude/rules/slide-deck-structure.md` → same treatment.

### Open question — user-level rule
`~/.claude/rules/writing-style.md` is at the USER level (loads for ALL projects, not just Copilot). Three options:

| Option | What happens | Tradeoff |
|--------|-------------|----------|
| A. Leave alone | Loads on every turn of every project | Status quo — bloats every chat including non-writing ones |
| B. Slim to ~20-line core principles at user level; full version → `draft-paper/style.md` (project-local) | Other projects keep the gist; Copilot gets the deep version | Best balance — recommended |
| C. Move entirely to project skill | Other projects lose the rules | Cleanest for Copilot, worst for everything else |

**Recommendation: B.** Decision needed before Phase 2 begins.

---

## Phase 3 — Prompt-router hook (~30 min)

### New file: `.claude/hooks/style-context-router.py`

`UserPromptSubmit` hook. Reads the prompt from stdin (JSON), greps for keywords:

| If prompt matches… | Inject context |
|-------------------|----------------|
| `slide`, `frame`, `deck`, `beamer`, `talk`, `presentation` | "💡 This prompt looks like slide work. Invoke `create-talk` skill or read `.claude/skills/create-talk/{style,structure}.md` before drafting." |
| `draft`, `write the (intro\|results\|conclusion\|paper\|section)`, `paper section`, `humanize` | "💡 This prompt looks like paper work. Invoke `draft-paper` skill or read `.claude/skills/draft-paper/style.md` before drafting." |

Mode: print the nudge to stdout (Claude sees it as additional context). Exit 0 — non-blocking. Never fires on Stata/Python/git prompts.

### Settings update
Add to `.claude/settings.json` under `hooks.UserPromptSubmit`:
```json
{
  "hooks": [
    {
      "type": "command",
      "command": "python3 \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/style-context-router.py",
      "timeout": 5
    }
  ]
}
```

### Optional aggressive variant (NOT recommended initially)
Instead of nudging, inject the full skill content directly. Saves Claude one round-trip but pays the full token cost on every match — even false positives. Hold off until we see whether the nudge is sufficient.

---

## Phase 4 — Verify (~30 min)

- Test hook with 6 sample prompts (3 should match, 3 shouldn't): "draft the intro", "fix typo in main.tex", "build the seminar deck", "update Stata code", "rewrite results section", "rerun the regression".
- Manually invoke `/create-talk seminar` (dry run) and confirm SKILL.md loads style + structure files.
- Manually invoke `/draft-paper intro` (dry run) and confirm SKILL.md loads style file.
- Check no other file references the deleted rules content (`grep -r "slide-deck-style\|slide-deck-structure"` in `.claude/`).

---

## Out of scope (explicitly)

- Editing `paper/` content (separate work).
- Changing the Storyteller/Writer/Discussant/Proofreader agent workflow logic — only their style references.
- Adding new skills. Tightening the two existing ones.
- Touching the `slides/examples/` files (read-only reference).

---

## Files touched (estimate)

| File | Action |
|------|--------|
| `.claude/skills/create-talk/style.md` | CREATE |
| `.claude/skills/create-talk/structure.md` | CREATE |
| `.claude/skills/create-talk/template.tex` | CREATE |
| `.claude/skills/create-talk/SKILL.md` | EDIT |
| `.claude/skills/draft-paper/style.md` | CREATE |
| `.claude/skills/draft-paper/templates/intro.md` | CREATE |
| `.claude/skills/draft-paper/templates/abstract.md` | CREATE |
| `.claude/skills/draft-paper/templates/lit-review.md` | CREATE |
| `.claude/skills/draft-paper/templates/data.md` | CREATE |
| `.claude/skills/draft-paper/templates/empirical-strategy.md` | CREATE |
| `.claude/skills/draft-paper/templates/results.md` | CREATE |
| `.claude/skills/draft-paper/templates/conclusion.md` | CREATE |
| `.claude/skills/draft-paper/SKILL.md` | EDIT |
| `.claude/agents/storyteller.md` | EDIT |
| `.claude/agents/writer.md` | EDIT |
| `.claude/rules/slide-deck-style.md` | SHRINK |
| `.claude/rules/slide-deck-structure.md` | SHRINK |
| `~/.claude/rules/writing-style.md` | SHRINK (pending decision) |
| `.claude/hooks/style-context-router.py` | CREATE |
| `.claude/settings.json` | EDIT |
| `quality_reports/specs/2026-05-13_style_rule_audit.md` | CREATE |

13 files. Mostly small edits; 4 new skill content files of moderate size; 1 new hook (~80 lines Python).

---

## Open questions for approval

1. **User-level `writing-style.md` — Option A, B, or C above?** (Recommended: B)
2. **Nudge or aggressive inject for the hook?** (Recommended: nudge initially)
3. **Audit deliverable as a spec, or just inline in the commit?** (Recommended: spec, for the record)
4. **One commit or staged commits?** (Recommended: 2 commits — Phase 1+2 together (rules→skills), Phase 3+4 together (hook).)

---

## Estimated total: 3-4 hours of Claude time
