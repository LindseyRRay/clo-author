---
name: audit-replication
description: >-
  Validates a replication package by dispatching the Verifier agent in submission
  mode (checks 1-10). Runs master script, cross-references tables and figures
  against paper, verifies README completeness for AEA Data Editor compliance.
  Triggers on: "audit replication", "check the replication package",
  "verify the deposit".
argument-hint: "[directory path, or 'here' for replication/]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Audit Replication Package

Run end-to-end validation by dispatching the **Verifier** agent in **submission mode** (all 10 checks).

**Input:** `$ARGUMENTS` — directory containing the replication package. Use `here` or no argument for the current project.

**Today:** !`date +%Y-%m-%d`
**Replication dir:** !`ls Replication/ 2>/dev/null | head -10`
**Paper:** !`test -f Paper/main.tex && echo "found" || echo "not found"`

---

## Workflow

### Step 1: Locate Package

- If `$ARGUMENTS` is a directory path: set `PACKAGE_DIR` to that path
- If `$ARGUMENTS` is `here` or empty: set `PACKAGE_DIR` to `Replication/` if it exists, otherwise project root
- Verify `PACKAGE_DIR` exists and contains scripts
- If the directory does not exist or contains no scripts, halt and ask the user to specify a valid path

### Step 2: Launch Verifier Agent (Submission Mode)

Delegate to the `verifier` agent via Task tool:

```
Prompt: Audit the replication package at PACKAGE_DIR.
Mode: Submission (all 10 checks).
Paper location: Paper/main.tex (if exists).

Standard Checks (1-4):
  1. LaTeX compilation
  2. Script execution
  3. File integrity
  4. Output freshness

Submission Checks (5-10):
  5. Package inventory (scripts numbered, master script exists)
  6. Dependency verification (requirements.txt/environment.yml for Python, ado version headers for Stata)
  7. Data provenance (sources documented, no hardcoded paths)
  8. Execution verification (run master script end-to-end)
  9. Output cross-reference (every table/figure traced to script)
  10. README completeness (AEA format)

Save report to quality_reports/replication_audit_YYYY-MM-DD.md
```

### Step 3: Handle Failures

**Execution failures (Check 8):**
1. Display specific error with file and line number
2. Suggest concrete fix
3. Ask user if they want to fix and re-audit (max 3 iterations)

**Non-execution failures (Checks 1-7, 9-10):**
1. Present each failure with specific remediation steps
2. Do not auto-fix — the user decides what to change

### Step 4: Present Results

```markdown
# Replication Audit Report
**Date:** YYYY-MM-DD
**Package:** PACKAGE_DIR
**Mode:** Submission

## Check Results
| # | Check | Status | Details |
|---|-------|--------|---------|
| 1 | LaTeX compilation | PASS/FAIL | |
| 2 | Script execution | PASS/FAIL | |
| 3 | File integrity | PASS/FAIL | |
| 4 | Output freshness | PASS/FAIL | |
| 5 | Package inventory | PASS/FAIL | |
| 6 | Dependencies | PASS/FAIL | |
| 7 | Data provenance | PASS/FAIL | |
| 8 | End-to-end execution | PASS/FAIL | |
| 9 | Output cross-reference | PASS/FAIL | |
| 10 | README completeness | PASS/FAIL | |

## Summary
- Checks passed: N / 10
- **Overall: PASS / FAIL**
- Blocking issues: [list]
- Positive findings: [list]
```

---

## Principles

- **This skill runs code.** It needs Bash access to execute scripts for Check 8.
- **Be patient with runtime.** Set appropriate timeouts for long-running packages.
- **Don't modify the package during audit.** Read and run only.
- **Specific errors.** "Script 03_robustness.py fails at line 47: NameError: name 'treatment_var' is not defined" beats "execution failed."
- **AEA Data Editor standards.** The target is full compliance — README format, documented versions, data provenance.
