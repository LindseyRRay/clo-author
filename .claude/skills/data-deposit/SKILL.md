---
name: data-deposit
description: >-
  Prepares an AEA Data Editor compliant replication package by dispatching the
  Coder agent for assembly and Verifier agent for validation. Generates README,
  main runner script, numbered script order, and deposit checklist. Triggers on:
  "prepare replication package", "data deposit", "AEA package".
argument-hint: "[paper title or package directory (optional)]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Data Deposit Preparation

Prepare an AEA Data Editor compliant replication package by dispatching the **Coder** (assembly) and **Verifier** (validation).

**Input:** `$ARGUMENTS` — paper title or package directory (optional).

**Existing scripts:** !`find src/ -name "*.py" -o -name "*.do" 2>/dev/null | sort`
**Replication dir:** !`ls Replication/ 2>/dev/null | head -10`
**Config:** !`test -f config.py && echo "config.py found" || echo "no config.py"`
**Paper:** !`ls Paper/main.tex 2>/dev/null && echo "found" || echo "not found"`

---

## Pre-Flight Check

If `Replication/` does not exist, create it.

If no scripts exist in `src/`, STOP and ask the user where the analysis scripts are.

---

## Workflow

### Step 1: Inventory

1. Read all scripts in `src/` (`.py` and `.do` files)
2. Parse data file references (`pd.read_csv`, `pd.read_parquet`, `read_dta`, `use`, `import delimited`, etc.)
3. Read existing README in `Replication/` if any
4. Read paper (`Paper/main.tex`) for table/figure list
5. Scan `Output/Tables/` and `Output/Figures/` for output files
6. Read `config.py` for DATA_PATH and output directory conventions

### Step 2: Dispatch Coder for Package Assembly

Delegate to the `coder` agent:

```
Prompt: Assemble replication package.
1. Analyze script dependencies (which scripts create files others load?)
2. Propose sequential numbering: 01_clean_data.py, 02_summary_stats.py, etc.
   (or 01_clean_data.do for Stata scripts)
3. Draft README.md in AEA format (data availability, computational requirements,
   program descriptions, replication instructions)
4. Generate main.py (or main.do if Stata-primary) that runs everything in order
5. Generate requirements.txt (Python) or document Stata ado dependencies
6. Generate DEPOSIT_CHECKLIST.md
Present script order to user for approval before renaming.
Save all to Replication/
```

### Step 3: Validate with Verifier

After package assembly, dispatch the **Verifier** in submission mode:

```
Prompt: Audit the replication package at Replication/.
Mode: Submission (checks 1-10).
This is a fresh package — focus on completeness and executability.
Save report to quality_reports/YYYY-MM-DD_replication_audit.md
```

This is equivalent to running `/audit-replication Replication/`.

### Step 4: Fix Issues

If Verifier finds failures:
1. Re-dispatch Coder with specific fixes (max 3 rounds)
2. Re-run Verifier to verify

### Step 5: Present Results

1. **Package contents** — all files in `Replication/`
2. **Script order** — numbered sequence with dependency graph
3. **README preview** — key sections
4. **Verification result** — X/10 checks passed
5. **Deposit checklist** — openICPSR / Zenodo steps

---

## Key Outputs

| File | Description |
|------|-------------|
| `Replication/README.md` | AEA-format data and code availability statement |
| `Replication/main.py` | Runs all scripts in order (or `main.do` for Stata) |
| `Replication/requirements.txt` | Python dependencies (or ado list for Stata) |
| `Replication/DEPOSIT_CHECKLIST.md` | Pre-deposit verification checklist |

---

## Principles

- **AEA Data Editor standards are the target.** README format, versions, data access.
- **Present ordering before renaming.** Get user approval on script numbering first.
- **Thorough data provenance.** Every dataset documented with source and access instructions.
- **Test before declaring ready.** Always run `/audit-replication` after assembly.
- **Coder assembles, Verifier validates.** The Verifier is mandatory after assembly.
