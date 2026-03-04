---
name: commit
description: >-
  Stages changes and commits directly to main. Optionally pushes to origin.
  Triggers on: "commit", "save changes", "commit this".
argument-hint: "[optional: commit message]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Commit to Main

Stage changes and commit directly to main with a descriptive message.

**Current state:**
- !`git status --short`
- !`git log --oneline -5`

---

## Steps

### Step 1: Check current state

```bash
git status
git diff
git diff --cached
git log --oneline -5
```

### Step 2: Pre-staging scan

Before staging, scan for sensitive files that must NOT be committed:

- `.claude/settings.local.json`
- `.env`, `credentials.*`, files containing `API_KEY`, `PASSWORD`, `SECRET`
- `.dta` files (large Stata datasets — typically gitignored)

Use `Grep` to check staged candidates for secrets if uncertain.

### Step 3: Stage files

Add specific files (never use `git add -A` or `git add .`):

```bash
git add <file1> <file2> ...
```

### Step 4: Commit

If `$ARGUMENTS` is provided, use it as the commit message. Otherwise, analyze the staged changes and write a message that explains *why*, not just *what*.

```bash
git commit -m "$(cat <<'EOF'
<commit message here>

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

### Step 5: Push (if asked)

Only push if the user explicitly requests it:

```bash
git push origin main
```

### Step 6: Report and log

1. Report what was committed (files, commit hash)
2. Append an entry to `SESSION_REPORT.md` and `.claude/SESSION_REPORT.md` with the commit hash

## Important

- Commit directly to main — no branch/PR unless the user asks for one
- Exclude `settings.local.json`, `.env`, `.dta`, and sensitive files from staging
- If the commit message from `$ARGUMENTS` is provided, use it exactly (still append the Co-Authored-By trailer)
- Never push without explicit user request
