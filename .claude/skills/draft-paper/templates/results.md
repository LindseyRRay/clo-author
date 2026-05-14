# Results Section Template

**Target length:** 1,500–3,500 words (varies sharply with paper complexity).
**Position in paper:** After empirical strategy. Often split into Main Results (Section 5) + Mechanism / Heterogeneity (Section 6) + Robustness (Section 7).
**Reads first:** All output tables and figures, the strategy memo, any conceptual framework section.

## Required elements

- Main specification, presented before any alternative.
- Every estimate accompanied by magnitude and units (rule 14).
- Description and interpretation kept in separate sentences or paragraphs (rule 13).
- Enumerated findings, each with its own paragraph block (rule 16).
- Conceptual framework introduced before testing its predictions, when applicable (rule 20).

## Structure

### Subsection 1 — Main result (~400–800 words)

**Paragraph 1: lead with the headline (~150–250 words).**
- One topic sentence stating what the main spec finds, with magnitude.
- 2–3 sentences walking through Table X / Figure X column by column.
- Closing sentence: interpretation, separated from description.
  - Example pattern: "Column (1) of Table 2 shows that algorithmic entry raises sale prices by $\hat\beta = 0.05$ (SE = 0.01), a 5\% increase over the pre-treatment mean. This effect is robust to controlling for X (column 2) and Y (column 3). \textit{This 5\% increase is equivalent to 38\% of median Black household wealth.}"

**Paragraph 2: alternative estimators / robustness (~150–250 words).**
- "Similar results obtain across estimators."
- List: OLS, 2SLS, weighted, Callaway-Sant'Anna, etc.
- One sentence on each.
- Closing sentence: "Magnitudes are stable across specifications."

**Paragraph 3 (optional): pre-trends / parallel-trends evidence (~100–150 words).**
- "Figure X plots event-study coefficients."
- 1–2 sentences interpreting the pre-period coefficients.

### Subsection 2 — Mechanism / Heterogeneity (~600–1,500 words)

**Conceptual framework subsection (~200–400 words), if applicable.**
- "Two mechanisms could explain this effect: …" — name competing explanations.
- Generate testable predictions: "The framework yields two empirical implications."
- THEN test them in the next subsections, in order.

**Each finding paragraph (~150–250 words).**
- Topic sentence stating the finding with magnitude.
- 1–2 sentences walking the relevant table or figure.
- Mechanism interpretation, separate sentence.
- Robustness note, one sentence.

### Subsection 3 — Robustness (~400–800 words)

**One paragraph per threat addressed:**
- Topic sentence naming the threat.
- 1–2 sentences describing the test.
- Result, with magnitude.
- Closing sentence: "This rules out / mitigates the concern that …"

**Typical threats:**
- Pre-trends
- Selection / anticipation
- Spillovers / SUTVA violations
- Sample composition changes
- Alternative explanations from the framework

## Sentence-level rules

- **Lead with magnitude and units.** Never "a significant effect" without a number.
- **Description and interpretation in separate sentences.** Results sentence: "The point estimate is 5.8%." Interpretation sentence: "This is equivalent to 38% of median Black household wealth."
- **Contextualize magnitudes with benchmarks** where the magnitude alone is hard to interpret.
- **Confident voice for established findings**, hedged voice only for genuinely uncertain ones.

## Banned patterns

- "Statistically significant" without a magnitude.
- "Strong evidence" without a number.
- "We find that the effect is positive and significant." → state the magnitude.
- "These results have implications for …" without naming the implication.
- Treating heterogeneity as a single finding — split it into its own block.

## Tables and figures

- Main result: 1 table (typically 4–6 columns building up from baseline) + 1 event-study figure.
- Mechanism / heterogeneity: 1–3 figures.
- Robustness: 1 omnibus table + standalone figures for the most important threats.

## Length norms from example papers
- Generative AI at Work: Section 4 ~3,200 words across Main Results + Heterogeneity + Mechanism subsections.
- Market Effects of Algorithms: Sections 5–7 ~5,500 words across Investment, Race Penalty, Mechanism subsections.
- Hiring as Exploration: results sections ~2,400 words.
