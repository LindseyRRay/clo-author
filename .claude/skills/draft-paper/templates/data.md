# Data Section Template

**Target length:** 600–1,200 words.
**Position in paper:** Usually Section 3 (after setting, before strategy). Sometimes split: brief data appears alongside setting, full data section follows strategy.
**Reads first:** Existing summary statistics tables, data construction documentation, sample restriction logs.

## Required elements

- Source(s) of the data, named explicitly.
- Sample construction: who is in, who is out, why.
- Time period covered.
- Key variables, including units and definitions.
- Reference to a summary statistics table.
- Acknowledgment of measurement limitations.

## Paragraph-by-paragraph scaffold

### Paragraph 1 — Data source (~100–150 words)
- Topic sentence: what data, from where.
- Provenance (administrative records, survey, scraped, proprietary firm data, etc.).
- Time period and frequency.
- Geographic coverage.
- Closing sentence: bridges to sample construction.

### Paragraph 2 — Sample construction (~150–250 words)
- Universe vs. analysis sample.
- Each restriction, in order, with the rationale and the count dropped:
  - "We drop observations where … This removes N firms because …"
- Closing: final analysis-sample size.

### Paragraph 3 — Key variables (~200–300 words)
- Outcomes: name, units, source. Include any transformations (log, winsorization).
- Treatment / instrument: name, units, source, construction.
- Controls: brief list, source.
- Reference: "Table 1 presents summary statistics."

### Paragraph 4 — Measurement issues (~100–200 words)
- One paragraph honestly noting:
  - Imperfect linkage / matching, if any.
  - Coverage gaps (e.g., "Salesforce IDs available for 9% of firms").
  - Censoring or truncation.
  - Validation steps that mitigate these.
- Closing: how the limitations affect interpretation, not whether the data is "good enough."

### Paragraph 5 (optional) — Summary statistics narrative (~100–200 words)
- 2–4 sentences highlighting what is notable in Table 1.
- Lead with magnitudes: "The median firm has X employees and grew Y% over the sample period."
- Comparison to a benchmark or external source ("This is consistent with BLS …").

## Banned patterns

- "We obtain data from …" → instead, name the source declaratively.
- "Our data is unique." → either show why or drop.
- "Summary statistics are presented in Table 1." → fine on its own, but weak as the only data-section evidence.
- "Variable X is the natural log of Y." without saying *why* the log transform is used.

## Length norms from example papers
- Generative AI at Work: Section 3 ~1,000 words, 4 paragraphs + 1 table reference.
- Market Effects of Algorithms: Section 3 ~1,400 words, 5 paragraphs + 2 tables + 1 figure.
- Hiring as Exploration: data section ~900 words, 4 paragraphs.

## Tables and figures expected

- Table 1: Summary statistics (mean, SD, key percentiles for treatment, outcomes, controls).
- Optional Table 2: Balance of treated vs. control on pre-treatment characteristics.
- Optional Figure: Sample construction flowchart or coverage map.
