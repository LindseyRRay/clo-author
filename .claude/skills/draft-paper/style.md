# Paper Drafting Style

**Loaded on-demand by the `draft-paper` skill.** Not an always-loaded rule.

This file covers the **project-level mechanics** of drafting — notation, section-length norms, placeholder conventions, the banned-pattern checklist. The **prose-craft rules** (sentence flow, paragraph structure, results-vs-interpretation, intro structure, literature-review style, tone) live in the user-level `~/.claude/rules/writing-style.md` and are not duplicated here. Read both before drafting.

Per-section paragraph-by-paragraph scaffolds live in `templates/` — one file per section.

## Notation protocol

| Symbol | Meaning |
|--------|---------|
| `Y_it` | Outcome for unit `i` at time `t` |
| `D_it` | Treatment indicator for unit `i` at time `t` |
| `gamma_i` | Unit fixed effect |
| `delta_t` | Time fixed effect |
| `X_it` | Covariate vector |
| `epsilon_it` | Error term |

- Define every symbol at first use.
- Keep notation consistent across sections — the estimating equation in the empirical-strategy section sets the convention; results and abstract follow it.
- Estimating equations are displayed and numbered.

## Section-length norms

Targets are drawn from the three example papers in `slides/examples/` (`paper_GenerativeAIAtWork.tex`, `paper_MarketEffectsOfAlgorithms.tex`, `paper_HiringAsExploration.tex`).

| Section | Target words | Notes |
|---------|-------------|-------|
| Abstract | 100–150 | One paragraph. Question → method → headline finding with magnitude → so-what. |
| Introduction | 1,000–1,500 | Contribution stated within first 2 pages. Example papers run 1,300–1,800 words / 10–14 paragraphs. |
| Literature review | 300–600 | Thematic, integrated into prose. Often folded into the intro rather than standalone. |
| Data | 600–1,000 | Sample construction, key variables, summary-statistics table reference. |
| Empirical strategy | 800–1,200 | Identification assumption stated formally; estimating equation displayed and numbered; threats addressed. |
| Results | 800–1,500 | Every estimate with units and magnitude — not just signs. Description separate from interpretation. |
| Conclusion | 500–700 | Restate with effect size; limitations; implications. |

## Placeholder conventions

- `%TBD:` — empirical result needed but not yet available. Never fabricate a number.
- `%VERIFY:` — citation or fact not yet confirmed against source.
- Both are LaTeX comments — they compile cleanly and are greppable before submission.

## Banned-pattern checklist (recheck before submission)

- "This paper contributes to the literature on X" as a standalone framing device → show the contribution through findings.
- "There is a gap in the literature on Y" → state the tension that exists instead.
- "Interestingly", "remarkably", "it is worth noting", "arguably".
- Any "significant effect" without a number.
- Results and interpretation mixed in the same sentence.
- Citation dumps — 5+ parenthetical citations without connecting prose.
- Hedging ("may", "suggestive") where the evidence is actually established.

## Process

1. Writer reads `~/.claude/rules/writing-style.md` + this file + the relevant `templates/[section].md` before drafting.
2. Writer drafts to `Paper/sections/[section].tex`, runs the humanizer pass, saves.
3. Compile to catch LaTeX errors.
4. Proofreader scores (6 categories). Writer never self-scores.
