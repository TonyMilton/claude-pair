#!/usr/bin/env bash
set -euo pipefail

# pair — AI-to-AI pair programming for Claude Code
# Installs the pair programming skills into ~/.claude/skills/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS="$SCRIPT_DIR/.claude/skills"
TARGET_SKILLS="$HOME/.claude/skills"

echo "Installing pair programming skills into: $TARGET_SKILLS"
echo ""

# Validate source files exist
for skill in pair pair-setup driver navigator; do
  if [[ ! -d "$SOURCE_SKILLS/$skill" ]]; then
    echo "Error: Source skill '$skill' not found. Run this script from the pair repository."
    exit 1
  fi
done

# Copy skill files
for skill in pair pair-setup driver navigator; do
  mkdir -p "$TARGET_SKILLS/$skill"
  cp "$SOURCE_SKILLS/$skill/SKILL.md" "$TARGET_SKILLS/$skill/SKILL.md"
  echo "  Copied $skill/SKILL.md"
done

echo ""
echo "Done! In any project, run /pair-setup to enable agent teams, then /pair to start."
echo ""
