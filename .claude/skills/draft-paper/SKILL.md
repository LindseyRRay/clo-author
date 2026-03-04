---
name: draft-paper
description: >-
  Drafts academic economics paper sections by dispatching the Writer agent
  and Proofreader agent (critic). Handles section routing, notation protocol,
  anti-hedging, and automatic humanizer pass. Triggers on: "draft the paper",
  "write up the results", "write the intro", "write the empirical strategy".
argument-hint: "[section: intro | empirical-strategy | data | lit-review | results | conclusion | abstract | full] [paper path (optional)]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Draft Paper

Draft an academic economics paper (or specific section) by dispatching the **Writer** agent, then the **Proofreader** agent for scoring.

**Input:** `$ARGUMENTS` — section name optionally followed by a paper path.

**Existing paper:** !`find Paper/ -name "*.tex" 2>/dev/null | head -5`
**Existing sections:** !`find Paper/sections/ -name "*.tex" 2>/dev/null | head -10`
**Available tables:** !`find Output/Tables/ -name "*.tex" 2>/dev/null | head -10`
**Available figures:** !`find Output/Figures/ \( -name "*.pdf" -o -name "*.png" \) 2>/dev/null | head -10`
**Strategy memo:** !`ls -t quality_reports/*.md 2>/dev/null | grep -m1 -E 'strategy|spec|memo'`

---

## Workflow

### Step 1: Section Routing

Based on `$ARGUMENTS`:
- **`full`**: Draft all sections in sequence. Pause after intro (contribution approval), after empirical-strategy (identification confirm), and after results.
- **`intro`**: Draft introduction
- **`empirical-strategy`**: Draft identification and estimation section
- **`data`**: Draft data description section
- **`lit-review`**: Draft literature review (requires Librarian output)
- **`results`**: Draft results from available output
- **`conclusion`**: Draft conclusion
- **`abstract`**: Draft abstract — verify at least one section exists in `Paper/sections/` first
- **No argument**: Ask user which section to draft

### Step 2: Launch Writer Agent

Delegate to the `writer` agent via Task tool. Include all context in the prompt:

```
Prompt: Draft the [section] section for [paper].

Context to read first:
  - Paper/ for existing draft
  - .claude/rules/domain-profile.md for field conventions
  - Bibliography_base.bib for available citations
  - Output/Tables/ and Output/Figures/ for generated output
  - quality_reports/results_summary.md if it exists (from Coder)
  - Most recent spec in quality_reports/specs/ or plan in quality_reports/plans/

Follow section standards:
  - Introduction: contribution paragraph within first 2 pages, effect sizes stated
  - Empirical strategy: estimating equation displayed and numbered, assumptions explicit
  - Data: sample construction, key variables, summary statistics table reference
  - Results: every estimate with units, magnitudes not just signs
  - Conclusion: restate with effect size, limitations, implications
Apply notation protocol (Y_it, D_it, gamma_i, delta_t, epsilon_it).
Apply anti-hedging rules (ban "interestingly", "it is worth noting", etc.).
Run humanizer pass before finalizing.
Use %TBD: comments for missing results, %VERIFY: for unconfirmed citations.
Save to Paper/sections/[section_name].tex
```

The Writer follows these standards:

#### Introduction (~1,000-1,500 words)
- Hook → research question → what we do → what we find → contribution → road map
- Contribution paragraph names specific papers being advanced
- Effect sizes with magnitudes and units

#### Empirical Strategy (~800-1,200 words)
- Identification assumption stated formally
- Estimating equation displayed and numbered
- Threats to identification addressed

#### Results (~800-1,500 words)
- Main specification with interpretation
- Effect sizes in economic terms
- Heterogeneity and robustness

#### Conclusion (~500-700 words)
- Restate with effect size
- Policy implications
- Limitations and future work

### Step 3: Compile LaTeX

After the Writer saves the section, compile to catch LaTeX errors before the Proofreader reviews:

```bash
cd paper && TEXINPUTS=../preambles:$TEXINPUTS xelatex -interaction=nonstopmode main.tex
```

If compilation fails, fix the LaTeX errors before proceeding.

### Step 4: Launch Proofreader Agent (Critic)

Delegate to the `proofreader` agent via Task tool:

```
Prompt: Review Paper/sections/[section_name].tex through all 6 check categories.
Categories: structure, claims-evidence, identification fidelity, writing quality,
grammar & polish, compilation & LaTeX.
Save report to quality_reports/[section_name]_proofread_report.md
```

If Proofreader score < 80: re-dispatch Writer with specific fixes (max 3 rounds per `three-strikes.md`).

### Step 5: Present to User

Present the draft with:
- **Proofreader score:** XX/100
- **Issues flagged and resolved** during Writer-Proofreader iteration
- **TBD items:** Where empirical results are needed but not yet available
- **VERIFY items:** Citations that need user confirmation

---

## Principles

- **This is the user's paper, not Claude's.** Match their voice and style.
- **Never fabricate results.** Use `%TBD:` LaTeX comments as placeholders.
- **Writer creates, Proofreader scores.** The Writer never self-scores.
