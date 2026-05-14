# Examples

Reference papers and slide decks from prior projects, used as style and formatting templates for the Copilot paper and its talks.

## Naming convention

- **Papers:** `paper_<TitleCamelCase>.{tex,pdf}`
- **Slides:** `slides_<TitleCamelCase>_<seminar|lecture>_<YYYY-MM>.{tex,pdf}`

`<TitleCamelCase>` is the title of the underlying paper or talk, written without spaces. The trailing `YYYY-MM` on slide decks records the month the deck was delivered.

## Inventory

### Papers

| File | Source | Notes |
| --- | --- | --- |
| `paper_GenerativeAIAtWork.tex`, `paper_GenerativeAIAtWork.pdf` | Brynjolfsson, Li, and Raymond. *Generative AI at Work*. *Quarterly Journal of Economics*. | Article-class LaTeX manuscript. Reference for paper structure, prose, and figure/table formatting. |
| `paper_MarketEffectsOfAlgorithms.pdf` | Raymond. *The Market Effects of Algorithms*. | PDF only. Reference for paper-level prose and result presentation. |
| `paper_HiringAsExploration.tex` | Li, Raghavan, and Mullainathan. *Hiring as Exploration*. *Review of Economic Studies*. | RESTUD-class manuscript source. Reference for journal-formatted submission. |

### Slide decks

| File | Underlying paper | Venue | Format | Frames |
| --- | --- | --- | --- | --- |
| `slides_GenerativeAIAtWork_seminar_2025-09.{tex,pdf}` | Generative AI at Work | TASKS VII workshop | Seminar | 57 |
| `slides_MarketEffectsOfAlgorithms_seminar_2025-02.{tex,pdf}` | The Market Effects of Algorithms | MIT Behavioral seminar | Seminar | 92 |
| `slides_PredictionPolicyWithATwist_lecture_2025-03.tex` | Hiring as Exploration | Guest lecture, "Prediction Policy with a Twist: Part I" | Lecture | 19 |

## Usage

These files are reference templates only. They are not built or compiled as part of the project pipeline. Copy patterns, preamble blocks, and figure/table styles from them when drafting new papers or decks; do not edit the originals.
