---
name: build-ticket
description: Build a ticket. Executes the ticket's Implementation Plan task by task under TDD, reviews the diff, and fills the Verification Log. This is where code gets written.
---

# /build-ticket $ARGUMENTS

Executes `docs/tickets/TICKET-XXX-$ARGUMENTS.md`. Everything before this command was design; everything in this command is code.

This command does not invent a process. It runs the superpowers chain over the plan the ticket already carries.

---

## Step 1 — Guards

Resolve the ticket file from `$ARGUMENTS` and read it in full — Goal, Data Model, API shapes, Test Plan, and especially `## Implementation Plan`.

Then check, in order. Any failure stops the command:

1. **Status.** `IN_PROGRESS` or `APPROVED` → continue. `COMPLETED` → stop.
2. **The plan exists.** `## Implementation Plan` must contain at least one `### Task N` block with real steps. If it is empty, a stub, or contains TBDs:

   > This ticket has no Implementation Plan. Run `/work-ticket $ARGUMENTS` first — that is where the plan gets written.

   Stop. Do not improvise a plan here.
3. **Clean tree.** `git status --short` — anything uncommitted, stop and ask.

---

## Step 2 — Isolated workspace

**Invoke the `superpowers:using-git-worktrees` skill.** It detects whether you are already isolated and will not nest.

---

## Step 3 — Baseline

```bash
git rev-parse HEAD   # this is BASE_SHA. Never use HEAD~1 later.
```

Run `{{TEST_CMD}}` once, now, before writing anything. Read the full output.

- Green → proceed.
- Red → **report the failures and ask before continuing.** TDD on an already-red suite is meaningless.

---

## Step 4 — Choose the execution mode

Ask, and recommend the first:

1. **Subagent-driven (recommended).** Invoke `superpowers:subagent-driven-development`. Pass this ticket file as `PLAN_FILE` — its tasks are the `### Task N` headings under `## Implementation Plan`.
2. **Inline.** Invoke `superpowers:executing-plans` and work the tasks in this session.

**If `subagent-driven-development`'s `scripts/task-brief` cannot parse the ticket** (it expects a plan document, and this is a ticket), say so out loud and fall back to mode 2. Do not silently degrade.

Either way, the ticket's `### Global Constraints` block is copied **verbatim** into every subagent prompt.

---

## Step 5 — Per task: TDD, always

**The `superpowers:test-driven-development` skill governs every task.**

> NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.

1. Write the one minimal failing test the task names.
2. Run `{{TEST_CMD}}` — **verify RED, and that it fails for the right reason.**
3. Minimal code to pass.
4. Run `{{TEST_CMD}}` — **verify GREEN, output pristine.**
5. Refactor. No new behavior.
6. Commit: `type(scope): description (TICKET-XXX)`.

If code got written before its test, delete it. Do not adapt it.

**Ponytail applies to every diff.** Climb the ladder first: does this need to exist at all → is it already in this codebase (grep before you write) → stdlib → native platform feature → an already-installed dependency → one line → only then, the minimum code that works.

Deliberate corner-cuts get a marker naming the ceiling and the upgrade path — `/complete-feature` harvests these into the PR:

```ts
// ponytail: in-memory cache, move to Redis if this goes multi-instance
```

Never lazy about: input validation at trust boundaries, error handling that prevents data loss, security, accessibility, or anything the ticket explicitly asked for.

---

## Step 6 — When something breaks

**Invoke `superpowers:systematic-debugging`.**

> NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST.

One hypothesis, one variable, one smallest-possible change. Do not stack fixes. **Three failed fixes means stop** — the design is wrong, not the code. Record it in the ticket's `## Delays & Blockers` and bring it back to the user.

---

## Step 7 — Review the work

After the last task's commit (or after each task, if the ticket is large):

**Invoke `superpowers:requesting-code-review`** over `BASE_SHA..HEAD_SHA` — the `code-reviewer` agent in `.claude/agents/` is the reviewer.

Then **invoke `superpowers:receiving-code-review`** to act on it. Verify each finding against the actual code before implementing it; push back with reasoning where warranted. Fix BLOCK immediately. Do not thank the reviewer — state the fix.

---

## Step 8 — Sync state

After each task: tick its checkboxes in `## Implementation Plan`, update `docs/STATE.md` (`last_action`, `next_action`, `files_in_progress`, `blockers`), append to the ticket's `## Change Log`. Commit with the task, not separately.

---

## Step 9 — Done gate

**Invoke `superpowers:verification-before-completion`.**

> NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.

Run these **in this message** and read the full output and exit code:

```bash
{{TEST_CMD}}
{{LINT_CMD}}
{{TYPECHECK_CMD}}
```

Fill the ticket's `## Verification Log` with what you actually observed. An unrun row is an empty row, not a ticked one.

```
BUILD COMPLETE — TICKET-XXX
Tasks:        {n}/{n}
Tests:        {actual output summary}
Lint:         {actual output summary}
Typecheck:    {actual output summary}
Shortcuts:    {any ponytail: markers left, or "none"}

Next: /complete-feature $ARGUMENTS
```

---

## Notes for Claude

- The ticket is the plan. If the plan is wrong, go back to `/work-ticket` — do not fix it inline and build from your own version.
- Verify RED before you write the implementation. Every task. No exceptions for "too simple to test".
- Never claim a command passed without its output in the same message.
- Three failed fixes means stop, not fix number four.
