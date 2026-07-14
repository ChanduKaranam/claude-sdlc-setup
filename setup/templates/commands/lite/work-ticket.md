---
name: work-ticket
description: Pick up a ticket and start building. Merges groom + claim into one step for solo workflow.
---

You are starting work on an existing ticket: **$ARGUMENTS**

## Step 1 — Resolve and read the ticket

```bash
ls docs/tickets/${ARGUMENTS}-*.md 2>/dev/null
```

Read it fully. Understand Goal, Web Routes, Mobile Screens.

## Step 2 — Check status

- `TODO` or `APPROVED` → proceed.
- `IN_PROGRESS` → ask: "Already in progress. Resume, or start fresh?"
- `COMPLETED` → abort.

## Step 3 — Design round (ENTER PLAN MODE)

`/new-feature` deliberately left the design sections blank. This is where they get filled — and this is the only design gate in the solo pipeline, so it carries the weight that `/groom-ticket` + `/review-ticket` carry for teams. Do not rush it.

**Invoke the `superpowers:brainstorming` skill.** Three overrides:

1. **The design artifact is this ticket file.** Do not write `docs/superpowers/specs/*` — write into the ticket's `## Data Model`, `## Detailed API Contracts`, `## Test Scenarios`, and `## Test Plan` sections.
2. **Do not jump to `writing-plans`** — that is Step 3b below.
3. Its "propose 2–3 approaches" step is where **ponytail's ladder** goes. Before proposing anything: does this need to exist at all? Is it already in this codebase — grep, don't guess. Stdlib? Native platform feature? An already-installed dependency? Recommend the laziest approach that actually holds, and name what you skipped.

Cover: which models/tables change · the key API shapes · every component state (empty-none, empty-filtered, loading, error) · which test layers apply and at what exact paths.

Then **invoke the `grilling` skill** for risks, dependencies and rollback. One question at a time, each with your recommended answer. Look facts up — schema, migrations, existing code — and only ask about *decisions*. Stop when you've reached shared understanding, not at a question count.

Solo means nobody else will catch a bad design. That is what this round is for.

## Step 3b — Write the Implementation Plan

**Invoke the `superpowers:writing-plans` skill.** One override: the plan goes into this ticket's `## Implementation Plan` section, not `docs/superpowers/plans/*`.

It must produce a `### Global Constraints` block (verbatim values — response envelope, validation lib, ORM, test command) and one `### Task N` per test cycle, each with exact `**Files:**` and `**Interfaces:**`, and checkbox steps in strict TDD order: failing test → verify RED → minimal implementation → verify GREEN → commit.

**No placeholders.** "TBD", "TODO", "add appropriate error handling" — each is a plan failure, and `/build-ticket` will refuse the ticket.

EXIT PLAN MODE when the design and the plan are both approved.

## Step 4 — Fill design sections

Write the design and the Implementation Plan into the ticket.

## Step 5 — Update status + state

- Ticket frontmatter: `status: IN_PROGRESS`, `claimed_at`, `claimed_by`.
- `docs/STATE.md`: `status: CLAIMED`, `next_action`.
- `_active.md`: update active entry.

## Step 6 — Switch to feature branch

```bash
git switch -c feature/$ARGUMENTS {{BASE_BRANCH}} 2>/dev/null || git switch {branch-from-ticket}
```

## Step 7 — Commit

```bash
git add docs/ && git commit -m "chore($ARGUMENTS): claim + design"
```

## Step 8 — Report

Print ticket, branch, and:

```
Next: /build-ticket $ARGUMENTS
```

Stop here. **Do not write code in this command.** `/build-ticket` owns implementation — it sets up an isolated workspace, takes a clean test baseline, and runs the plan you just wrote under TDD. Starting to build here skips all three.

---

## Notes for Claude

- This command designs and plans. It does not build.
- The ticket leaves here with a complete, TBD-free `## Implementation Plan`. That plan is the contract `/build-ticket` executes — a vague plan becomes a vague feature.
