---
paths:
  - "src/**/*.py"
  - "Output/Figures/**"
---

# Figure Standards

**Target:** Publication-quality figures matching AER, QJE, and Econometrica visual standards.

---

## 1. No In-Figure Text

- **Never** add titles via `plt.title()` or `fig.suptitle()`
- **Never** add source notes or captions inside the figure
- X-axis ticks must be complete — no skipping
- Titles, numbering, and notes belong in the paper/presentation, not the figure
- The file name and folder location identify what the figure shows

## 2. Serif Typography

All text elements must use a serif font consistent with economics journals.

```python
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "serif",
    "font.serif": ["Source Serif Pro", "CMU Serif", "Times New Roman"],
    "mathtext.fontset": "cm",  # Computer Modern for math
    "font.size": 12,
})
```

## 3. Journal Theme

Define a reusable style in `figure_settings.py`:

```python
import matplotlib.pyplot as plt

JOURNAL_STYLE = {
    # Typography
    "font.family": "serif",
    "font.serif": ["Source Serif Pro", "CMU Serif", "Times New Roman"],
    "font.size": 12,
    "mathtext.fontset": "cm",

    # Axes
    "axes.spines.top": False,
    "axes.spines.right": False,
    "axes.linewidth": 0.5,
    "axes.labelsize": 12,
    "axes.titlesize": 12,

    # Ticks
    "xtick.labelsize": 10,
    "ytick.labelsize": 10,
    "xtick.major.width": 0.5,
    "ytick.major.width": 0.5,

    # Grid (horizontal reference lines only)
    "axes.grid": True,
    "axes.grid.axis": "y",
    "grid.alpha": 0.3,
    "grid.linewidth": 0.5,

    # Legend
    "legend.frameon": False,
    "legend.fontsize": 10,

    # Figure
    "figure.facecolor": "white",
    "figure.dpi": 300,
    "savefig.dpi": 300,
    "savefig.bbox": "tight",
    "savefig.transparent": True,
}


def apply_style(context: str = "paper") -> None:
    """Apply journal-quality style. Context: 'paper' or 'slides'."""
    plt.rcParams.update(JOURNAL_STYLE)
    if context == "slides":
        plt.rcParams.update({"font.size": 16, "axes.labelsize": 16})
```

## 4. Color and Linetype

- Default to **grayscale** for print compatibility
- When color is needed, use a colorblind-safe palette (max 4-5 distinct colors)
- Always pair color with a second channel: linetype, marker shape, or fill pattern
- Confidence bands: `plt.fill_between(..., alpha=0.15)`

```python
# Colorblind-safe palette (IBM Design Library)
COLORS = ["#648FFF", "#785EF0", "#DC267F", "#FE6100", "#FFB000"]
GRAYSCALE = ["#000000", "#555555", "#999999", "#CCCCCC"]
```

## 5. Axis and Label Formatting

- Axis labels: descriptive, with units in parentheses — e.g., `"Income (USD, thousands)"`
- Use `matplotlib.ticker` formatters for numeric axes (`FuncFormatter`, `StrMethodFormatter`)
- Remove axis label when the meaning is obvious from context (e.g., "Year" on a time series)
- Breaks should be round numbers; set manually when auto-ticks produce odd intervals

```python
from matplotlib.ticker import FuncFormatter

ax.xaxis.set_major_formatter(FuncFormatter(lambda x, _: f"${x:,.0f}"))
```

## 6. Multi-Panel Figures

- Use `fig, axes = plt.subplots(nrows, ncols)` with `constrained_layout=True`
- Panel tags use lowercase letters: (a), (b), (c) via `ax.set_title("(a)", loc="left")`
- Consistent axis ranges across panels when comparability matters
- Share axes when appropriate: `sharey=True`

## 7. Common Plot Types

### Coefficient Plot (most common in applied micro)

```python
import matplotlib.pyplot as plt
import numpy as np

def coefplot(estimates, se, labels, ax=None):
    """Publication-ready coefficient plot."""
    if ax is None:
        fig, ax = plt.subplots(figsize=(6.5, 4))
    y_pos = np.arange(len(estimates))
    ax.errorbar(estimates, y_pos, xerr=1.96 * se,
                fmt="o", color="black", capsize=3, markersize=5)
    ax.axvline(0, color="grey", linewidth=0.5, linestyle="--")
    ax.set_yticks(y_pos)
    ax.set_yticklabels(labels)
    ax.set_xlabel("Estimate")
    return ax
```

### Event Study

```python
def event_study_plot(coefs, ci_lower, ci_upper, periods, ax=None):
    """Publication-ready event study plot."""
    if ax is None:
        fig, ax = plt.subplots(figsize=(6.5, 4))
    ax.fill_between(periods, ci_lower, ci_upper, alpha=0.15, color="steelblue")
    ax.plot(periods, coefs, "o-", color="steelblue", markersize=5)
    ax.axhline(0, color="grey", linewidth=0.5, linestyle="--")
    ax.axvline(-0.5, color="grey", linewidth=0.5, linestyle=":")
    ax.set_xlabel("Periods relative to treatment")
    ax.set_ylabel("Estimate")
    return ax
```

## 8. Export

```python
fig.savefig(
    FIGURES_DIR / "coefplot_main_specification.pdf",
    format="pdf",       # vector format for journals
    bbox_inches="tight",
    transparent=True,
)
```

- **Vector format** (PDF or EPS) for journal submission
- **PNG at 300+ dpi** for presentations and drafts
- Always `transparent=True`
- Standard widths: 6.5 in (single-column), 12 in (full-width / Beamer)

## 9. File Naming

```
Output/Figures/
├── descriptive/
│   ├── hist_income_distribution.pdf
│   └── scatter_education_earnings.pdf
├── estimation/
│   ├── coefplot_main_specification.pdf
│   └── event_study_treatment.pdf
└── robustness/
    └── coefplot_alternative_controls.pdf
```

Pattern: `{plot_type}_{variable_or_content}.pdf`

- `hist_` for histograms / distributions
- `scatter_` for scatter plots
- `coefplot_` for coefficient plots
- `event_study_` for event study figures
- `binscatter_` for binned scatter plots
- `map_` for geographic visualizations

## 10. Prohibited Patterns

| Pattern | Reason |
|---------|--------|
| `plt.title()` | Titles go in the document, not the figure |
| `plt.suptitle()` | Same — no in-figure titles |
| Default matplotlib style | Not journal quality — apply JOURNAL_STYLE |
| Sans-serif fonts | Journals require serif |
| Rainbow / jet colormaps | Not colorblind-safe, not professional |
| 3D effects, excessive decoration | Violates minimalism standard |
| `plt.savefig(..., format="png")` for final output | Use vector formats (PDF/EPS) for publication |
| `plt.show()` in scripts | Use `savefig()` only — `show()` is for interactive use |
