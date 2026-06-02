---
name: claim-ticket
description: Pick up an APPROVED ticket from the queue. Branches off {{BASE_BRANCH}}, claims in _active.md, initializes STATE.md.
---

You are claiming an existing ticket: **$ARGUMENTS**

## Step 0 — Identity check

Read `docs/TEAM.md`. Verify `git config user.email` is in leads ∪ devs.

## Step 1 — Sanity check

```bash
git status && git switch {{BASE_BRANCH}} && git pull --ff-only origin {{BASE_BRANCH}}
```

## Step 2 — Resolve and read the ticket file

```bash
ls docs/tickets/${ARGUMENTS}-*.md 2>/dev/null
```

Extract: `feature`, `branch`, `status`, `estimated_sessions`, `groomed_by`, `approved_by`.

## Step 3 — Status guard (design-approval gate)

- `TODO` → abort: "Hasn't been groomed yet."
- `GROOMED` → abort: "Awaiting lead review."
- `CHANGES_REQUESTED` → abort: "Feedback pending revision."
- `APPROVED` → continue.
- `IN_PROGRESS` → abort: "Already claimed by {developer}."
- `COMPLETED` → abort: "Already done."

If `groomed_by` set and != current user, ask: "Was groomed by {groomed_by}. Claim anyway? (y/N)"

## Step 4 — Switch to feature branch

```bash
git switch -c {branch} {{BASE_BRANCH}}
```

## Step 5 — Update ticket frontmatter

- `status: IN_PROGRESS`
- `claimed_by: {email}`
- `claimed_at: {ISO-8601 now}`

## Step 6 — Update _active.md

Append to `active:` YAML list. Remove from Available follow-up tickets if listed there. Add row to Active Tickets table.

## Step 7 — Initialize STATE.md

```yaml
ticket: {id}
feature: {slug}
branch: {branch}
developer: {name}
timestamp: {now}
status: CLAIMED
last_action: Picked up from queue via /claim-ticket.
next_action: Read ticket carefully. Start with first AC bullet.
files_in_progress: []
blockers: []
```

## Step 8 — Commit (no push)

```bash
git add docs/ && git commit -m "chore({slug}): claim {TICKET-id}"
```

## Step 9 — Report and pause

Print formatted summary. Stop here — do not start building until the dev says go.

---

## Notes for Claude

- The APPROVED gate is non-negotiable. No bypasses for devs.
- Do not modify the ticket body — only the YAML frontmatter status/claimed_by/claimed_at.
