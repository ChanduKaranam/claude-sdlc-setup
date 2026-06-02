---
name: handoff
description: Pause a feature mid-build. Writes YAML state to docs/STATE.md, refreshes _active.md, commits and pushes so any dev can resume.
---

You are preparing a session handoff for {{PROJECT_NAME}}. Feature/branch: **$ARGUMENTS** (use current branch if blank).

The handoff has two audiences:
1. **Future Claude** (machine-readable YAML at top of STATE.md)
2. **Future humans** (short narrative below — what you'd say in standup)

## Step 1 — Gather state

```bash
git branch --show-current
git log --oneline -5
git status --short
tail -30 docs/sessions/changes.log 2>/dev/null
```

## Step 2 — Write docs/STATE.md

```yaml
---
ticket: TICKET-XXX
feature: {feature-slug}
branch: {current-branch}
developer: {git config user.name}
timestamp: {ISO-8601 now}
status: IN_PROGRESS
last_action_kind: api_routes
files_in_progress:
  - path: {file}
    status: DONE
  - path: {file}
    status: IN_PROGRESS
blockers: []
estimated_sessions_remaining: 1
---

# Active Session State

> Maintained by /handoff and /resume-session. Don't edit manually.

## What I just did
{2-3 sentence narrative: what was implemented, what tests pass, what was committed.}

## What's next
{One specific next action. Name the file or skill to use first.}

## Notes for the next dev
{Non-obvious gotchas, decisions not to re-litigate.}

## Environment Notes
{Local quirks, env values — only if needed.}
```

## Step 3 — Update _active.md

Set `last_handoff: {ISO-8601 now}` and `estimated_sessions_remaining`.

## Step 4 — Commit and push

```bash
git add docs/STATE.md docs/tickets/_active.md
git commit -m "chore(handoff): {one-line summary of where we left off}"
git push origin {current-branch}
```

## Step 5 — Report

```
Handoff written
Ticket: {id}  Branch: {branch} (pushed)
Last action: {one line}
Next action: {one line}
```

---

## Notes for Claude

- Keep the YAML frontmatter valid — no free text inside the `---` block.
- The narrative should read like standup: terse, concrete.
