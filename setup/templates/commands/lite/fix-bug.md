---
name: fix-bug
description: Fix a bug in a shipped feature. Grills the report, reproduces it, traces the root cause, stops for your confirmation, then fixes it test-first at the root — not at the symptom.
---

You are fixing a bug: **$ARGUMENTS**

A bug report names a *symptom*. It does not name a cause, and it does not name a fix — even when it sounds like it does, and even when the reporter is you. Especially when the reporter is you: solo, the person who wrote the bug and the person diagnosing it have the same blind spot.

---

## Step 1 — Understand the report

**Invoke the `grilling` skill.** One question at a time, each with your recommended answer.

Grilling's second rule matters more here than anywhere else: **facts get looked up, decisions get asked.** Don't ask what you can find.

Look up, don't ask:
- Which feature and ticket this belongs to — `grep` `docs/tickets/`.
- What the code currently does — read it.
- When it last worked — `git log -S'{the symptom string}'`, `git log` the file.
- Whether a test covers this path — there probably isn't one, and that's a finding.

Ask, one at a time:
- What did you expect, and what happened instead? (Two answers. Get both.)
- The exact steps. Not "it breaks on save" — the steps.
- Every time, or sometimes? If sometimes, what's different when it does?
- Error text, verbatim.
- How badly does it hurt? (Severity is the only thing that justifies a corner cut later.)

Stop when you can state the bug in one sentence and you agree that sentence is the bug.

---

## Step 2 — Find the feature it broke

Resolve the parent ticket. Read its Goal, Acceptance Criteria, and Test Plan.

Most bugs are one of three, and which one shapes the fix:
1. **An AC that was never true** — it shipped broken, and nobody verified that criterion.
2. **A state nobody designed** — usually empty, filtered-empty, or error.
3. **A regression** — it worked, then something broke it. `git log -S` finds it.

Say which. If it's (1) or (2), the *design* was wrong, not just the code — note it, because the same gap is probably in the sibling tickets too.

---

## Step 3 — Open the bug ticket and a branch

Next number: `ls docs/tickets/ | grep -E '^BUG-[0-9]' | sort | tail -1`

Copy `docs/tickets/_BUG_TEMPLATE.md` → `docs/tickets/BUG-XXX-$ARGUMENTS.md`. Fill Symptom, parent ticket, severity, `reported_at`.

**Invoke the `superpowers:using-git-worktrees` skill** for an isolated workspace on `fix/$ARGUMENTS` off `{{BASE_BRANCH}}`. Fall back to `git switch -c fix/$ARGUMENTS {{BASE_BRANCH}}`.

Update `docs/STATE.md` — a `/handoff` mid-fix needs something true to hand off.

---

## Step 4 — Reproduce it. Not optional.

**Invoke the `superpowers:systematic-debugging` skill.**

> NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

Reproduce it consistently, on this branch, before theorising. Record the steps in the ticket.

**If you cannot reproduce it, stop.** Set `reproduced: false` and say what you tried. A fix for a bug you never saw is a guess wearing a commit message.

---

## Step 5 — Trace it to the root cause

Work backward from symptom to source:

- Read the error **completely**. The stack trace usually names the file; people skim it and then go hunting.
- Instrument the boundaries the data crosses. Don't reason about what a value "must be" — print it.
- Trace backward to the first place the data is wrong. That's the root cause. Everything downstream is symptom — including the line that threw.
- Find a working sibling in this codebase and list every difference. The answer is usually in that list.

One hypothesis, one variable, one change. **Never stack fixes.**

**Three failed fixes: stop.** Record the failed hypotheses in `## Delays & Blockers`. At three, the design is wrong, and a fourth poke won't reveal that.

---

## Step 6 — HARD STOP. Confirm the diagnosis before writing anything.

**Write no code until you confirm this.** Not a test, not a stub.

Fill `## Root Cause` and `## Blast Radius`, then present:

```
BUG-XXX — DIAGNOSIS

Symptom:      {one sentence}
Root cause:   {path}:{line} — {function}
Why:          {the causal chain, traced. not "probably".}
Evidence:     {what you observed that proves it}

Blast radius — every caller of {function}:
  {path}:{line}   also broken · covered by this fix
  {path}:{line}   not broken   · {why not}
  Patching only the reported path would leave broken: {list, or "nothing"}

Proposed fix:  {one paragraph}
Rejected:      {the symptom-level patch you are NOT doing, and why}

Confirm this diagnosis before I write the fix.
```

**Grep every caller before writing that.** It's the whole point of the step. A bug report names one broken path; a root cause usually breaks several, and the callers nobody reported are the ones that bite in three weeks. One guard in the shared function is both the smaller diff *and* the one that fixes the siblings — the lazy fix and the correct fix are the same fix.

Solo, this stop is the only review this bug will get before code exists. Read your own diagnosis like someone else wrote it.

---

## Step 7 — Write the failing test first

**Invoke the `superpowers:test-driven-development` skill.**

> NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.

The regression test comes before the fix. It must reproduce the reported symptom, fail against the **unfixed** code, and fail **for the right reason** — read the output and confirm it's the bug, not a typo in your test.

```bash
{{TEST_CMD}}    # observe RED. Confirm the failure message is the bug.
```

If it passes against the unfixed code, you haven't reproduced the bug — you've tested something else. Back to Step 4.

---

## Step 8 — Fix it, at the root, minimally

**Ponytail governs the diff.** The smallest change that fixes the *cause*:
- Fix it once, where the callers route through — not once per caller.
- Don't refactor while you're in there. A fix that also restructures is two changes, and if it breaks nobody knows which one did it.
- No new dependency. No new abstraction. No hardening of adjacent code you weren't asked about.
- Deliberate corner cut → `// ponytail: {ceiling}, {upgrade trigger}`.

Never lazy about: input validation at trust boundaries, error handling that prevents data loss, security, accessibility. If the bug *is* one of those, the fix isn't the minimum that greens the test — it's the one that closes the class.

```bash
{{TEST_CMD}}    # observe GREEN, whole suite, pristine output.
```

---

## Step 9 — Prove the red-green

**Invoke the `superpowers:verification-before-completion` skill.**

A regression test earns its name only once you've watched it fail. Do it now, in this message, and paste both outputs:

```bash
git stash            # revert the fix
{{TEST_CMD}}         # must be RED — this is the proof
git stash pop        # restore it
{{TEST_CMD}}         # must be GREEN
```

Tick all three boxes in `## Regression Test`. An unproven regression test silently stops testing anything the moment someone refactors past it.

Then, in this message, reading every exit code:

```bash
{{TEST_CMD}}
{{LINT_CMD}}
{{TYPECHECK_CMD}}
```

Fill the ticket's `## Verification Log` with what you actually observed.

---

## Step 10 — Review

**Invoke the `superpowers:requesting-code-review` skill** over `BASE_SHA..HEAD_SHA` — the `code-reviewer` agent reviews. Give it the diagnosis, not just the diff: a reviewer who doesn't know the root cause can only review syntax.

Then **invoke `superpowers:receiving-code-review`** to act on it. Verify each finding against the code first; push back with reasoning where warranted.

Ask it specifically: **does this fix the cause, or hide the symptom?** That's the failure mode of every bug fix, and a green test run won't show it.

---

## Step 11 — Commit and ship

```bash
git add -A && git commit -m "fix($ARGUMENTS): {what broke, in the user's terms} (BUG-XXX)"
```

Set `status: READY_FOR_REVIEW`, `fixed_at`. Update `docs/STATE.md`.

```
BUG-XXX FIXED
Symptom:      {one sentence}
Root cause:   {path}:{line}
Fix:          {one line} · {n} files, {+a}/{-d}
Regression:   {test path} — red-green proven
Also fixed:   {sibling call sites the root-cause fix covered, or "none"}
Suite:        {actual output}

Next: /complete-feature $ARGUMENTS
```

Then run **`/complete-feature $ARGUMENTS`**. The gates are the same for a fix as for a feature. A one-line fix that skips them is exactly how the next bug gets in.

---

## Notes for Claude

- A bug report is a symptom. Disbelieve every explanation in it — including your own first one.
- Reproduce, then diagnose, then confirm, then test, then fix. No small bug earns an exemption; "it's a one-liner" is what people say right before patching the wrong line.
- Grep the callers. Every time.
- Can't reproduce it? Say so and stop.
- Three failed fixes means stop, not fix number four.
