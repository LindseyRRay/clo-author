---
name: find-data
description: >-
  Discovers and assesses datasets by dispatching the Explorer agent (finder)
  and Surveyor agent (critic). Searches public, administrative, survey, and
  novel data sources. Scores feasibility and measurement quality. Triggers on:
  "find data", "what data exists", "data sources for".
argument-hint: "[research question or data requirements description]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task", "WebSearch", "WebFetch"]
---

# Find Data

Discover and assess datasets by dispatching the **Explorer** (data finder) and **Surveyor** (data critic).

**Input:** `$ARGUMENTS` — research question, variable requirements, or description of needed data.

**Strategy memo:** !`ls -t quality_reports/*.md 2>/dev/null | grep -m1 -E 'strategy|spec|memo'`
**Domain profile:** !`test -f .claude/rules/domain-profile.md && echo "found" || echo "not found"`

---

## Workflow

### Step 1: Context Gathering

1. Read research spec if it exists in `quality_reports/specs/`
2. Read strategy memo if it exists in `quality_reports/plans/`
3. Read `.claude/rules/domain-profile.md` for common data sources in the field
4. Understand what variables are needed: treatment, outcome, controls, time period, geography

### Step 2: Launch Explorer Agent

Delegate to the `explorer` agent via Task tool:

```
Prompt: Find datasets for "[research question/requirements]".
Search across source categories:
  1. Public microdata (CPS, ACS, NHIS, MEPS, etc.)
  2. Administrative data (Medicare claims, tax records, court records)
  3. Survey data (RAND HRS, PSID, Add Health, NLSY)
  4. International (World Bank, OECD, Eurostat)
  5. Novel/alternative (satellite imagery, web scraping, proprietary)
For each dataset found:
  - Name, provider, access level (public/restricted)
  - Key variables available
  - Coverage (time period, geography, sample size)
  - Feasibility grade: A (ready to use), B (accessible with effort),
    C (restricted but obtainable), D (very difficult)
  - Strengths and limitations
Save to quality_reports/data_exploration_[topic].md
```

### Step 3: Launch Surveyor Agent (Data Critic)

After Explorer returns, delegate to the `surveyor` agent:

```
Prompt: Review the data assessment at quality_reports/data_exploration_[topic].md.
For each proposed dataset, check:
  1. Measurement validity — does the variable actually measure what we need?
  2. Sample selection — who's in the data? Who's missing?
  3. External validity — can we generalize from this sample?
  4. Identification compatibility — does this data support the proposed design?
  5. Known issues — documented problems with this dataset in the literature
Score each dataset. Flag deal-breakers.
Save critique to quality_reports/data_critique_[topic].md
```

### Step 4: Synthesize Recommendations

After both agents return, present ranked datasets with feasibility grades, Surveyor concerns, access instructions, data gaps, and concrete next steps.

---

## Principles

- **Explorer finds, Surveyor critiques.** Never skip the critique step.
- **Feasibility matters.** A perfect dataset you can't access is useless.
- **Domain-profile aware.** Check common data sources for the field first.
- **Measurement validity is key.** The Surveyor catches "this variable doesn't actually measure what you think."
- **Be honest about limitations.** Every dataset has them — document them upfront.
