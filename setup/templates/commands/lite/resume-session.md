---
name: resume-session
description: Resume a paused feature session — reads docs/STATE.md and docs/tickets/_active.md, restores context, confirms before acting.
---

Branch / feature to resume: **$ARGUMENTS** (blank = read most recent active claim from `docs/tickets/_active.md`)

## Step 1 — Read the state files

1. Read `docs/STATE.md` (active session-state block).
2. Read `docs/tickets/_active.md` to confirm which ticket is claimed and by whom.
3. Read the ticket file referenced in `_active.md`.

If no active claim exists, ask: "No active session found. Use `/new-feature {name}` for a fresh start?"

## Step 2 — Detect ownership

Compare the developer in `_active.md` against `git config user.name`.

- Same dev → continuing your own work; proceed.
- Different dev → confirm: "This ticket is claimed by {original-dev}. Are you taking over? (yes/no)"
  - Yes: update `_active.md`, add takeover line to `docs/sessions/_takeovers.log`.
  - No: stop.

## Step 3 — Confirm understanding

Print a structured block:

```
RESUMING SESSION
Ticket:        {id} — {feature}
Branch:        {branch}
Last handoff:  {timestamp}
Last action:   {from STATE.md}
Next action:   {from STATE.md}
Blockers:      {list or NONE}
```

## Step 4 — Restore git context

```bash
git fetch origin
git switch {branch}
git pull --ff-only origin {branch}
git log --oneline -5
git status
```

Read every file listed under "Files in Progress" in STATE.md.

## Step 5 — Confirm before acting

> "Context restored. Ready to continue: {next action}. Type GO to proceed."

Do NOT start work until the developer types GO.

---

## Notes for Claude

- Never silently take over another dev's claim. Always ask.
- The takeover audit line in _takeovers.log is non-negotiable.
