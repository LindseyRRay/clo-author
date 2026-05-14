# Empirical Strategy Template

**Target length:** 800–1,200 words.
**Position in paper:** Section after data (usually Section 4). Sometimes split: estimating equation in main paper, threats addressed in robustness section.
**Reads first:** The approved strategy memo, the estimating-equation specification, the relevant econometrician's notes.

## Required elements

- Source of variation, in plain English.
- Estimating equation, displayed and numbered.
- Notation defined for every symbol that appears.
- Identifying assumption stated formally.
- Threats to identification, named and addressed (or pointed to robustness).
- Cluster level for standard errors, with justification.

## Paragraph-by-paragraph scaffold

### Paragraph 1 — Source of variation (~150–200 words)
- Topic sentence stating where the identifying variation comes from.
- Why the variation is plausibly exogenous to the outcome.
- Chain logical necessity (writing-style rule 4): each sentence is a logical consequence of the previous.
- Closing sentence: previews the estimating equation.

### Paragraph 2 — Estimating equation (~150–200 words)
- Lead-in sentence: "We estimate the following equation:"
- Display the equation with `\begin{equation} ... \end{equation}` and a label.
- Define every symbol in the equation in a paragraph immediately after:
  - "$Y_{it}$ is [outcome] for unit $i$ in period $t$."
  - "$D_{it}$ is the [treatment indicator / instrument]."
  - "$\alpha_i$ and $\delta_t$ are unit and time fixed effects."
  - "$X_{it}$ is a vector of [controls]."
  - "$\varepsilon_{it}$ is the error term."
- State the coefficient of interest: "$\beta$ is the parameter of interest, capturing [interpretation]."

### Paragraph 3 — Identifying assumption (~150–200 words)
- State the assumption formally and in plain English.
- Standard examples:
  - DiD: "Conditional on fixed effects, the average outcome of treated units would have evolved in parallel with control units absent treatment."
  - IV: "The instrument affects the outcome only through its effect on treatment, conditional on controls."
  - RDD: "Potential outcomes are continuous in the running variable at the cutoff."
- One sentence on what the assumption rules out (the violations that would break it).

### Paragraph 4 — Threats and how the design addresses them (~200–300 words)
- For each threat:
  - Name the threat (e.g., "anticipation effects", "spillovers", "selection into treatment").
  - Why it would be a problem (what bias it introduces).
  - How the design or the data limits it (or, defer: "Section X tests this.").
- Typically 2–4 threats.

### Paragraph 5 — Standard errors and inference (~50–100 words)
- Cluster level and justification.
- Wild bootstrap, randomization inference, or other unusual choices if applicable.
- Sample weights, if any.

### Paragraph 6 (optional) — Alternative specifications previewed (~100 words)
- "Section X presents results from alternative estimators: [list]."
- Use sparingly — usually goes in the results section.

## Banned patterns

- "We use a difference-in-differences design." without a one-sentence explanation of what the design exploits.
- "Standard errors are clustered at the firm level." without saying why firm-level clustering is correct.
- "This is similar to [Cited Paper]'s strategy." without explaining what is similar and what is not.
- Hedging on the identifying assumption ("we believe the parallel trends assumption is likely to hold") — state it directly, then defend.

## Tables and figures expected

- Equation, displayed and numbered.
- Optional: a figure illustrating the source of variation (rollout map, instrument distribution, RD scatter).
- Optional: a balance table or first-stage table if the variation lends itself.

## Length norms from example papers
- Generative AI at Work: Section 3.3 ~900 words, 1 displayed equation.
- Market Effects of Algorithms: Section 4 ~1,500 words, 4 displayed equations (county-level, triple-difference, complier characteristics).
- Hiring as Exploration: ~1,400 words, multiple equations across the method section.
