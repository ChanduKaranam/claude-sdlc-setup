---
name: dev-deploy
description: Promote {{INTEGRATION_BRANCH}} → {{DEV_BRANCH}}. Opens a PR for review; merge triggers the dev environment deploy.
---

You are promoting {{INTEGRATION_BRANCH}} to the dev environment.

## Step 1 — Gather commits ahead of {{DEV_BRANCH}}

```bash
git fetch origin
git log origin/{{DEV_BRANCH}}..origin/{{INTEGRATION_BRANCH}} --oneline
```

If no commits, abort: "Nothing to promote — {{INTEGRATION_BRANCH}} is already merged into {{DEV_BRANCH}}."

## Step 2 — Open the promotion PR

```bash
gh pr create \
  --base {{DEV_BRANCH}} \
  --head {{INTEGRATION_BRANCH}} \
  --title "chore(deploy): promote {{INTEGRATION_BRANCH}} to {{DEV_BRANCH}} — {date}" \
  --body "$(cat <<'EOF'
## Commits
{one-line-per-commit list from Step 1}

## Checklist
- [ ] All PRs merged to {{INTEGRATION_BRANCH}} have passing CI
- [ ] No open BLOCK issues from code-reviewer
- [ ] Dev environment smoke test after merge
EOF
)"
```

## Step 3 — Report

Print the PR URL. The merge itself is a manual human step.

Note: merging this PR triggers the dev environment deploy pipeline ({{DEV_DEPLOY_TRIGGER}}).

---

## Notes for Claude

- This is advisory CI. Do not merge automatically.
- Direct pushes to {{DEV_BRANCH}} are blocked by the protected-branch hook.
