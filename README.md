# claude-sdlc-setup

A one-command installer for the `/setup` Claude Code skill — bootstraps a complete **AI-assisted SDLC scaffold** into any repo in ~5 minutes.

Running `/setup` in Claude Code will interview you about your project, analyze the codebase, then generate a tailored `.claude/` directory (hooks, rules, agents, commands, skills, `settings.json`), a `docs/` scaffold (tickets, STATE, PLAYBOOK, DESIGN, ADRs), and a root `CLAUDE.md` operating manual — for solo projects or full teams.

---

## 📖 Start here — read the guide

**[`docs/guide.html`](docs/guide.html)** is the operating manual. Open it in a browser (it's one self-contained file — no build step, no network):

```sh
open docs/guide.html          # macOS
xdg-open docs/guide.html      # Linux
start docs/guide.html         # Windows
```

It walks through the whole process end to end: how to install, what `/setup` writes, every slash command and the skills it runs, a worked example of your first feature from scope to merged PR, and the four gates that will stop you. If you only read one thing before running `/setup`, read that.

---

The generated pipeline doesn't improvise a process. Every phase runs a real methodology:

| Phase | Command | What it runs |
|-------|---------|--------------|
| Scope | `/new-feature` | ponytail's first rung — does this feature need to exist at all? |
| Design | `/groom-ticket` · `/work-ticket` | `superpowers:brainstorming`, then `grilling` for the risk round — one question at a time |
| Plan | *(no new command — the design command doesn't exit until the plan exists)* | `superpowers:writing-plans` → the ticket's `## Implementation Plan` |
| Review | `/review-ticket` | `grilling` + `ponytail:ponytail-review` on the plan, before a line of code exists |
| **Build** | **`/build-ticket`** | `superpowers:test-driven-development` per task — no production code without a failing test first. `systematic-debugging` when something breaks. Code review after each task. |
| Fix | `/fix-bug` | `grilling` the report, `systematic-debugging` to root cause, then a **hard stop** — you confirm the diagnosis and its blast radius before a line is written. Then failing-test-first, fixed at the root. |
| Restyle | `/ui-fix` | For visual changes only — no ticket, no plan, no test. `frontend-design` + `ui-rules` for the design, ponytail for the diff, and the `design-review` agent for the proof (screenshots at 1440 and 390). Greps every render site first: a shared atom is not a local change. |
| Ship | `/complete-feature` | `superpowers:verification-before-completion` — no claim without the command output that proves it, in the message that claims it |

---

## Prerequisites

The generated commands invoke two Claude Code plugins:

| Plugin | Provides |
|--------|----------|
| [`superpowers`](https://github.com/obra/superpowers) | brainstorming, writing-plans, TDD, systematic-debugging, verification-before-completion, code review, worktrees |
| `frontend-design` | the visual design pass used by `/ui-fix` |
| [`ponytail`](https://github.com/DietrichGebert/ponytail) | the YAGNI ladder, `ponytail-review`, `ponytail-debt` |

**You don't need to install these yourself.** The `.claude/settings.json` that `/setup` writes declares both, so Claude Code offers to install them the next time anyone opens the repo — including your teammates. (`grilling` is vendored directly into the project as a skill, so it needs nothing.)

If you'd rather have them globally, in Claude Code:

```
/plugin marketplace add anthropics/claude-plugins-official
/plugin install superpowers@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin marketplace add DietrichGebert/ponytail
/plugin install ponytail@ponytail
```

---

## Install

### Windows (PowerShell)

```powershell
irm https://raw.githubusercontent.com/ChanduKaranam/claude-sdlc-setup/main/install.ps1 | iex
```

### macOS / Linux

```sh
curl -fsSL https://raw.githubusercontent.com/ChanduKaranam/claude-sdlc-setup/main/install.sh | sh
```

---

## What gets installed

| Path | What |
|------|------|
| `~/.claude/skills/setup/` | The skill and all its templates |
| `~/.claude/CLAUDE.md` | `/setup` trigger appended (idempotent) |

Re-running the installer backs up any existing `~/.claude/skills/setup/` to `setup.bak-<timestamp>` before replacing it.

---

## Usage

After installing, open **any** project directory in Claude Code and type:

```
/setup
```

Claude will:
1. Detect your stack (language, framework, ORM, CI)
2. Run a short interview (branches, team size, aesthetic, roster)
3. Enter extended thinking to plan the scaffold
4. Show you the full file list for approval
5. Write everything — skipping files that already exist

Then restart Claude Code (or run `/plugin`) so superpowers and ponytail load, and run `/new-feature`.

---

## Manual install

If you prefer not to pipe to shell:

```sh
git clone https://github.com/ChanduKaranam/claude-sdlc-setup.git
cp -R claude-sdlc-setup/setup ~/.claude/skills/setup
```

Then add this block to `~/.claude/CLAUDE.md`:

```markdown
# setup
- **setup** (`~/.claude/skills/setup/SKILL.md`) - Bootstraps a complete AI-assisted SDLC scaffold into any repo. Trigger: /setup
When the user types /setup, invoke the Skill tool with `skill: "setup"` before doing anything else.
```

---

## Uninstall

```sh
rm -rf ~/.claude/skills/setup
# Then remove the "# setup" block from ~/.claude/CLAUDE.md
```

```powershell
Remove-Item -Recurse -Force "$HOME\.claude\skills\setup"
# Then remove the "# setup" block from $HOME\.claude\CLAUDE.md
```

---

## License

MIT — see [LICENSE](LICENSE).
