---
name: prod-deploy
description: Cut a versioned release by promoting {{DEV_BRANCH}} → {{PROD_BRANCH}}. HARD CI gate — must pass before merge.
---

You are cutting a production release for {{PROJECT_NAME}}.

## Step 1 — Determine version bump

Ask: "What kind of release is this? patch / minor / major"

Current version:
```bash
cat package.json | jq -r '.version' 2>/dev/null || echo "N/A"
```

## Step 2 — Verify CI on {{DEV_BRANCH}}

```bash
gh run list --branch {{DEV_BRANCH}} --limit 1
```

If the latest run is not successful, abort: "CI is not green on {{DEV_BRANCH}}. Fix before deploying to prod."

## Step 3 — Gather commits ahead of {{PROD_BRANCH}}

```bash
git fetch origin
git log origin/{{PROD_BRANCH}}..origin/{{DEV_BRANCH}} --oneline
```

## Step 4 — Open the production PR

```bash
gh pr create \
  --base {{PROD_BRANCH}} \
  --head {{DEV_BRANCH}} \
  --title "chore(release): v{version} — {date}" \
  --body "$(cat <<'EOF'
## Release: v{version}

## Commits
{list from Step 3}

## Post-merge steps
1. Merge this PR
2. Tag the merge commit on {{PROD_BRANCH}}: git tag v{version} && git push origin v{version}
3. (Optional) gh release create v{version} --generate-notes
EOF
)"
```

## Step 5 — Report

Print PR URL. Remind: 4-step post-merge sequence (merge → tag → push tag → gh release).

## Step 6 — After the merge: verify production, do not assume it

**Invoke the `superpowers:verification-before-completion` skill.**

> NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.

Hit production. Health endpoint, one real read path, and — if the release touched writes — one real write path. Read the actual responses and paste them. A green pipeline proves the pipeline ran. It does not prove the app serves traffic.

If any of it is wrong, the rollback plan in the ticket's `## Risks, Dependencies, Rollback` is the plan. Execute it; do not debug forward in production.

---

## Notes for Claude

- HARD CI gate: do not open the PR if CI is red on {{DEV_BRANCH}}.
- A release is verified against production, not against the deploy log.
- Never push directly to {{PROD_BRANCH}} — the hook blocks it.
