# Slide Deck Style

**Loaded on-demand by the `create-talk` skill** (and by the prompt-router hook when a slide-related prompt is detected). Not an always-loaded rule.

**Scope.** These rules apply to **seminar, conference, and job-market decks**. Lecture decks (teaching) deliberately relax most of them — see Section 17.

**Reference decks:**
- Seminar / conference: `slides/examples/slides_GenerativeAIAtWork_seminar_2025-09.{tex,pdf}` and `slides/examples/slides_MarketEffectsOfAlgorithms_seminar_2025-02.{tex,pdf}`
- Lecture: `slides/examples/slides_PredictionPolicyWithATwist_lecture_2025-03.tex`

Companion: `structure.md` (which slides, in what order). Skeleton: `template.tex`.

## 1. Builds

Reveal non-trivial slides across 2–4 builds inside one `\begin{frame}`. The audience never sees a finished slide before the speaker has explained each piece.

**Build when:** list with 3+ ordered items; equation needing term-by-term annotation; multi-panel figure; question-then-answer reveals.

**Don't build:** single-bullet slides, static-figure slides, backup slides.

| Mechanism | Use when |
|---|---|
| `\pause` | New content adds below existing |
| `\only<N>{...}` | Content replaces other content in the same spot (equation walkthroughs, swapped figures) |
| `\onslide<N->{...}` | Content appears at slide N and stays |
| `\overprint{...}` | Visual variants in the same position, switching by slide |

All builds in one frame — never duplicate frames. Cap at ~6 builds; beyond that, split into two frames with the same title.

## 2. Declarative titles

The title is the takeaway; the body is the evidence. Never methodological.

| Avoid | Use |
|---|---|
| Margin 2: Geography of software work | Hiring contractions are largest offshore |
| First-stage results | Renewal proximity strongly predicts adoption |
| Heterogeneity by industry | Effect concentrated in U.S. IT services |

Exception: agenda slides label structure, not content.

## 3. Sparse text

- ≤ 3–4 main bullets per slide; 5+ means split into a build.
- Bullets are noun phrases or short clauses, not sentences.
- Sub-bullets only when necessary; never deeper than two levels.
- A slide that looks half-empty is doing it right.

## 4. Color discipline

Black is default. Color marks structural roles, not cosmetic emphasis.

| Role | Color | Macro |
|---|---|---|
| Frame title | Blue (`accent2`, HTML 006896) | Beamer theme |
| Inline emphasis (key terms, headline findings) | Red (`accent`, HTML 940034) | `\alert{...}` |
| Category label above a content block | Raspberry / teal / digitalblue (per slide) | `\textcolor{raspberry}{...}` etc. |
| Equation term annotation | Raspberry | `\textcolor{raspberry}{\underbrace{\bm{...}}_{...}}` |
| De-emphasis (agenda gray-out, qualifier detail) | Gray / asher | `\gray{...}` or `\textcolor{asher}{...}` |
| Closing email | Raspberry | `\textcolor{raspberry}{...}` |
| Two-color comparison (treatment vs control, human vs algorithm) | `accentblue` + `raspberry` with `\rule{}{}` | See pattern below |

Cap at 2–3 non-default colors per frame. Pick a category-label color for a slide and stay consistent.

**Two-color comparison pattern.** Header text + matching rule line + colored bullets:

```latex
\begin{column}{.5\textwidth}
  \centering
  \textcolor{accentblue}{Treatment Group} \\
  {\color{accentblue}\rule{\linewidth}{2pt}}
  \begin{itemize}
    \item \textcolor{accentblue}{AI-augmented agents}
  \end{itemize}
\end{column}
\begin{column}{.5\textwidth}
  \centering
  \textcolor{raspberry}{Control Group} \\
  {\color{raspberry}\rule{\linewidth}{2pt}}
  \begin{itemize}
    \item \textcolor{raspberry}{Agents without AI}
  \end{itemize}
\end{column}
```

## 5. Equations as walkthroughs

A multi-term equation gets multiple builds. Each build wraps one term with `\textcolor{raspberry}{\underbrace{\bm{...}}_{...}}`. Order: dependent variable → fixed effects → treatment → controls → plain final reveal with bullets on assumptions.

```latex
\only<1>{ $$ \textcolor{raspberry}{\underbrace{\bm{y_{it}}}_{\text{Resolutions per hour}}} = \alpha_i + \delta_t + \sum_{j\ne -1}\beta_j (AI_{it}\times \mathbf{1}[t=j]) + \gamma X_{it} + \varepsilon_{it} $$ }
\only<2>{ $$ y_{it} = \textcolor{raspberry}{\underbrace{\bm{\alpha_i + \delta_t}}_{\text{Agent + Month FE}}} + \sum_{j\ne -1}\beta_j (AI_{it}\times \mathbf{1}[t=j]) + \gamma X_{it} + \varepsilon_{it} $$ }
```

Annotations: 2–4 words.

## 6. Figures

- Large: ≥ 0.7 of usable text height single-panel; ≥ 0.55 in two-column layouts.
- Multi-panel figures build 1 → 2 → 3 → N panels.
- Panel labels in small caps (`A. AVERAGE HANDLE TIME`).
- Captions minimal on main slides — the slide title carries the meaning.
- Backup figures and tables use a methodology note in tiny italic gray:

```latex
\parbox{0.8\textwidth}{\justifying \tiny \textit{Note: This figure shows ...}}
```

- Inline icons (small images used like glyphs in bullets) live in `figures/Icons/`. Set width small (e.g., `\includegraphics[width=1.25cm]{figures/Icons/evaluating_people.png}`).
- Tables/figures that don't fit: wrap in `\begin{adjustbox}{max width=.6\textwidth, center}...\end{adjustbox}`.

## 7. Agenda as section divider

Show once early; re-show at every section transition with the active section bolded and others in `\textcolor{gray}{...}`. **No standalone transition frames.**

## 8. Standard errors mostly to backup

Default: magnitudes on main slides, SEs in backup. Exceptions where SE is the punchline:
- Precision results ("rules out declines > 3%")
- OLS-vs-2SLS comparisons
- Forest plots

Format inline as `(SE 4.6)`.

## 9. Appendix link pills

At the bottom-left of every main slide with backup material:

```latex
\bottomleft{
  \hyperlink{summary_stats}{\beamergotobutton{Summary stats}}
  \hyperlink{coverage}{\beamergotobutton{Coverage plot}}
}
```

`\beamerbutton` and `\beamergotobutton` both work; pick one per deck. Every backup frame gets a `\label{name}` matching its pill.

## 10. Diagrams over prose

When structure can be shown (`X → Computer → Y`), prefer the diagram. TikZ; clean and large; clarity over flair.

## 11. Numbered list pattern

Bold/colored keyword first, black continuation:

```
1. \alert{Diagnose} the problem.
2. \alert{Predict} what will resolve it.
3. \alert{Recognize} what gets people yelled at.
```

## 12. Page numbers

Subtle `X / N` at bottom-right. No section numbering. Consistent across main + backup.

## 13. Format budgets

| Format | Main | Backup |
|---|---|---|
| 30-min seminar (no preview) | 25–32, cap 35 | 10–15 |
| Job market / 45–60 min (with preview) | 40–50 | 15–20 |

See `structure.md` for the per-block sequence.

## 14. Don't

- Bold-then-colon as a sub-header — use `\textcolor{raspberry}{...}:` instead.
- `Notes:` lines on main slides (notes belong on backup slides via `\parbox{...}{\justifying \tiny \textit{...}}`).
- Standalone "Section X:" transition frames.
- Inline `\citet{}` parenthetical citations — bundle related references inside one `\xsmallcitecolor{\citet{a, b, c}}` at the end of the bullet, or omit.
- Citations on the first 1–2 hook slides — the opening should read as a question, not a literature review. Citations begin at the literature-positioning slide.
- Whole sentences in bullets.
- New emphasis colors mid-deck without a reason.
- Footnotes on main slides.

## 15. Preamble and palette

```latex
\documentclass[aspectratio=169,t,11pt,table]{beamer}
\usepackage{slides,math}
\graphicspath{{../}}
\definecolor{accent}{HTML}{940034}   % red, bound to \alert
\definecolor{accent2}{HTML}{006896}  % blue, bound to frame titles
\title{...}
\author{...}
\institute{Microsoft Research \& MIT \\ TASKS VII: The Economic Impacts of AI on Work}
\date{September 2025}
\begin{document}
\begin{frame}[noframenumbering,plain]\maketitle\end{frame}
% ...
\appendix
% backup frames after \appendix
```

`\institute{... \\ ...}` puts the conference name on a second line. `[noframenumbering,plain]` suppresses the page number on the title slide.

`\appendix` marker comes before backup slides. Backup section divider can be `\begin{frame}[allowframebreaks,noframenumbering]{Appendix}` (lets a content-heavy backup index span multiple pages).

Named colors in `slides.sty`: `accent`, `accent2`, `raspberry`, `cranberry`, `teal`, `digitalblue`, `accentblue`, `purple`, `daisy`, `asher`, `gray`, `trueblue`.

## 16. LaTeX shortcuts and spacing

**Lists (from `slides.sty`):** `\bi/\ei` for itemize, `\be/\ee` for enumerate.

**Spacing:** prefer named macros over numeric `\vspace`.

| Macro | Use for |
|---|---|
| `\smallskip` | Between bullets in a group |
| `\medskip` | Between distinct bullet groups |
| `\bigskip` | Between major content blocks |
| `\vspace{-Xmm}` | Layout claw-back only (frame-top tightening, equation gaps) |

**Citations:** `\xsmallcitecolor{\citet{...}}` (small, gray).

**Co-author line:** use the optional second arg of `\frame{}{}`:
```latex
\begin{frame}{A paper: Generative AI at Work}{Joint work with Erik Brynjolfsson and Danielle Li}
```

**Manual layout:** `\hspace{-Xmm}` between columns and `\vspace{-Xmm}` at frame-top are idiomatic, not hacks.

**Old slide variants:** keep in `\begin{comment}…\end{comment}`; do not delete.

## 17. Lecture decks (relaxations)

Lecture decks (teaching contexts) intentionally relax most of the seminar rules. Reference: `slides/examples/slides_PredictionPolicyWithATwist_lecture_2025-03.tex`. Key differences:

| Seminar rule | Lecture relaxation |
|---|---|
| ≤ 4 bullets per slide | 5–8 bullets acceptable; nesting can go three levels deep |
| Declarative finding titles | Topic titles ("Quality results", "IV validity") are fine |
| Two-color comparisons reserved for specific patterns | Color is more freely used inside equations (e.g., `\textcolor{red}{Bonus}(X)`) |
| `\alert{}` only for inline emphasis | `\alert{}` doubles as a paragraph-level sub-header — wrap a phrase, then put bullets underneath |
| `\xsmallcitecolor{\citet{...}}` for refs | Bare in-text citations like `(Hirano, Imbens, Ritter, 2003)` are fine |
| Bottom-left appendix pills | Often omitted; backup material is inline or absent |
| `\appendix` marker | Often omitted |
| Conclusion: structured findings + email | A single image is acceptable as a conclusion |

**Mixed frame syntax allowed.** Lecture decks freely mix `\frame{...}` (older, compact) with `\begin{frame}...\end{frame}` (standard). `\frame[label=...]{}` works on both.

**`\pause` is the primary build mechanism in lecture decks** — heavier use than seminar decks because the pacing matches the lecturer talking through each bullet.

The structural template (12 blocks) does not apply to lectures. A lecture flows linearly from setup → method → results → conclusion without the formalism of agenda-shows, robustness checklists, or appendix-link infrastructure.

---

## Pre-flight checklist

- [ ] Declarative titles throughout
- [ ] ≤ 4 main bullets per slide
- [ ] Builds inside one frame (no duplicated frames)
- [ ] Equations walk through term-by-term
- [ ] Agenda re-shown at each section transition; no standalone section frames
- [ ] Appendix-link pills on every main slide with backup; backup frames carry `\label{}`
- [ ] SEs in backup unless they are the punchline
- [ ] Color roles consistent: blue title, `\alert{}` inline, raspberry/teal/digitalblue category, gray de-emphasis
- [ ] `\bi/\ei`, `\be/\ee`, `\smallskip`/`\medskip`/`\bigskip` used
- [ ] Figures large, captions minimal
- [ ] Slide count fits format budget (Section 13)
