---
name: learn
description: >-
  Extracts reusable knowledge from the current session into a persistent skill.
  Use when discovering something non-obvious, creating a workaround, or developing
  a multi-step workflow that future sessions would benefit from. Triggers on:
  "learn this", "save this as a skill", "extract a skill".
argument-hint: "[skill-name (kebab-case)]"
allowed-tools: ["Read", "Write", "Edit", "Grep", "Glob", "Bash", "Task"]
---

# /learn — Skill Extraction Workflow

Extract non-obvious discoveries into reusable skills that persist across sessions.

## When to Use This Skill

Invoke `/learn` when you encounter:

- **Non-obvious debugging** — investigation that took significant effort, not in docs
- **Misleading errors** — error message was wrong, found the real cause
- **Workarounds** — found a limitation with a creative solution
- **Tool integration** — undocumented API usage or configuration
- **Trial-and-error** — multiple attempts before success
- **Repeatable workflows** — multi-step task you'd do again

## Workflow Phases

### PHASE 1: Evaluate (Self-Assessment)

Before creating a skill, answer:
1. "What did I just learn that wasn't obvious before starting?"
2. "Would future-me benefit from this being documented?"
3. "Was the solution non-obvious from documentation alone?"
4. "Is this a multi-step workflow I'd repeat?"

**Continue only if YES to at least one question.**

### PHASE 2: Check Existing Skills

Search for related skills to avoid duplication:
- Check `.claude/skills/` for existing skills with similar names or triggers
- If same trigger & fix exists, update the existing skill instead

### PHASE 3: Create Skill

Create the skill file at `.claude/skills/[skill-name]/SKILL.md` following the standard frontmatter format (name, description with trigger phrases, argument-hint, allowed-tools).

Include: problem description, trigger conditions, step-by-step solution, verification steps, and a concrete example.

### PHASE 4: Quality Gates

Before finalizing, verify:
- [ ] Description has specific trigger conditions
- [ ] Solution was verified to work
- [ ] Content is specific enough to be actionable
- [ ] Content is general enough to be reusable
- [ ] Skill name is descriptive and uses kebab-case

## Output

After creating the skill, report the skill path, trigger conditions, and what problem it solves.
