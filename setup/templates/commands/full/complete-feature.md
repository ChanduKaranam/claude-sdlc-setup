---
name: complete-feature
description: Run the pre-merge checklist and open a PR for a completed feature.
---

You are completing feature: **$ARGUMENTS**

## Pre-Merge Checklist

**Tests**
```bash
{{TEST_CMD}}
```
- [ ] All tests pass
- [ ] No skipped tests (.skip) left behind

**Code Quality**
```bash
{{LINT_CMD}}
{{TYPECHECK_CMD}}
```
- [ ] Zero lint errors
- [ ] Zero TypeScript/type errors

{{DB_CHECKLIST}}

**Documentation**
- [ ] ADR written for all architectural decisions made
- [ ] README/STATE.md status updated to READY_FOR_REVIEW

**Security**
- [ ] No hardcoded secrets or credentials
- [ ] All API inputs validated
- [ ] Auth applied to all new protected routes

**Review**
- [ ] Invoke `code-reviewer` agent and resolve all BLOCK issues

**Test Plan**
- [ ] Every checked Test Plan box's file exists on disk
- [ ] Every unchecked box has N/A — {reason}

When all items pass:

```bash
git push -u origin feature/$ARGUMENTS
```

Then open the PR against `{{PR_TARGET_BRANCH}}` (NOT {{DEPLOY_BRANCHES}} — those are promotion-only):

```bash
gh pr create \
  --base {{PR_TARGET_BRANCH}} \
  --head feature/$ARGUMENTS \
  --title "feat($ARGUMENTS): {one-line summary}" \
  --body "$(cat <<'EOF'
## Summary
{2-4 bullets}

## Test plan
{AC checklist from ticket}

## Verification log
{screenshots + smoke results}
EOF
)"
```

Print the PR URL so the dev can click through.

---

## Notes for Claude

- Do NOT open the PR if any BLOCK items remain.
- `--base {{PR_TARGET_BRANCH}}` is non-negotiable — direct pushes to {{DEPLOY_BRANCHES}} are blocked.
