---
name: validate-bib
description: >-
  Validates bibliography entries against citations in paper and talk files.
  Finds missing entries, unused references, and potential typos. Triggers on:
  "validate bib", "check citations", "cross-reference bibliography".
argument-hint: "[bib file path (optional)]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Validate Bibliography

Cross-reference all citations in paper and talk files against bibliography entries.

**Input:** `$ARGUMENTS` — path to `.bib` file (optional, defaults to `Bibliography_base.bib`).

**Bibliography:** !`test -f Bibliography_base.bib && wc -l < Bibliography_base.bib || echo "not found"`
**Paper files:** !`ls Paper/main.tex Paper/sections/*.tex 2>/dev/null | head -5`
**Talk files:** !`ls Slides/*.tex 2>/dev/null | head -3`

---

## Steps

1. **Read the bibliography file** and extract all citation keys

2. **Scan all paper and talk files for citation keys:**
   - `Paper/main.tex` and `Paper/sections/*.tex`
   - `Slides/*.tex`
   - Look for `\cite{`, `\citet{`, `\citep{`, `\citeauthor{`, `\citeyear{`
   - Extract all unique citation keys used

3. **Cross-reference:**
   - **Missing entries:** Citations used in papers/talks but NOT in bibliography
   - **Unused entries:** Entries in bibliography not cited anywhere
   - **Potential typos:** Similar-but-not-matching keys

4. **Check entry quality** for each bib entry:
   - Required fields present (author, title, year, journal/booktitle)
   - Author field properly formatted
   - Year is reasonable
   - No malformed characters or encoding issues

5. **Report findings:**
   - List of missing bibliography entries (CRITICAL)
   - List of unused entries (informational)
   - List of potential typos in citation keys
   - List of quality issues

## Files to scan:
```
Paper/main.tex
Paper/sections/*.tex
Slides/*.tex
```

## Bibliography location:
```
Bibliography_base.bib  (repo root)
```
