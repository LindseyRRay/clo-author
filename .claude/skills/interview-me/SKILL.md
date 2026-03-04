---
name: interview-me
description: >-
  Conducts an interactive research interview to formalize a research idea into
  a structured specification with hypotheses and empirical strategy. Also
  populates the domain profile. Triggers on: "interview me", "help me think
  through my research idea", "start a new project idea".
argument-hint: "[brief topic or 'start fresh']"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Research Interview

Conduct a structured interview to help formalize a research idea into a concrete specification.

**Input:** `$ARGUMENTS` — a brief topic description or "start fresh" for an open-ended exploration.

**Domain profile:** !`test -f .claude/rules/domain-profile.md && echo "found" || echo "not found"`

---

## How This Works

This is a **conversational** skill. Instead of producing a report immediately, you conduct an interview by asking questions one at a time, probing deeper based on answers, and building toward a structured research specification.

**Do NOT use AskUserQuestion.** Ask questions directly in your text responses, one or two at a time. Wait for the user to respond before continuing.

---

## Interview Structure

### Phase 1: The Big Picture (1-2 questions)
- "What phenomenon or puzzle are you trying to understand?"
- "Why does this matter? Who should care about the answer?"

### Phase 2: Theoretical Motivation (1-2 questions)
- "What's your intuition for why X happens / what drives Y?"
- "What would standard theory predict? Do you expect something different?"

### Phase 3: Data and Setting (1-2 questions)
- "What data do you have access to, or what data would you ideally want?"
- "Is there a specific context, time period, or institutional setting you're focused on?"

### Phase 4: Identification (1-2 questions)
- "Is there a natural experiment, policy change, or source of variation you can exploit?"
- "What's the biggest threat to a causal interpretation?"

### Phase 5: Expected Results (1-2 questions)
- "What would you expect to find? What would surprise you?"
- "What would the results imply for policy or theory?"

### Phase 6: Contribution (1 question)
- "How does this differ from what's already been done? What's the gap you're filling?"

---

## After the Interview

Once you have enough information (typically 5-8 exchanges), produce TWO outputs:

### Output 1: Domain Profile

If `.claude/rules/domain-profile.md` still contains placeholders, fill it in based on the interview:
- Field & adjacent subfields
- Target journals (ranked by tier)
- Common data sources
- Common identification strategies
- Field conventions
- Seminal references
- Field-specific referee concerns

Save directly to `.claude/rules/domain-profile.md`. If already filled, confirm with user whether to update.

### Output 2: Research Specification Document

Save to `quality_reports/specs/research_spec_[sanitized_topic].md` with: research question, motivation, hypothesis, empirical strategy (method, treatment, control, identifying assumption, robustness), data (primary dataset, key variables, sample), expected results, contribution, and open questions.

---

## Interview Style

- **Be curious, not prescriptive.** Draw out the researcher's thinking.
- **Probe weak spots gently.** "What would a skeptic say about...?" not "This won't work."
- **Build on answers.** Each question should follow from the previous response.
- **Know when to stop.** If the researcher has a clear vision after 4-5 exchanges, move to the specification.
