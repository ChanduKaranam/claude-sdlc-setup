---
name: new-feature
description: Start a new feature — runs the architectural interview, writes the ticket file, estimates session count.
---

You are starting a new feature for {{PROJECT_NAME}}: **$ARGUMENTS**

Follow this protocol exactly. The interview at the front is non-negotiable — it makes the build predictable.

## Step 0 — Identity check

Read `docs/TEAM.md` YAML frontmatter. Extract `leads:` and `devs:` lists.

```bash
git config user.email
```

If the runner's email is **not** present in `leads ∪ devs`, abort:

> "You're not listed in `docs/TEAM.md`. Add yourself under `devs:` (or ask a lead to) on a feature branch + PR, then re-run."

Record whether the runner is a lead (used in Step 8).

## Step 1 — Sanity check

```bash
git status
git switch {{BASE_BRANCH}}
git pull --ff-only origin {{BASE_BRANCH}}
```

If the working tree is dirty, stop and ask them to commit or stash first.

## Step 2 — Determine the next ticket number

```bash
ls docs/tickets/ | grep -E '^TICKET-[0-9]' | sort | tail -1
```

## Step 3 — Switch to feature branch (BEFORE Plan Mode)

```bash
git switch -c feature/$ARGUMENTS {{BASE_BRANCH}}
```

## Step 4 — ENTER PLAN MODE

Stay in Plan Mode for the entire interview. Files are written AFTER ExitPlanMode.

## Step 5 — Architectural interview (3 rounds, ≤4 questions per AskUserQuestion batch)

**Before Round 1, climb ponytail's first rung: does this feature need to exist at all?**

Ask it plainly. Is there a rung above building it — an existing feature that covers the case, a config change, a native platform behavior, a thing the user could already do if they knew where to click? If the honest answer is "this is speculative", say so in one line and stop before you spend a ticket on it. YAGNI is cheapest at the very start.

If it survives that, run the rounds. These are the fast, factual rounds — batched `AskUserQuestion` is right here. The deep design happens in `/groom-ticket`, and that one is grilled.

### Round 1 — Scope
1. Who's the primary user and what are they doing?
2. Which surfaces? ({{SURFACES}})
3. Primary action on each item?
4. Default sort and filter?

### Round 2 — States (all required)
1. Empty state — CTA text? Illustration or text-only?
2. Filtered-empty — what shows when search returns 0?
3. Loading — skeleton / spinner / progressive?
4. Error — retry button / contact support / silent fallback?

### Round 3 — Boundaries
1. Pagination model — infinite scroll / paged / show-all
2. Permission gating — all members / role-based / owner-only
3. {{SURFACE_SPECIFIC_Q}}

## Step 6 — Estimate session count

Based on answers, give a session range (1–2 sessions for simple, 4–7 for multi-surface + schema changes).

## Step 7 — EXIT PLAN MODE

## Step 8 — Write the ticket from the template

Copy `docs/tickets/_TEMPLATE.md` to `docs/tickets/TICKET-XXX-$ARGUMENTS.md` and fill in Goal, Web Routes, Mobile Screens (if applicable), Acceptance Criteria, and session estimate.

- Lead runner → `status: APPROVED` (auto-approved)
- Dev runner → `status: TODO` (needs grooming + lead review)

## Step 9 — Claim in _active.md

Append to `active:` in `docs/tickets/_active.md`.

## Step 10 — Update STATE.md

Set status `SCAFFOLDED`, next action, empty files_in_progress.

## Step 11 — Commit (no push)

```bash
git add docs/tickets/ docs/STATE.md
git commit -m "chore($ARGUMENTS): initialize feature scaffold"
```

## Step 12 — Report and pause

Print a formatted summary with ticket path, branch, estimate, and next step. Stop here.

---

## Notes for Claude

- Do not skip the interview. Tickets without state lists ship UI bugs.
- Ask in batches of 4 max.
- If the dev says "decide later", that decision defers to `/groom-ticket`, which is the design command — not to build time. `/build-ticket` refuses a ticket whose Implementation Plan still contains TBDs, and it is right to: an unresolved decision does not get more resolved by having code written around it.
- This command scaffolds a ticket. It does not design one and it does not build one.
