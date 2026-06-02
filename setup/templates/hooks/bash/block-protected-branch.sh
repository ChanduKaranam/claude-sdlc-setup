#!/usr/bin/env bash
# PreToolUse hook: block edits to protected branches.
# Protected branches are defined in {{PROTECTED_BRANCHES}} (pipe-separated).
# Customize by updating the case pattern below after /setup generates this file.
set -e
BRANCH=$(git branch --show-current 2>/dev/null)
case "$BRANCH" in
  {{PROTECTED_BRANCHES_CASE}})
    printf '{"block": true, "message": "Direct edits to %s are blocked. Branch off {{BASE_BRANCH}}: git switch -c feature/your-feature {{BASE_BRANCH}}"}\n' "$BRANCH" >&2
    exit 2
    ;;
esac
exit 0
