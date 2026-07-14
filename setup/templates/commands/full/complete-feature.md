---
name: complete-feature
description: Verify a completed feature against fresh evidence, review the diff, and open a PR. Nothing is claimed here that was not observed here.
---

You are completing feature: **$ARGUMENTS**

**Invoke the `superpowers:verification-before-completion` skill** before you do anything else in this command. Its iron law governs every checkbox below:

> NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.

If you did not run the command **in this message**, you cannot tick its box. Not "I ran it earlier", not "it passed in `/build-ticket`", not "it should pass". Run it, read the full output *and the exit code*, then claim — with the output in the message.

---

## Gate 1 — Tests

```bash
{{TEST_CMD}}
```

- [ ] All tests pass — **paste the summary line.** Zero failures, zero errors.
- [ ] No skipped tests (`.skip`, `xit`, `@pytest.mark.skip`) left behind — `grep` for them, paste the result.

Red? **Invoke the `superpowers:systematic-debugging` skill.** Do not fix forward, do not skip the test, do not open the PR. No fix without root cause first.

## Gate 2 — Code quality

```bash
{{LINT_CMD}}
{{TYPECHECK_CMD}}
```

- [ ] Zero lint errors — paste the output.
- [ ] Zero type errors — paste the output.

{{DB_CHECKLIST}}

## Gate 3 — Test plan reconciliation

- [ ] Every checked box in the ticket's `## Test Plan` names a file that **exists on disk** — `ls` each one, paste the result.
- [ ] Every unchecked box carries `N/A — {reason}`.
- [ ] Every `### Task N` in `## Implementation Plan` has all its steps ticked.

An unrun row is an empty row, not a ticked one.

## Gate 4 — Review the diff, twice

Two lenses, both required. They look for different things and neither substitutes for the other.

**Correctness — invoke the `superpowers:requesting-code-review` skill.** Capture `BASE_SHA` (the merge-base with `{{PR_TARGET_BRANCH}}`) and `HEAD_SHA`, and dispatch the `code-reviewer` agent over that range. It returns BLOCK / WARN / NIT.

**Over-engineering — invoke the `ponytail:ponytail-review` skill** on the same diff. It hunts only for what should be deleted: reinvented stdlib, an abstraction with one implementation, a dependency added for what five lines do, dead flexibility, scaffolding for a future that has not arrived.

Then **invoke the `superpowers:receiving-code-review` skill** to act on both. Read everything before reacting. Verify each finding against the actual code — reviewers are wrong sometimes, and implementing a wrong finding is worse than pushing back on it. Push back with reasoning where warranted.

- [ ] Every BLOCK resolved.
- [ ] Every WARN resolved or explicitly accepted with a reason.
- [ ] `ponytail-review`'s cuts applied, or each one refused with a reason.

Do not write "You're absolutely right!" Do not thank the reviewer. State the fix.

## Gate 5 — Security

- [ ] No hardcoded secrets or credentials — `git diff {{PR_TARGET_BRANCH}}...HEAD` and check, paste what you looked at.
- [ ] All API inputs validated at the boundary.
- [ ] Auth applied to every new protected route.

Never lazy here. This is a trust boundary.

## Gate 6 — Deliberate shortcuts

**Invoke the `ponytail:ponytail-debt` skill** to harvest every `ponytail:` marker added on this branch.

- [ ] Each marker names its ceiling and its upgrade trigger. A marker with no trigger is the kind that silently rots — give it one, or remove the shortcut.
- [ ] The list goes in the PR body under `## Deliberate shortcuts` (or "none").

## Gate 7 — Documentation

- [ ] ADR written in `docs/decisions/` for every architectural decision made.
- [ ] `docs/STATE.md` status → `READY_FOR_REVIEW`.
- [ ] Ticket's `## Verification Log` table filled with the evidence from Gates 1–3 — the actual commands, the actual results.

---

## Ship it

**Invoke the `superpowers:finishing-a-development-branch` skill.** It verifies tests first (a red suite means it stops and does not even present the options), detects the workspace, finds the base branch, and offers exactly four choices. **Take option 2 — push and create a PR.**

The PR targets `{{PR_TARGET_BRANCH}}`, never {{DEPLOY_BRANCHES}} — those are promotion-only and the hook blocks direct pushes to them.

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
{AC checklist from the ticket}

## Verification log
{the actual command output from Gates 1-3 — not a promise that you ran them}

## Deliberate shortcuts
{ponytail: markers with ceiling + upgrade trigger, or "none"}
EOF
)"
```

Print the PR URL so the dev can click through.

---

## Notes for Claude

- A checkbox you ticked without running its command is a lie in a file that outlives you. Run it.
- Do NOT open the PR if any BLOCK remains, or if any gate is red.
- `--base {{PR_TARGET_BRANCH}}` is non-negotiable — direct pushes to {{DEPLOY_BRANCHES}} are blocked by hook.
- If a test fails, that is a `systematic-debugging` job, not a `.skip` job.
