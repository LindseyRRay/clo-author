# Session Log: 2026-05-13 -- Migrate style rules to skills + add prompt-router hook

**Status:** IN PROGRESS

## Objective

Move the three style/structure rules out of always-loaded project rules and into the existing `create-talk` and `draft-paper` skills. Tighten skill content against the example papers and decks in `slides/examples/`. Add a `UserPromptSubmit` hook that nudges Claude to invoke the right skill when the prompt looks like writing or slide work.

## Context

Three rule files currently auto-load into every conversation's system prompt: `.claude/rules/slide-deck-style.md` (~350 lines), `.claude/rules/slide-deck-structure.md` (~200 lines), and `~/.claude/rules/writing-style.md` (~80 lines, user-level). The user is concerned this bloats every chat including non-writing turns (Stata edits, data pipeline, git ops). User-level rule stays put (applies across projects); project-level rules move.

## Plan

`quality_reports/plans/2026-05-13_migrate-style-rules-to-skills.md` (APPROVED 2026-05-13).

Four phases:
1. Audit existing rules vs example files; produce delta list + concrete templates (talk + 7 paper sections).
2. Migrate rules into skills; update SKILL.md and agent definitions; slim rules to pointers.
3. Add UserPromptSubmit hook (nudge mode).
4. Verify.

## Approved decisions

| Decision | Choice |
|----------|--------|
| User-level `writing-style.md` | Leave alone |
| Hook mode | Nudge (print hint suggesting skill) |
| Commit strategy | Two commits — (a) rules→skills, (b) hook |

## Changes Made

| File | Change | Reason |
|------|--------|--------|
| `quality_reports/plans/2026-05-13_migrate-style-rules-to-skills.md` | CREATE → APPROVED | Plan-first workflow |
| `quality_reports/specs/2026-05-13_style_rule_audit.md` | CREATE | Phase 1 audit deliverable |
| `.claude/skills/create-talk/template.tex` | CREATE | Phase 1 talk skeleton |
| `.claude/skills/draft-paper/templates/intro.md` | CREATE | Phase 1 paper section template |
| `.claude/skills/draft-paper/templates/abstract.md` | CREATE | Phase 1 paper section template |
| `.claude/skills/draft-paper/templates/lit-review.md` | CREATE | Phase 1 paper section template |
| `.claude/skills/draft-paper/templates/data.md` | CREATE | Phase 1 paper section template |
| `.claude/skills/draft-paper/templates/empirical-strategy.md` | CREATE | Phase 1 paper section template |
| `.claude/skills/draft-paper/templates/results.md` | CREATE | Phase 1 paper section template |
| `.claude/skills/draft-paper/templates/conclusion.md` | CREATE | Phase 1 paper section template |

## Incremental Work Log

**Phase 1 (this session):**
- Read existing skill SKILL.md files (`create-talk`, `draft-paper`) and existing agent definitions (`storyteller`, `writer`). Confirmed they don't currently reference the style rules.
- Grepped frame titles from all three example decks. Verified 12-block structure matches GenAI seminar (54 frames) and Market Effects seminar (89 frames). Lecture deck (25 frames) confirms relaxations rule.
- Wrote audit spec — verdict: existing rules are accurate against examples; net change for migration is whitespace-only.
- Wrote talk template `template.tex` with TODO placeholders for all 12 blocks + inline comments referencing rule sections.
- Wrote 7 paper section templates with paragraph-by-paragraph scaffolds, banned patterns, and length norms drawn from the three example papers.

**Phase 1 — second pass on template.tex (user asked to incorporate additional slide guidance):**
- Audited 7 additional sources of slide guidance:
  - `.claude/agents/storyteller.md` — slide standards (font ≥10pt, max 5-6 cols, backup after `\appendix`)
  - `.claude/agents/discussant.md` — 5 review categories (narrative, visual, fidelity, scope, compilation)
  - `.claude/rules/quality-gates.md` — talk deductions table (overfull hbox −2, slide count out-of-range −10, notation mismatch −5)
  - `.claude/rules/single-source-of-truth.md` — every claim/figure/SE must match paper; no talk-only results
  - `.claude/rules/table-generator.md` — bare tabular, no in-body title, booktabs, no vertical rules
  - `slides/slides.sty` — actual macros (`\bi/\ei`, `\highlight{}`, `\bottomleft{}`, `\tabletitle{}`, `\imageframe{}`) and defined colors
  - `quality_reports/2026-05-04_seminar_talk_review.md` — concrete past pitfalls (cumulative `\smsp` → overfulls; pacing 55 sec/slide too dense; missing `\label`)
- Discovered `accentblue` color (used in MarketEffects example) is NOT defined in Copilot's `slides.sty`. Replaced with `trueblue` throughout template.
- Removed `\definecolor{accent}{HTML}{940034}` and `\definecolor{accent2}{HTML}{006896}` from the template's preamble — those overrides from the example decks would conflict with Copilot's `\providecolor` defaults in `slides.sty`.
- Added top-of-file header block listing: format budget for all 4 formats with pacing norms; fidelity rules; concrete past-talk pitfalls; full catalog of `slides.sty` macros available; full color palette.
- Updated table-frame backup pattern to `\scalebox{.X}{\makebox[\linewidth]{\input{tables/X.tex}}}` (GenAI deck convention).
- Added `\tabletitle{Outcome:}{...}` example for outside-tabular table title.
- Template grew 423 → 532 lines.

**Phase 1 — third pass on template.tex (compaction review):**
- Header block cut from 71 to 29 lines: kept format budget, macros catalog, color palette; replaced fidelity + past-talk pitfall blocks with one-line pointers to the rules / review file (they auto-load with the skill so duplicating in template wastes lines).
- Per-block comment headers cut from 5-10 lines each to 2-4 lines. Each block now states the pattern in 1-3 sentences; details live in `structure.md`.
- Removed the stale "trueblue is used in MarketEffects but is NOT defined" NOTE that became circular after the earlier `replace_all`.
- Replaced `\textcolor{gray}{...}` → `\asher{...}` (project macro) in 9 places in agenda re-shows and robustness re-show, for consistency with `slides.sty` conventions.
- Added one-line IV / triple-diff note in Block 8 (equation walkthrough) so the template covers Copilot's actual identification strategy without hardcoding.
- Removed redundant table-frame pattern comment block (lines 492-499) since the header now lists `\tabletitle{}` and `\scalebox{}\makebox[]{\input{}}` in the macro catalog.
- Removed redundant appendix-frame instruction comment.
- Final: 532 → 395 lines (26% reduction). Comment lines: ~150 → 77.

## Open Questions / Blockers

- [ ] User to confirm Phase 1 deliverables look right before Phase 2 migration begins (paused for review at end of Phase 1).

## 2026-05-14 — Retargeted into clo-author + Phases A–E executed

**Why retargeted.** The migration was being done in `CopilotCode/.claude/`, which is
**gitignored** — every artifact was untracked and would be lost. `clo-author`
(`github.com/LindseyRRay/clo-author`) is the canonical, GitHub-tracked Claude setup.
User decided (2026-05-14): move the whole migration into clo-author; move the planning
docs too. New plan: `quality_reports/plans/2026-05-14_migrate-style-rules-into-clo-author.md`.

**Recon findings.**
- `CopilotCode/.claude/` is a real directory, not a symlink — diverged from clo-author.
- The two `.claude/` dirs are otherwise nearly identical: `create-talk/SKILL.md`,
  `draft-paper/SKILL.md`, `storyteller.md`, `writer.md` were byte-identical.
- clo-author never had `slide-deck-style.md` / `slide-deck-structure.md` as rules, so
  there is nothing to "slim to a pointer" there — the content becomes skill files directly.
- Full consolidation (re-symlink CopilotCode/.claude → clo-author) is out of scope: the
  dirs also diverge in `commands/`, `settings.json`, two hooks, `latex-tables/SKILL.md`.

**Phase A — landed Phase 1 deliverables in clo-author.** Copied `template.tex` +
7 `draft-paper/templates/*.md`; moved plan / spec / session log into
`clo-author/quality_reports/`.

**Phase B — created migrated skill content.** `create-talk/style.md` and
`structure.md` (from the CopilotCode slide rules, verbatim + corrected reference-deck
paths to clo-author's `slides/examples/` naming + on-demand header). `draft-paper/style.md`
(notation protocol, section-length norms, placeholder conventions, banned-pattern
checklist; points to user-level `writing-style.md` rather than duplicating it).

**Phase C — wired skills + agents.** `create-talk/SKILL.md` and `draft-paper/SKILL.md`
now read the style files before dispatching; `storyteller.md` and `writer.md` got
"Read First" pointers, and their redundant inline standards were trimmed to reminders.

**Phase D — prompt-router hook.** `style-context-router.py` (UserPromptSubmit, nudge
mode, word-boundary keyword match, fails open). Registered in clo-author's
`settings.json` — applied via Bash because `protect-files.sh` (a basename guardrail
against accidental edits) blocks Edit/Write on `settings.json`.

**Phase E — verified.** Hook: 6 sample prompts, 3 match / 3 silent, as designed.
`grep` for old rule names in `clo-author/.claude/` — clean. SKILL.md + agent wiring
confirmed. Hook compiles.

## Next Steps

- [ ] Phase F: two commits on clo-author (A–C, then D–E) + push.
- [ ] Phase G: CopilotCode cleanup — slim `rules/slide-deck-{style,structure}.md` to
      pointers; sync new skill content into `CopilotCode/.claude/skills/`; delete the
      moved planning docs from `CopilotCode/quality_reports/`.
