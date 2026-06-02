---
name: groom-ticket
description: Deep-design a TODO (or CHANGES_REQUESTED) ticket — adds data model, API contracts, test scenarios, test plan, and risks. Sets status GROOMED (or auto-APPROVED if a lead runs it).
---

You are deepening the design of an existing ticket: **$ARGUMENTS**

## Step 1 — Sanity check

```bash
git status
```

If dirty, stop and ask to commit/stash first.

## Step 2 — Identity check

Read `docs/TEAM.md`. Check `git config user.email` against leads/devs.

## Step 3 — Resolve the ticket file

```bash
ls docs/tickets/${ARGUMENTS}-*.md 2>/dev/null
```

Read frontmatter, extract `status`, `feature`, `branch`.

## Step 4 — Status guard

- `TODO` → continue
- `CHANGES_REQUESTED` → continue (preserve prior Lead Feedback sections)
- `GROOMED` → abort: "Already groomed; awaiting lead review."
- `APPROVED` and dev → abort: "Already approved. Run `/claim-ticket $ARGUMENTS`."
- `IN_PROGRESS | COMPLETED` → abort: "Past design phase."

## Step 5 — Switch to ticket branch

```bash
git switch {branch-from-frontmatter}
git pull --ff-only
```

## Step 6 — ENTER PLAN MODE for 5-round interview

### Round 1 — UI walkthrough
For each route/screen: layout, key elements, interactions, transitions, and all four states (empty-none, empty-filtered, loading, error).

### Round 2 — Data model
Which models change? New tables/columns? FK relationships? Migration order? Workspace scoping?

### Round 3 — API contracts (Zod shapes)
For each endpoint: request shape, response shape (inside response envelope), permissions, idempotency.

### Round 4 — Test scenarios
Happy path, error paths (400/403/404/409), component states, edge cases.

### Round 4b — Test plan (concrete file paths)
For each test layer, name the exact file path OR mark `N/A — {reason}`:
{{TEST_LAYERS}}

### Round 5 — Risks, dependencies, rollback
Migration risks, feature flag, depends-on tickets, rollback plan, performance concerns.

## Step 7 — EXIT PLAN MODE

## Step 8 — Insert design sections into ticket

Add: UI Walkthrough, Data Model, Detailed API Contracts, Test Scenarios, Test Plan, Risks sections.

## Step 9 — Update frontmatter

- `groomed_by`, `groomed_at`, `grooming_round`
- Lead runner → `status: APPROVED`; Dev runner → `status: GROOMED`

## Step 10 — Update _active.md

Dev: add row to Pending Lead Review table. Lead: remove from that table if present.

## Step 11 — Commit and push

```bash
git add docs/tickets/ && git commit -m "chore: groom $ARGUMENTS" && git push -u origin {branch}
```

## Step 12 — Report and pause

Print formatted summary with status, ticket path, and next step. Stop here.

---

## Notes for Claude

- Do not skip any round.
- Push the branch so leads on other machines can pull.
- Lead self-approval is intentional (they are both author and reviewer).
