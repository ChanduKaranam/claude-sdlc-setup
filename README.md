# claude-sdlc-setup

A one-command installer for the `/setup` Claude Code skill — bootstraps a complete **AI-assisted SDLC scaffold** into any repo in ~5 minutes.

Running `/setup` in Claude Code will interview you about your project, analyze the codebase, then generate a tailored `.claude/` directory (hooks, rules, agents, commands, skills, `settings.json`), a `docs/` scaffold (tickets, STATE, PLAYBOOK, DESIGN, ADRs), and a root `CLAUDE.md` operating manual — for solo projects or full teams.

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
