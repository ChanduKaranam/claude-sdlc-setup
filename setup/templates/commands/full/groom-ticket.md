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
- `CHANGES_REQUESTED` → continue (preserve prior Lead Feedback sections verbatim). **Invoke the `superpowers:receiving-code-review` skill** to work through the lead's feedback before re-designing: read all of it before reacting, restate each item in your own words, verify it against the actual ticket and codebase, then respond with a technical acknowledgement or a reasoned pushback. Do not write "You're absolutely right!" Do not thank the lead. If any item is unclear, stop and clarify all of them before changing a line.
- `GROOMED` → abort: "Already groomed; awaiting lead review."
- `APPROVED` and dev → abort: "Already approved. Run `/claim-ticket $ARGUMENTS`."
- `IN_PROGRESS | COMPLETED` → abort: "Past design phase."

## Step 5 — Switch to ticket branch

```bash
git switch {branch-from-frontmatter}
git pull --ff-only
```

## Step 6 — ENTER PLAN MODE, then design (rounds 1–4)

**Invoke the `superpowers:brainstorming` skill** to run these rounds. Three overrides, because this project keeps its design in tickets:

1. **The design artifact is this ticket file.** Do not write `docs/superpowers/specs/*` — write the design into the ticket's `## UI Walkthrough`, `## Data Model`, `## Detailed API Contracts`, `## Test Scenarios`, and `## Test Plan` sections (Step 8).
2. **Do not jump to `writing-plans`.** That is Step 7 of this command, after the risk grill. Brainstorming's hard gate still holds: no code, no scaffolding, until the design is written and the user has approved it.
3. Its "propose 2–3 approaches with trade-offs" step is where **ponytail's ladder** belongs. Before proposing anything: does this need to exist at all? Is it already in this codebase — grep for it. Does the stdlib, a native platform feature, or an already-installed dependency cover it? Recommend the laziest approach that actually holds, and say what you skipped.

Cover, in order:

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

### Round 5 — Risks, dependencies, rollback — GRILL THIS ONE

**Invoke the `grilling` skill** for round 5. This is the round where a bad design gets caught, so it is not a batched questionnaire: one question at a time, each with your recommended answer, walking the decision tree branch by branch. Look facts up (schema, migrations, existing code) rather than asking for them — the *decisions* are the user's, the *facts* are yours to find.

Cover: migration risks, feature flag, depends-on tickets, rollback plan, performance concerns. Do not stop on a question count — stop when the user confirms you have reached a shared understanding.

## Step 7 — Write the Implementation Plan

**Invoke the `superpowers:writing-plans` skill.** One override: the plan is written into this ticket's `## Implementation Plan` section, not `docs/superpowers/plans/*`.

It must produce:
- A `### Global Constraints` block — the verbatim values from the design (response envelope, validation lib, ORM, tenant field, test command). These get copied word-for-word into every implementer prompt in `/build-ticket`, so paraphrasing here is how a constraint gets violated later.
- One `### Task N` per test cycle, each with `**Files:**` (exact paths) and `**Interfaces:**` (exact signatures), then checkbox steps in strict TDD order: write failing test → run and verify RED → minimal implementation → run and verify GREEN → commit.

**No placeholders.** "TBD", "TODO", "add appropriate error handling", "similar to Task 1" — each of those is a plan failure. `/build-ticket` will refuse a ticket whose plan contains them.

## Step 7b — EXIT PLAN MODE

## Step 8 — Insert design sections into ticket

Write: UI Walkthrough, Data Model, Detailed API Contracts, Test Scenarios, Test Plan, Risks, and Implementation Plan.

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

- Do not skip any round. Round 5 is grilled one question at a time — batching it defeats the point.
- The ticket leaves this command with a complete, TBD-free `## Implementation Plan`. That plan is the contract `/build-ticket` executes. A vague plan becomes a vague feature.
- No code. Not one line, not a scaffold, not a "quick stub to check the shape". This command designs.
- Push the branch so leads on other machines can pull.
- Lead self-approval is intentional (they are both author and reviewer).
