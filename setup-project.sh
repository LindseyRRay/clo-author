#!/usr/bin/env bash
# setup-project.sh — Bootstrap an existing project to use clo-author infrastructure.
#
# Usage:
#   ./setup-project.sh /path/to/project "Project Name" "Institution"
#
# What it does:
#   1. Symlinks .claude/ from clo-author into the target project
#   2. Copies and customizes CLAUDE.md with project name and institution
#   3. Copies the templates/ directory
#   4. Creates quality_reports/ subdirectories
#
# Improvements to clo-author's .claude/ propagate automatically via the symlink.

set -euo pipefail

# --- Resolve clo-author root (directory containing this script) ---
CLO_AUTHOR_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Usage ---
usage() {
    echo "Usage: $0 <target-directory> <project-name> <institution>"
    echo ""
    echo "Arguments:"
    echo "  target-directory   Path to the existing project to bootstrap"
    echo "  project-name       Name for the project (substituted into CLAUDE.md)"
    echo "  institution        Institution name (substituted into CLAUDE.md)"
    echo ""
    echo "Example:"
    echo "  $0 ~/Research/my-paper \"Returns to Education\" \"MIT\""
    exit 1
}

# --- Validate inputs ---
if [[ $# -ne 3 ]]; then
    usage
fi

TARGET_DIR="$1"
PROJECT_NAME="$2"
INSTITUTION="$3"

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Target directory does not exist: $TARGET_DIR"
    exit 1
fi

# Resolve to absolute path
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

if [[ ! -d "$CLO_AUTHOR_DIR/.claude" ]]; then
    echo "Error: clo-author .claude/ directory not found at: $CLO_AUTHOR_DIR/.claude"
    exit 1
fi

if [[ ! -f "$CLO_AUTHOR_DIR/CLAUDE.md" ]]; then
    echo "Error: clo-author CLAUDE.md not found at: $CLO_AUTHOR_DIR/CLAUDE.md"
    exit 1
fi

echo "Setting up project: $PROJECT_NAME"
echo "  Target:      $TARGET_DIR"
echo "  Institution: $INSTITUTION"
echo "  clo-author:  $CLO_AUTHOR_DIR"
echo ""

# --- Step 1: Symlink .claude/ ---
if [[ -e "$TARGET_DIR/.claude" ]]; then
    if [[ -L "$TARGET_DIR/.claude" ]]; then
        EXISTING_LINK="$(readlink "$TARGET_DIR/.claude")"
        echo "[skip] .claude/ already symlinked -> $EXISTING_LINK"
    else
        echo "[skip] .claude/ already exists (not a symlink). Remove it manually to re-link."
    fi
else
    ln -s "$CLO_AUTHOR_DIR/.claude" "$TARGET_DIR/.claude"
    echo "[done] Symlinked .claude/ -> $CLO_AUTHOR_DIR/.claude"
fi

# --- Step 2: Copy and customize CLAUDE.md ---
if [[ -f "$TARGET_DIR/CLAUDE.md" ]]; then
    BACKUP="$TARGET_DIR/CLAUDE.md.backup"
    cp "$TARGET_DIR/CLAUDE.md" "$BACKUP"
    echo "[info] Existing CLAUDE.md backed up to CLAUDE.md.backup"
fi

sed \
    -e "s/\[YOUR PROJECT NAME\]/$PROJECT_NAME/g" \
    -e "s/\[YOUR INSTITUTION\]/$INSTITUTION/g" \
    -e "s/\[YOUR-PROJECT\]/$(basename "$TARGET_DIR")/g" \
    "$CLO_AUTHOR_DIR/CLAUDE.md" > "$TARGET_DIR/CLAUDE.md"
echo "[done] CLAUDE.md copied and customized"

# --- Step 3: Copy templates/ ---
if [[ -d "$TARGET_DIR/templates" ]]; then
    echo "[skip] templates/ already exists"
else
    cp -r "$CLO_AUTHOR_DIR/templates" "$TARGET_DIR/templates"
    echo "[done] Copied templates/"
fi

# --- Step 4: Create quality_reports/ subdirectories ---
DIRS=(
    "quality_reports/plans"
    "quality_reports/session_logs"
    "quality_reports/specs"
    "quality_reports/strategy"
    "quality_reports/merges"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$TARGET_DIR/$dir"
done
echo "[done] Created quality_reports/ subdirectories"

# --- Summary ---
echo ""
echo "Setup complete. Next steps:"
echo ""
echo "  1. Review $TARGET_DIR/CLAUDE.md"
echo "     - Fill in [EMPIRICS_ROOT] path if data lives outside the repo"
echo "     - Update the Folder Structure section to match your project"
echo "     - Fill in Beamer Custom Environments if you use talks"
echo "     - Update Current Project State table"
echo "     - Set the Branch field (default: main)"
echo ""
echo "  2. Fill in .claude/rules/domain-profile.md"
echo "     - Target journals, common data sources, identification strategies"
echo "     - Field conventions and notation"
echo "     - Or run /interview-me to generate it interactively"
echo ""
echo "  3. Verify the symlink:"
echo "     ls -la $TARGET_DIR/.claude"
echo ""
echo "  4. Add to .gitignore (if not already):"
echo "     .claude/state/"
echo "     .claude/settings.local.json"
