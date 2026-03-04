---
paths:
  - "src/**/*.py"
  - "src/**/*.do"
  - "**/*.tex"
---

# Table Standards

**Target:** Publication-quality tables matching AER, QJE, and Econometrica formatting.

---

## 1. No In-Table Titles or Notes

- **Never** embed titles inside the table body or as a table header row
- **Never** embed notes, sources, or footnotes inside the table itself
- Table numbering, titles, and notes are added in LaTeX via `\caption{}` and `\begin{tablenotes}`
- The file name and folder identify what the table contains

## 2. Three-Line Format (Booktabs)

Every table uses exactly three horizontal rules and **zero vertical lines**:

```latex
\begin{table}[htbp]
\centering
\begin{tabular}{lcccc}
\toprule
            & (1)     & (2)     & (3)     & (4)     \\
\midrule
...coefficients...
\bottomrule
\end{tabular}
\end{table}
```

- `\toprule` above column headers
- `\midrule` below column headers (and to separate panels)
- `\bottomrule` at the very end
- `\cmidrule(lr){2-4}` for partial rules spanning column groups
- **Never** use `\hline`, `|`, or any vertical rules

## 3. Coefficient Display

- Point estimates on one row, standard errors in parentheses on the row below
- Stars for significance: `*` p < 0.10, `**` p < 0.05, `***` p < 0.01
- Align significance note at the bottom: `\textit{Notes:} * p < 0.10, ** p < 0.05, *** p < 0.01`
- Standard errors labeled in the note (e.g., "Robust standard errors in parentheses" or "Clustered at municipality level")

```
Treatment        & 0.045**  & 0.038*   & 0.052*** \\
                 & (0.021)  & (0.020)  & (0.019)  \\
```

## 4. Column and Row Structure

- **Column (1), (2), ...** headers in the first row after `\toprule`
- **Dependent variable** stated in a spanning header or the first subheader row
- **Variable names** left-aligned, human-readable (not raw variable names)
  - `Log wages` not `ln_wage_deflated`
  - `Female` not `sex_2`
  - `Years of education` not `educ_yrs`
- **Numeric columns** right-aligned or decimal-aligned
- **N**, **R²**, **Fixed effects** (Yes/No), **Controls** (Yes/No) at the bottom before `\bottomrule`

## 5. Panel Structure

For tables with multiple panels:

```latex
\multicolumn{5}{l}{\textit{Panel A: Full sample}} \\
\midrule
...
\\[0.5em]
\multicolumn{5}{l}{\textit{Panel B: Male workers}} \\
\midrule
...
```

- Panel labels in italics, left-aligned, spanning all columns
- `\midrule` after each panel label
- Small vertical space (`\\[0.5em]`) between panels

## 6. Preferred Packages

### Python: `pyfixest` (primary) or `statsmodels`

```python
import pyfixest as pf

# Run regression
fit = pf.feols("y ~ treatment + controls | fe1 + fe2", data=df)

# Export LaTeX table
pf.etable([fit1, fit2, fit3], type="tex",
          coef_rename={"treatment": "Treatment", "log_income": "Log income"},
          signif_code=[0.01, 0.05, 0.10])
```

For descriptive tables:

```python
import pandas as pd

df.describe().to_latex(
    buf="Output/Tables/sumstats_main_sample.tex",
    float_format="%.3f",
    caption="Summary Statistics"
)
```

### Stata: `esttab` / `estout`

```stata
eststo clear
eststo: reg y treatment controls, cluster(state)
eststo: reghdfe y treatment controls, absorb(fe1 fe2) cluster(state)

esttab using "Output/Tables/reg_main_specification.tex", ///
    replace booktabs se star(* 0.10 ** 0.05 *** 0.01) ///
    nomtitle label
```

### Alternative (R): `modelsummary` or `fixest::etable`

If using R scripts, prefer `modelsummary` for regression tables and `kableExtra` for descriptive tables.

## 7. Typography

- Serif font throughout (inherits from document class -- no extra commands needed)
- `\small` or `\footnotesize` for tables that need to fit within column width
- Variable names in plain text, panel labels in `\textit{}`
- Never bold table body content; bold only for rare emphasis in headers

## 8. Export

```python
# Write .tex fragment (no \begin{table} wrapper -- added in main.tex)
with open("Output/Tables/reg_main_specification.tex", "w") as f:
    f.write(tex_output)
```

- Output **bare `tabular` environment** (no `\begin{table}` float)
- The paper's `main.tex` wraps it with `\begin{table}`, `\caption{}`, and `\input{}`

## 9. File Naming

```
Output/Tables/
├── descriptive/
│   ├── sumstats_main_sample.tex
│   └── balance_treatment_control.tex
├── estimation/
│   ├── reg_main_specification.tex
│   ├── reg_heterogeneity_gender.tex
│   └── did_event_study_coefficients.tex
└── robustness/
    └── reg_alternative_controls.tex
```

Pattern: `{table_type}_{content_description}.tex`

- `sumstats_` for summary statistics
- `balance_` for balance / pre-treatment tests
- `reg_` for regression output
- `did_` for difference-in-differences specific tables
- `first_stage_` for IV first stage

## 10. Prohibited Patterns

| Pattern | Reason |
|---------|--------|
| Title row inside the table | Titles go in `\caption{}`, not the table body |
| Notes embedded in table body | Notes go below via `\begin{tablenotes}` |
| `\hline` | Use `\toprule` / `\midrule` / `\bottomrule` (booktabs) |
| Vertical rules (`\|` in column spec) | Never used in economics journals |
| Raw variable names in labels | Human-readable labels required |
| `\begin{table}` in script output | Scripts export bare `tabular`; float wrapper lives in `main.tex` |
