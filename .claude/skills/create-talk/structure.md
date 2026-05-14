# Slide Deck Structure

**Loaded on-demand by the `create-talk` skill.** Not an always-loaded rule.

**Scope.** This template is for **seminar, conference, and job-market decks**. Lecture decks (teaching) follow a much looser structure — see the final section.

**Reference decks:**
- Seminar / conference: `slides/examples/slides_GenerativeAIAtWork_seminar_2025-09.{tex,pdf}`, `slides/examples/slides_MarketEffectsOfAlgorithms_seminar_2025-02.{tex,pdf}`
- Lecture: `slides/examples/slides_PredictionPolicyWithATwist_lecture_2025-03.tex`

Companion: `style.md` (style and LaTeX). Skeleton: `template.tex`. This doc covers structure — which slides, in what order.

## The 12-block template

Slide counts for a 30-min seminar (no preview-of-findings).

| # | Block | Slides | Purpose |
|---|---|---|---|
| 1 | Title | 1 | Cover |
| 2 | Hook / framing | 2–4 | Field-level puzzle, no paper-specific machinery |
| 3 | Paper introduction | 1–2 | Questions → setting → answers (in builds) |
| 4 | Literature positioning | 1 | "Optimism and apprehension" — two strands |
| 5 | Agenda | 1 | First show |
| 6 | Setting | 3–5 | Why this setting; concrete examples; ML framing |
| 7 | Data | 1–2 | Sample, levels, outcomes |
| 8 | Empirical strategy | 1–3 | Visual + equation walkthrough |
| 9 | Findings (first half) | 4–8 | One declarative-title slide per finding |
| 10 | Conceptual framework | 2–3 | Mid-deck, AFTER first findings |
| 11 | Findings (second half) | 4–6 | Sub-findings + heterogeneity |
| 12 | Robustness | 2–4 | Checklist re-show pattern (3+ challenges) or direct deep-dive (1–2) |
|   | Conclusion | 1–2 | Takeaways + thank-you, email in raspberry |
|   | Backup | 8–15 | Tables, alt specs |

Total: 25–32 main + 10–15 backup. Long-talk variant (45–60 min): 40–50 main + 15–20 backup, with a Preview-of-findings slide between Block 3 and the agenda.

## Block-by-block

### 1. Title
`\maketitle` with title, author, affiliation, date.

### 2. Hook / framing
Field-level puzzle, not paper-specific. Two patterns work:
- **Multi-slide build** (e.g., GenAI: "old computers" → "ML" → "optimism/apprehension")
- **Single big-build** (e.g., Market Effects: 8–9 builds inside one frame)

No setting names, sample sizes, or findings here. **No citations on the first 1–2 hook slides** — citations enter only when the literature-positioning slide appears (Block 4) or when establishing the empirical setting (Block 6+). The opening should read as a question the audience cares about, not a literature review.

### 3. Paper introduction
One slide, three builds:

| Build | Content |
|---|---|
| 1 | 3–4 numbered questions the paper answers |
| 2 | Adds `\textcolor{teal}{Setting/Technology/Empirical design}` lines |
| 3 | Each question gets its answer in `\only<3>{\alert{...}}` |

Co-author line via second arg of `\frame{}{}`. Long talks: follow with a separate Preview-of-findings slide.

### 4. Literature positioning
Single slide: `[Topic]: optimism and apprehension`. Two strands as builds; key references bundled per bullet in `\xsmallcitecolor{\citet{a, b, c}}`. Final build: "This paper:" block naming the gap. **Only literature slide in the deck.**

**Placement is flexible.** Two valid positions:
- **Inside the hook block** (GenAI deck): the "optimism/apprehension" framing is one of the conceptual setup slides, before "A paper".
- **After the paper introduction** (Market Effects deck): hook → paper intro → literature positioning → agenda.

Pick whichever fits the narrative flow. The hook-block placement works when the literature debate IS the puzzle; the after-paper placement works when the literature is positioning the paper's specific contribution.

### 5. Agenda
4–6 numbered sections with sub-bullets. Plain — no builds. The only fully-formed agenda; later re-shows gray completed sections.

### 6. Setting
Three-slide pattern:

1. **Why this setting?** — 2–3 reasons.
2. **Concrete example** — screenshot, photo, or quote. Use `\begin{quotation}...\end{quotation}` with citation underneath in raspberry/blue when the example is an interviewee quote.
3. **Why is X an ML/prediction problem?** — 3 reasons each describing the prediction structure. **This slide is specific to ML/algorithms papers.** For non-ML papers, replace with "Why is X a [methodology] problem?" or omit.

Add a fourth slide on the AI tool / treatment object when it's a specific deployed system.

**Setting can come before paper introduction.** Market Effects compresses one setting slide ("Housing as a setting") into the hook block, before "This paper". Order then becomes: hook → 1 setting slide → paper intro → literature → agenda → remaining setting slides. Either placement is valid.

### 7. Data
One slide with three labeled blocks: `Sample` / `<Unit>-level information` / outcome variables. Bottom-left appendix pills (`Summary stats`, `Balance table`). A second validation slide is optional for non-trivial linkage.

### 8. Empirical strategy
**Two-slide pattern (more common):** visual first (rollout figure + sidebar bullets on constraints) → equation walkthrough (4–5 builds with `\textcolor{raspberry}{\underbrace{\bm{...}}_{...}}`).

**One-slide pattern:** when visual + equation can share a frame without crowding (small chart + one-line equation, simple natural experiment, tight budget).

**Multi-slide expansion:** triple-difference / structurally-instrumented specifications get one slide per equation tier.

### 9. Findings (first half)
Re-show agenda first. Each finding: one frame with builds inside.

| Element | Detail |
|---|---|
| Title | The finding, declaratively |
| Body | Large figure, built panel-by-panel or with progressive CIs |
| Sidebar (optional) | Magnitude or sample bullets |
| Bottom-left pills | Backup tables |

An "alternative specifications" slide ("Similar results across estimators") commonly follows the headline finding.

### 10. Conceptual framework — mid-deck
**After the first finding establishes the phenomenon, not before.** The framework explains why; subsequent findings test its predictions.

Two-color comparison framing, 2–3 builds:

| Build | Content |
|---|---|
| 1 | Two columns with `\textcolor{accentblue}{...}` + `\textcolor{raspberry}{...}` rule lines; one bullet defining each entity |
| 2 | Adds parallel prediction/decision-rule equations |
| 3 | Single "difference" equation combining both sides |

Common applications: human vs algorithm; treatment vs control "ideal experiment"; old vs new computers.

### 11. Findings (second half)
Re-show agenda first. Same template as Block 9; these slides test framework predictions rather than establish the headline.

### 12. Robustness
**3+ challenges → checklist re-show pattern.** "Assessing the empirical strategy" frame appears 3+ times with progressive graying:

| Slide | Content |
|---|---|
| 12a | Challenges list, all live |
| 12b | Deep dive on Challenge 1 |
| 12c (re-show) | Challenge 1 grayed, Challenge 2 active |
| 12d | Deep dive on Challenge 2 |
| ... | ... |

**1–2 challenges → direct deep-dive.** Skip the re-shows; go to the answer slide(s) directly.

### 13. Conclusion / Thank you
Standard structure on a single slide:

```
\textbf{When [trigger condition]:}
\begin{enumerate}
  \item [Finding 1]
  \item [Finding 2]
  \item [Finding 3]
\end{enumerate}
\alert{[So-what claim]:}
\begin{enumerate}
  \item [Implication 1]
  \item [Implication 2]
\end{enumerate}
\textcolor{raspberry}{email@institution.edu}
```

The "When [trigger]" framing mirrors the paper's research question; the `\alert{}`-d so-what claim is the one-line takeaway; the email closes. Acceptable variant: split into a "Takeaways" slide + a "Thank you" slide. Email always in `\textcolor{raspberry}{...}`.

### 14. Backup
After the conclusion, an `\appendix` marker. Optionally a divider frame:

```latex
\appendix
\begin{frame}[allowframebreaks,noframenumbering]{Appendix}\end{frame}
```

Each backup frame:
- `\label{name}` (kebab_case) matching the pill's `\hyperlink{name}{...}`
- Single content (no builds)
- `\parbox{0.8\textwidth}{\justifying \tiny \textit{Note: ...}}` for methodology notes under figures/tables
- `\beamergotobutton{Back}` linking to the originating slide; multiple back-buttons when linked from multiple main slides

Common contents: summary stats, balance, first-stage, OLS-vs-IV, window robustness, alternative estimators, sample funnel, complier characteristics, simulations, validation.

## Cross-cutting rules

- **a. Depth-first.** Finding 1 → mechanism → robustness → sub-findings, *then* Finding 2. No preview for 30-min talks.
- **b. Framework mid-deck.** Place after the first finding; never as an upfront "Theory" block.
- **c. Empirical strategy: visual first.** When two slides, never the equation alone.
- **d. Robustness checklist when 3+ challenges.** Re-show with progressive graying. Each re-show is a real `\begin{frame}`, not internal builds.
- **e. Findings titles are declarative.** Title carries the takeaway; body shows evidence.
- **f. Figure builds mirror argument builds.** Reveal panels in the order the speaker discusses them.
- **g. Two-color comparisons reserved.** Treatment vs control; human vs algorithm; old vs new. Not for ad-hoc emphasis.
- **h. Typically absent.** "Literature review", "Contribution", "Limitations", "Future work", "Identification" as standalone slides — descriptive, not prescriptive. Add when the audience or context requires it (job-market talks, methodological contributions, top-five submissions, involved identification arguments).

## Lecture decks (different format)

Lecture decks (e.g., `slides/examples/slides_PredictionPolicyWithATwist_lecture_2025-03.tex`) are linear and structurally minimal. They typically:

- **Open** with a single content slide titled with the paper name, using the `\frame{}{Joint with ...}` second-arg subtitle for the joint-work line. No separate hook block; the paper context appears in the first content slide.
- **Skip** the agenda, literature-positioning, and section-divider re-shows entirely.
- **Replace** the setting block's "Why is X an ML problem?" pattern with a more direct exposition of the problem (e.g., "Supervised learning algorithms play an important role in hiring" → "Supervised learning and algorithmic bias" → "We propose a new approach").
- **Spend more slides on math** — UCB derivations, IPW estimators, IV validity get full slides each.
- **Skip robustness checklists** — drill into specific results sequentially.
- **End** on a single image (e.g., a Pareto frontier plot) with no email or thank-you.

A lecture flow is: hook concept → motivation → method → derivation slides → results → drill-down results → closing image. There is no fixed block count and no canonical ordering — match the lesson's pedagogical sequence.

When building a lecture deck, follow `style.md` Section 17 (lecture relaxations) and ignore most of this structure document.

## Worked example — generic IV paper

| # | Slide title | Purpose |
|---|---|---|
| 1 | [Paper title] | Cover |
| 2–3 | [Field-level puzzle / "Two empirical challenges"] | Hook |
| 4 | A paper: [Title] | Paper introduction (3 builds) |
| 5 | [Topic]: optimism and apprehension | Literature |
| 6 | Agenda | Structure |
| 7 | Why setting S? | Setting |
| 8 | [Screenshot / quote] | Setting |
| 9 | Why is S a prediction problem? | Setting |
| 10 | Our data | Data |
| 11 | Empirical strategy: [natural experiment] | Strategy visual |
| 12 | Empirical strategy: [equation walkthrough] | Strategy equation |
| 13 | Agenda re-show — Section 1 bolded | Transition |
| 14 | [Headline finding] | Finding 1 |
| 15 | Similar results across estimators | Robustness for Finding 1 |
| 16 | Agenda re-show — Section 2 | Transition |
| 17 | [Conceptual framework] | Framework |
| 18–19 | [Sub-findings] | Findings 2–3 |
| 20 | Agenda re-show — Section 3 | Transition |
| 21 | [Heterogeneity finding] | Finding 4 |
| 22–27 | "Assessing the empirical strategy" (3 challenges, alternating with deep dives) | Robustness |
| 28 | Takeaways | Conclusion |
| 29 | Thank you | Closing |
| 30+ | Backup | Tables, alt specs |

Adjust within-block slide counts to match the paper; keep block ordering and within-block patterns.
