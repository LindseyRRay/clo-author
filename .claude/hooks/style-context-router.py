#!/usr/bin/env python3
"""
Style Context Router Hook for Claude Code

A UserPromptSubmit hook. Inspects the submitted prompt and, when it looks like
slide work or paper-drafting work, prints a one-line nudge reminding Claude to
load the on-demand style files (which are no longer auto-loaded as rules).

Nudge only — never blocks. Fails open. Stays silent on Stata / Python / git /
data-pipeline prompts so it does not add noise to non-writing turns.

Usage (in .claude/settings.json):
    "UserPromptSubmit": [{ "hooks": [{ "type": "command",
        "command": "python3 \"$CLAUDE_PROJECT_DIR\"/.claude/hooks/style-context-router.py",
        "timeout": 5 }] }]
"""

import json
import re
import sys

# Word-boundary patterns. \b avoids false positives like "dataframe" -> "frame".
SLIDE_PATTERNS = [
    r"\bslides?\b",
    r"\bframe\b",
    r"\bdeck\b",
    r"\bbeamer\b",
    r"\btalk\b",
    r"\bpresentation\b",
]

PAPER_PATTERNS = [
    r"\bdraft\b",
    r"\bhumaniz",  # humanize / humanizer / humanized
    r"\bpaper section\b",
    r"write (?:the |up the |a )?"
    r"(?:intro|introduction|results?|conclusion|abstract|"
    r"lit(?:erature)? review|empirical strategy|data section|paper|section)",
]

SLIDE_NUDGE = (
    "[style-router] This prompt looks like slide work. Before drafting, invoke "
    "the `create-talk` skill — or read `.claude/skills/create-talk/style.md`, "
    "`structure.md`, and `template.tex` for the slide style rules and the "
    "12-block deck template. These are loaded on-demand, not as always-on rules."
)

PAPER_NUDGE = (
    "[style-router] This prompt looks like paper-drafting work. Before drafting, "
    "invoke the `draft-paper` skill — or read `.claude/skills/draft-paper/style.md` "
    "and the relevant `.claude/skills/draft-paper/templates/[section].md` scaffold. "
    "These are loaded on-demand, not as always-on rules."
)


def matches_any(text: str, patterns: list[str]) -> bool:
    """True if any pattern matches the text (case-insensitive)."""
    return any(re.search(p, text, re.IGNORECASE) for p in patterns)


def main() -> None:
    try:
        hook_input = json.load(sys.stdin)
    except (json.JSONDecodeError, EOFError):
        sys.exit(0)

    prompt = hook_input.get("prompt", "")
    if not prompt:
        sys.exit(0)

    nudges = []
    if matches_any(prompt, SLIDE_PATTERNS):
        nudges.append(SLIDE_NUDGE)
    if matches_any(prompt, PAPER_PATTERNS):
        nudges.append(PAPER_NUDGE)

    if nudges:
        # stdout from a UserPromptSubmit hook (exit 0) is added to Claude's context.
        print("\n".join(nudges))

    sys.exit(0)


if __name__ == "__main__":
    try:
        main()
    except Exception:
        # Fail open — never disrupt the user's prompt due to a hook bug.
        sys.exit(0)
