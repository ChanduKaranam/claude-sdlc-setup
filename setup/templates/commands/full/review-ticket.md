---
name: review-ticket
description: Lead-only command. Reviews a GROOMED ticket, asks questions, and either approves it or requests changes. Identity-gated — only leads listed in docs/TEAM.md can run this.
---

You are reviewing a groomed ticket for {{PROJECT_NAME}}: **$ARGUMENTS**

## Step 0 — Identity check (leads only)

Read `docs/TEAM.md` YAML frontmatter. Extract `leads:` list.

```bash
git config user.email
```

If the runner's email is **not** in `leads:`, abort:

> "Only leads can run `/review-ticket`. If you need this ticket approved, ask a listed lead to run this command."

## Step 1 — Fetch and read the ticket

```bash
git fetch origin
git switch {branch-from-ticket}
git pull --ff-only
```

Read `docs/tickets/$ARGUMENTS-*.md` in full — all sections.

## Step 2 — ENTER PLAN MODE for lead review

Ask the lead 1–3 focused questions about the ticket design (batched via AskUserQuestion). Focus on:
- Data model correctness and migration safety
- API contract completeness (missing endpoints? wrong error codes?)
- Test plan gaps (missing test layers for the complexity level?)
- Risk assessment (are blockers identified? rollback plan realistic?)

Present a summary of the design for quick approval:
```
## Design Summary: $ARGUMENTS
Goal: {one line}
Data model changes: {brief}
Endpoints: {count + list}
Test plan: {layers + paths}
Risks: {brief}
```

Ask: "Approve this design, or request changes?"

## Step 3 — EXIT PLAN MODE

## Step 4 — Apply decision

**If APPROVED:**
- Set `status: APPROVED`, `approved_by: {email}`, `approved_at: {ISO-8601 now}` in frontmatter.
- Remove ticket from `_active.md` Pending Lead Review table.
- Commit: `chore: approve $ARGUMENTS`

**If CHANGES REQUESTED:**
- Set `status: CHANGES_REQUESTED`, `last_feedback_by: {email}`, `last_feedback_at: {ISO-8601 now}`.
- Append `## Lead Feedback (Round {grooming_round})` section with numbered change requests.
- Commit: `chore: request changes on $ARGUMENTS`

Push in both cases: `git push origin {branch}`

## Step 5 — Report

Print outcome summary and next steps (who needs to act).

---

## Notes for Claude

- Identity check is non-negotiable. No bypasses.
- Feedback must be numbered and specific — "unclear" is not actionable.
- Preserve all prior Lead Feedback sections verbatim when adding a new one.
