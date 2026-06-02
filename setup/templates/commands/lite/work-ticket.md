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

## Step 3 — Quick design round (ENTER PLAN MODE, 1–2 batches)

If the ticket has empty design sections (Data Model, API Contracts), fill them now via AskUserQuestion. Focus on:
- Data model: which models/tables change?
- Key API shapes
- Test plan: which test layers apply?

EXIT PLAN MODE when design is approved.

## Step 4 — Fill design sections

Update the ticket with design answers.

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

Print ticket, branch, next action. Type GO to start building.
