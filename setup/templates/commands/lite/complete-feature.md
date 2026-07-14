---
name: complete-feature
description: Verify a completed feature against fresh evidence, review the diff, and open a PR. Nothing is claimed here that was not observed here.
---

You are completing feature: **$ARGUMENTS**

**Invoke the `superpowers:verification-before-completion` skill** first. Its iron law governs every checkbox below:

> NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.

If you did not run the command **in this message**, you cannot tick its box. Not "it passed in `/build-ticket`", not "it should pass". Run it, read the full output and the exit code, then claim — with the output in the message.

Solo means nobody else is going to catch it. This gate is the only reviewer you have.

---

## Gate 1 — Tests, lint, types

```bash
{{TEST_CMD}}
{{LINT_CMD}}
{{TYPECHECK_CMD}}
```

- [ ] All tests pass — paste the summary line. Zero failures.
- [ ] No skipped tests left behind — `grep` for `.skip` / `xit` / equivalent, paste the result.
- [ ] Zero lint errors — paste the output.
- [ ] Zero type errors — paste the output.

Red? **Invoke the `superpowers:systematic-debugging` skill.** No fix without root cause first. Do not `.skip` the test, do not fix forward, do not open the PR.

## Gate 2 — Test plan reconciliation

- [ ] Every checked box in the ticket's `## Test Plan` names a file that exists on disk — `ls` each one.
- [ ] Every `### Task N` in `## Implementation Plan` has all its steps ticked.

## Gate 3 — Review the diff, twice

**Correctness — invoke the `superpowers:requesting-code-review` skill.** Capture `BASE_SHA` (merge-base with `{{PR_TARGET_BRANCH}}`) and `HEAD_SHA`, and dispatch the `code-reviewer` agent over that range. A fresh reviewer with no session history catches what you cannot — you have been staring at this diff for hours.

**Over-engineering — invoke the `ponytail:ponytail-review` skill** on the same diff. It hunts only for what should be deleted: reinvented stdlib, an abstraction with one implementation, a dependency added for what five lines do, scaffolding for a future nobody asked for.

Then **invoke the `superpowers:receiving-code-review` skill** to act on both. Verify each finding against the actual code before implementing it — reviewers are wrong sometimes, and implementing a wrong finding is worse than pushing back on it.

- [ ] Every BLOCK resolved.
- [ ] `ponytail-review`'s cuts applied, or each one refused with a reason.

## Gate 4 — Security

- [ ] No hardcoded secrets or credentials — check the diff, paste what you looked at.
- [ ] All API inputs validated at the boundary.
- [ ] Auth applied to every new protected route.

Never lazy here. This is a trust boundary.

## Gate 5 — Deliberate shortcuts and state

**Invoke the `ponytail:ponytail-debt` skill** to harvest every `ponytail:` marker on this branch. Each needs a ceiling and an upgrade trigger — a marker with no trigger is the kind that silently rots. They go in the PR body (or "none").

- [ ] `docs/STATE.md` status → `READY_FOR_REVIEW`.
- [ ] Ticket's `## Verification Log` filled with the evidence from Gate 1 — actual commands, actual results.

---

## Ship it

**Invoke the `superpowers:finishing-a-development-branch` skill.** It verifies tests first (a red suite means it stops and does not even offer the options), then presents exactly four choices. **Take option 2 — push and create a PR.**

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
{the actual command output from Gate 1 — not a promise that you ran it}

## Deliberate shortcuts
{ponytail: markers with ceiling + upgrade trigger, or "none"}
EOF
)"
```

Print the PR URL.

---

## Notes for Claude

- A checkbox ticked without running its command is a lie in a file that outlives you. Run it.
- Do NOT open the PR if any gate is red.
- If a test fails, that is a `systematic-debugging` job, not a `.skip` job.
