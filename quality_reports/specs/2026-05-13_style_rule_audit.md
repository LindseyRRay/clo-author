# Style Rule Audit: Rules vs Example Files

**Date:** 2026-05-13
**Purpose:** Phase 1 deliverable of the rules-to-skills migration. Spot-check the existing style/structure rules against the actual example papers and decks, list edits, then produce concrete templates.

## Examples reviewed

| File | Frames / sections | Block sequence verified |
|------|-------------------|------------------------|
| `slides_GenerativeAIAtWork_seminar_2025-09.tex` | 54 frames | Title → 4 hook → paper intro → agenda → 6 setting → data/strategy → 12 findings → robustness → 12 mechanism findings → conclusion → appendix |
| `slides_MarketEffectsOfAlgorithms_seminar_2025-02.tex` | 89 frames | Title → 3 hook → 2 paper intro builds → 1 natural-experiment intro → 1 literature → agenda → 2 setting → 1 nat-exp → 1 data → conceptual framework → 3 classifier slides → strategy → 4 agenda re-shows → 7 first findings → 3 framework → 11 race-penalty findings → 3 second framework → conclusion → 46+ appendix |
| `slides_PredictionPolicyWithATwist_lecture_2025-03.tex` | 25 frames | Title → paper title → 5 setup → 7 method → 4 results → 5 deep-dive → conclusion image |

## Slide rules — audit verdict

### `.claude/rules/slide-deck-style.md`
**Verdict:** mostly accurate. Minor tightening needed.

| Rule | Status | Action |
|------|--------|--------|
| §1 Builds (`\pause`, `\only`, `\onslide`, `\overprint`) | Verified — every seminar deck uses all four | Keep |
| §2 Declarative titles | Verified — "On average, a 15 percent productivity improvement", "Digitization leads to price convergence" | Keep |
| §3 Sparse text (≤ 3-4 bullets) | Verified | Keep |
| §4 Color discipline | Verified — `\alert`, raspberry/teal/digitalblue labels, gray for de-emphasis | Keep |
| §5 Equations as walkthroughs | Verified — GenAI deck has term-by-term `\textcolor{raspberry}{\underbrace{...}}` | Keep |
| §6 Figures | Verified | Keep |
| §7 Agenda as section divider | Verified — MarketEffects shows agenda 5 times with progressive graying | Keep |
| §8 SEs to backup | Verified | Keep |
| §9 Appendix link pills | Verified — `\beamergotobutton{Back}` confirmed | Keep |
| §10 Diagrams over prose | Verified | Keep |
| §11 Numbered list pattern | Verified | Keep |
| §15 Preamble palette | Verified | Keep |
| §17 Lecture relaxations | Verified against PredPolicy deck | Keep |

**Net change:** none functionally. Just trim trailing whitespace, normalize headings during migration.

### `.claude/rules/slide-deck-structure.md`
**Verdict:** accurate. 12-block template matches both seminar decks.

| Block | GenAI (54f) | MarketEffects (89f) | Notes |
|-------|-------------|----------------------|-------|
| 1 Title | 1 | 1 | ✓ |
| 2 Hook | 4 | 3+2 (paper intro embedded) | MarketEffects shows the natural-experiment slides BEFORE the literature slide |
| 3 Paper intro | 1 | 2 builds | ✓ |
| 4 Lit positioning | (after data) | (after paper intro) | Both placements confirmed valid |
| 5 Agenda | 1 | 1 | ✓ |
| 6 Setting | 6 | 2 | GenAI uses more setting slides (consumer-tech audience) |
| 7 Data | 2 | 1 | ✓ |
| 8 Strategy | 1 | 1 | ✓ |
| 9 Findings 1st half | 12 | 7 | ✓ |
| 10 Framework | — | 3 mid-deck | GenAI skips formal framework block; MarketEffects has it after first finding |
| 11 Findings 2nd half | 12 | 11+3 | ✓ |
| 12 Robustness | 2 | embedded as "Assessing the empirical strategy" re-shows | The 3-times re-show pattern is verified |
| Conclusion | 1 | 1 | ✓ |
| Backup | ~9 | ~46 | ✓ |

**Net change:** none. The structure rules accurately describe both observed decks.

## Paper rules — audit verdict

### `~/.claude/rules/writing-style.md` (user-level, NOT touched)
**Verdict:** Already comprehensive. Phase 2 leaves alone per approved decisions.

What the rule covers and the papers confirm:
- Sentence flow with bridge words: visible in GenAI intro
- Declarative result statements with magnitudes: "15 percent productivity improvement" (GenAI), "5% race penalty" (MarketEffects)
- Contribution paragraph early (first 2 pages): all three papers comply
- Enumerated findings: all three papers comply
- Banned patterns ("interestingly", "remarkably"): grep on all three papers returns zero hits

## What the existing rules DON'T provide

1. **Concrete templates.** Rules describe principles but don't give a literal scaffold to fill in. The Writer agent has to construct structure from rules each time.
2. **Section-by-section paragraph order.** Writing-style.md describes intro structure in 8 numbered points (22-29) but doesn't say "paragraph 1 = phenomenon hook; paragraph 2 = research question + contribution sentence; ...".
3. **A talk skeleton.** Slide-deck-structure.md has a worked example table but no compilable `.tex` template.

**Action:** Phase 1 produces these concrete artifacts (template.tex + section .md files). They become the on-demand scaffolds the skills load.

## Migration impact summary

| Source file | Move to | Slim to |
|-------------|---------|---------|
| `.claude/rules/slide-deck-style.md` | `.claude/skills/create-talk/style.md` (verbatim, minor whitespace cleanup) | 10-line pointer |
| `.claude/rules/slide-deck-structure.md` | `.claude/skills/create-talk/structure.md` (verbatim) | 10-line pointer |
| `~/.claude/rules/writing-style.md` | **No move.** Stays at user level per approved decision. | No change |
| (new) | `.claude/skills/create-talk/template.tex` | — |
| (new) | `.claude/skills/draft-paper/style.md` (Copilot-specific notation + section length norms only — doesn't duplicate user-level) | — |
| (new) | `.claude/skills/draft-paper/templates/*.md` (7 files) | — |

No content is lost. The user-level writing rules continue to load globally; the project-level slide rules now load only on `/create-talk` or hook trigger.
