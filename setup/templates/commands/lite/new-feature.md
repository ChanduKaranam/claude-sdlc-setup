---
name: new-feature
description: Start a new feature — runs a quick interview, writes the ticket file, branches off {{BASE_BRANCH}}.
---

You are starting a new feature for {{PROJECT_NAME}}: **$ARGUMENTS**

## Step 1 — Sanity check

```bash
git status && git switch {{BASE_BRANCH}} && git pull --ff-only origin {{BASE_BRANCH}}
```

## Step 2 — Determine the next ticket number

```bash
ls docs/tickets/ | grep -E '^TICKET-[0-9]' | sort | tail -1
```

## Step 3 — Switch to feature branch

```bash
git switch -c feature/$ARGUMENTS {{BASE_BRANCH}}
```

## Step 4 — ENTER PLAN MODE: quick interview (≤4 questions per batch)

Ask:
1. What does this feature do? (one sentence)
2. Which surfaces? ({{SURFACES}})
3. Empty state? Loading state? Error state?
4. Any non-obvious constraints or dependencies?

## Step 5 — Estimate

Give a session range based on scope (1–2 for simple, 3–5 for complex).

## Step 6 — EXIT PLAN MODE

## Step 7 — Write the ticket

Copy `docs/tickets/_TEMPLATE.md` to `docs/tickets/TICKET-XXX-$ARGUMENTS.md`. Status: `APPROVED` (solo, no review gate).

Fill: Goal, surfaces, states, estimate. Leave design sections blank (fill at build time).

## Step 8 — Update docs

- Append to `active:` in `docs/tickets/_active.md`.
- Write `docs/STATE.md` with status `SCAFFOLDED`.

## Step 9 — Commit

```bash
git add docs/ && git commit -m "chore($ARGUMENTS): scaffold feature"
```

## Step 10 — Report

Print ticket path, branch, estimate. Stop here.
