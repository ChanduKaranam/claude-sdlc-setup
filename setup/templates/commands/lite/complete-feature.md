---
name: complete-feature
description: Run the pre-merge checklist and open a PR for a completed feature.
---

You are completing feature: **$ARGUMENTS**

## Pre-Merge Checklist

- [ ] `{{TEST_CMD}}` — all tests pass
- [ ] `{{LINT_CMD}}` — zero lint errors
- [ ] `{{TYPECHECK_CMD}}` — zero type errors
- [ ] No hardcoded secrets
- [ ] `code-reviewer` agent invoked, all BLOCK issues resolved
- [ ] STATE.md status updated to READY_FOR_REVIEW

When all items pass:

```bash
git push -u origin feature/$ARGUMENTS
gh pr create \
  --base {{PR_TARGET_BRANCH}} \
  --head feature/$ARGUMENTS \
  --title "feat($ARGUMENTS): {one-line summary}" \
  --body "$(cat <<'EOF'
## Summary
{2-4 bullets}

## Test plan
{checklist from ticket}
EOF
)"
```

Print the PR URL.
