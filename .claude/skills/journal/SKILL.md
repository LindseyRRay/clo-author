---
name: journal
description: >-
  Regenerates the research journal timeline from quality reports and git history.
  Shows chronological record of all agent actions, phase transitions, scores,
  and decisions. Triggers on: "show the journal", "research timeline",
  "project history", "audit trail".
argument-hint: "[optional: 'full' for complete history, 'recent' for last 7 days]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# Research Journal

Regenerate the research journal timeline from project artifacts.

**Input:** `$ARGUMENTS` — `full` for complete history, `recent` for last 7 days. Defaults to `recent`.

**Existing journal:** !`test -f quality_reports/research_journal.md && echo "found" || echo "not found"`
**Recent reports:** !`ls -t quality_reports/*.md 2>/dev/null | head -5`
**Recent commits:** !`git log --oneline -5 2>/dev/null`

---

## Workflow

### Step 1: Gather Sources

1. Read `quality_reports/research_journal.md` if it exists
2. Scan `quality_reports/` for all reports (reviews, audits, specs)
3. Read `git log --oneline -50` for commit history
4. Read `SESSION_REPORT.md` for session summaries
5. Read `quality_reports/session_logs/` for detailed session logs

### Step 2: Build Timeline

For each event, extract: date/time, agent, phase (Discovery / Strategy / Execution / Peer Review / Submission), action, target file, score, and verdict.

### Step 3: Present Timeline

Present chronological timeline with phase summary, score trajectory across components, escalation history, and key decisions.

---

## Principles

- **Read-only.** This skill only reads and synthesizes — it never modifies project files.
- **Chronological.** Events ordered by time, not by agent or phase.
- **Audit trail.** This is the evidence that the research process was systematic.
- **Score trajectory.** Show how quality improved over iterations.
