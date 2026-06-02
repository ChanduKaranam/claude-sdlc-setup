#!/usr/bin/env bash
# PreToolUse hook: block image writes under docs/.
# UI is spec'd by tickets, not mockups.
set -e
FILE=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.path // .file_path // empty')
if [[ "$FILE" =~ ^docs/.*\.(png|jpg|jpeg|gif|webp|svg|fig)$ ]]; then
  printf '{"block": true, "message": "UI is spec-ed by tickets, not mockups. Image writes under docs/ are blocked. Add the requirement to the ticket file (Behavior + States + Microcopy) instead."}\n' >&2
  exit 2
fi
exit 0
