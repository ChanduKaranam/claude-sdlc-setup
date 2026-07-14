---
name: setup
description: Bootstraps a complete AI-assisted SDLC scaffold into any repo — empty or existing. Runs a deep interview, analyzes existing code, enters extended thinking, then generates rules, hooks, agents, commands, skills, ticketing system, and CLAUDE.md tailored to the project. The generated pipeline runs on the superpowers, ponytail, and grilling skills end to end. Trigger: /setup
trigger: /setup
---

# /setup Skill

## What this skill does

Takes any repo — empty or an existing codebase — and generates a complete Claude Code AI-SDLC scaffold. The output is a .claude/ directory (rules, hooks, agents, commands, skills, settings.json) plus a docs/ scaffold (tickets, STATE.md, TEAM.md, PLAYBOOK.md, and optionally DESIGN.md and ADRs), and a root CLAUDE.md operating manual — all tailored to the specific project by interview.

The generated pipeline is not a set of freehand instructions. Every phase runs a real methodology:

| Phase | Command | Skills it runs |
|-------|---------|----------------|
| Scope | `/new-feature` | ponytail's first rung — does this need to exist at all? |
| Design | `/groom-ticket` (team) · `/work-ticket` (solo) | `superpowers:brainstorming` for the design, `grilling` for the risk round |
| Plan | same command | `superpowers:writing-plans` → the ticket's `## Implementation Plan` |
| Design review | `/review-ticket` (team) | `grilling` + `ponytail:ponytail-review` on the plan |
| Build | `/build-ticket` | `superpowers:subagent-driven-development` or `executing-plans`, `test-driven-development` per task, `systematic-debugging` on failure, `requesting-code-review` + `receiving-code-review` per task |
| Fix | `/fix-bug` | `grilling` on the report, `systematic-debugging` to root cause, **a hard stop for human confirmation of the diagnosis**, then `test-driven-development` (failing reproduction test first) and `verification-before-completion` (red-green proven) |
| Ship | `/complete-feature` | `superpowers:verification-before-completion`, both review lenses, `ponytail:ponytail-debt`, `finishing-a-development-branch` |

## When to invoke

The user types /setup when:
- Starting a brand-new project and wanting the full AI-SDLC from day one.
- Onboarding an existing codebase into this workflow.
- Generating the setup for a team that uses a different stack than the reference implementation.

---

## INSTRUCTIONS FOR THE AGENT

You are executing the /setup skill. Follow every step below in strict order. Do not write any files until Step 7 (after user approval of the generation plan in Step 5). Read everything before writing anything.

Templates live at: ~/.claude/skills/setup/templates/ — read them, fill placeholders, write to the target repo. NEVER modify the templates themselves.

---

### Step 0 — Announce

Tell the user what /setup will do: analyze the repo, run a 5-6 batch interview, enter extended thinking, show the generation plan for approval, then write all files without overwriting existing ones. Expected time: ~5 minutes.

---

### Step 1 — Safety check

Run: git status 2>/dev/null

If the working tree is dirty, warn and ask whether to continue. If no, stop.

Run: ls -la .claude/ 2>/dev/null

If .claude/ already exists, announce AUGMENT MODE: existing files will be skipped, only missing files generated.

**Plugin prerequisites.** The generated commands invoke the `superpowers` and `ponytail` plugins. The `settings.json` you write in Step 7 declares both (`extraKnownMarketplaces` + `enabledPlugins`), so Claude Code will offer to install them for anyone who opens this repo — including the user, on their next session here. Nothing to install now. Just tell the user at the end (Step 8) that the plugins load on the next session, and that the commands will not work until they do.

---

### Step 2 — Detect repo state

Run: git log --oneline -5 2>/dev/null

If no commits, skip analysis and go to Step 3.

Otherwise glob **/* (skip: node_modules, .git, dist, build, .next, __pycache__, *.lock, *.log). Read in parallel (first 80 lines each):
- package.json / pyproject.toml / go.mod / Cargo.toml
- Framework configs: next.config.*, vite.config.*, app.py, main.go
- ORM: prisma/schema.prisma, drizzle.config.*, alembic.ini
- CI: .github/workflows/*.yml, .gitlab-ci.yml

Build an analysis brief (language, package manager, monorepo, surfaces, test framework, ORM, CI) and show it for confirmation before the interview begins.

---

### Step 3 — Interview (ENTER PLAN MODE)

Enter Plan Mode. Run interview in batched AskUserQuestion calls (max 4 per batch).

These are configuration questions — facts and preferences, not design decisions. Batching is correct here. (The generated *commands* grill their design rounds one question at a time; this is not one of those.)

BATCH 1 — Project identity
1. What is this project? One sentence. (pre-fill name from package.json)
2. Solo project or team? (solo = no review gates; team = full leads/devs pipeline with groom/review/approve)
3. Confirm or correct detected surfaces. Any missing or to remove?
4. Primary language/framework per surface? (pre-fill from analysis; confirm or correct)

BATCH 2 — Branches and deployment
1. Main/base branch? (default: main)
2. Feature PRs target which branch? (default: integration for teams, main for solo)
3. Protected branches, pipe-separated (e.g. main|develop|integration|prod):
4. Dev environment promotion branch? (e.g. develop — or "none" for solo)

BATCH 3 — Tech-specific rules (if backend detected)
1. API response envelope? (e.g. { success, data } / { status, result } / none/bare)
2. Validation library? (e.g. Zod / Yup / Joi / Pydantic / none)
3. Shared schemas path? (e.g. packages/shared / src/schemas)
4. ORM / migration tool? (pre-filled from detection — confirm or correct)

BATCH 4 — Permissions and hooks
1. Which shell command families should be auto-allowed? (pre-select based on detected package manager + test runner)
2. Enable context-budget nag at 50/80 tool calls? (recommended: yes)
3. Enable mockup-image blocker under docs/? (recommended: yes for teams)
4. Enable token ledger per session? (recommended: yes)

BATCH 5 — Frontend/visual (only if frontend surfaces detected)
1. Visual aesthetic in 2-3 words (e.g. Editorial Minimal, Playful Consumer, Dense Enterprise):
2. UI component library? (e.g. shadcn/ui, Radix, MUI, custom, none)
3. State/query library? (e.g. TanStack Query, SWR, Redux, Zustand, none)
4. Form library? (e.g. react-hook-form, Formik, none)

BATCH 6 — Team roster (only if team mode)
1. Your name (will be added to TEAM.md as first lead):
2. Your email (same as git config user.email):
3. Your GitHub username:
4. Add other team members now? Format: name|email|github|role per line, or "skip"

---

### Step 4 — Extended thinking synthesis

After the interview, enter extended thinking mode. Think through:

A. PIPELINE MODE — full (team) or lite (solo)?
- Solo: lite commands (new-feature, work-ticket, build-ticket, complete-feature, handoff, resume-session). No TEAM.md, no groom/review commands, no Pending Lead Review in _active.md.
- Team: all 10 full commands. TEAM.md with leads/devs roster. Groom/review/approve gates.

B. SURFACE RULES — one .md per detected surface (api, web, mobile, shared, db) with path-scoped globs.

C. AGENTS — which apply?
- Always: code-reviewer (it is the reviewer that `superpowers:requesting-code-review` dispatches — it is not optional)
- Backend: api-builder, schema-designer
- Frontend: frontend-architect, design-review
- Docker/CI detected: devops-agent

D. SKILL SEEDS — only for detected surfaces:
- Always: grilling (the design rounds and the lead review invoke it by name — generate it even for solo)
- Backend always: api-contracts, db-conventions, testing-patterns
- Frontend: ui-rules, component-patterns, state-management, forms, error-handling

**Apply the ponytail ladder to the generation plan itself.** Do not emit a file that has no consumer. No `forms` skill if nothing renders a form. No `devops-agent` if there is no Dockerfile and no CI. No `db-conventions` if there is no database. Every generated file is a file someone has to read, keep true, and eventually delete. The scaffold should be the smallest one that actually holds — say what you skipped and why in the Step 5 manifest.

E. HOOK TYPE (OS + jq detection):
  Run: uname -s 2>/dev/null || echo "Windows"
  Run: which jq 2>/dev/null || where jq 2>/dev/null
  - Linux/macOS, or Windows+jq found: bash hooks (.sh)
  - Windows + no jq: Node.js hooks (.js)

F. PLACEHOLDER VALUES — compile a complete mapping of every {{PLACEHOLDER}} to its resolved value from the interview and analysis. Key ones:
  - {{PROJECT_NAME}}, {{PROJECT_DESCRIPTION}}, {{BASE_BRANCH}}, {{PR_TARGET_BRANCH}}
  - {{PROTECTED_BRANCHES}} (pipe-separated), {{PROTECTED_BRANCHES_CASE}} (bash case pattern), {{PROTECTED_BRANCHES_ARRAY}} (JS array elements)
  - {{INTEGRATION_BRANCH}}, {{DEV_BRANCH}}, {{PROD_BRANCH}}
  - {{PKG_MGR}}, {{TEST_CMD}}, {{LINT_CMD}}, {{TYPECHECK_CMD}}
  - {{RESPONSE_ENVELOPE}}, {{VALIDATION_LIB}}, {{SHARED_SCHEMAS_PATH}}, {{ORM}}
  - {{SCHEMA_FILE}}, {{MIGRATION_CMD}}, {{GENERATE_CMD}}, {{TENANT_ID_FIELD}}, {{AUTH_MIDDLEWARE}}
  - {{API_STACK}}, {{API_MODULE_PATH}}
  - {{AESTHETIC_FAMILY}}, {{FORM_LIB}}, {{QUERY_LIB}}, {{GLOBAL_STATE_LIB}}
  - {{FRONTEND_CONSTRAINTS}}, {{LAYOUT_PRINCIPLES}}, {{COLOR_TOKENS}}, {{TYPE_TOKENS}}, {{SPACING_TOKENS}}
  - {{DESIGN_INSPIRATIONS}}, {{DESIGN_DESCRIPTION}}, {{COMPOSITION_RULES}}, {{FONT_SPEC}}, {{PALETTE_SPEC}}
  - {{SURFACE_1}}, {{SURFACE_2}}, {{SURFACE_1_TREATMENT}}, {{SURFACE_2_TREATMENT}}
  - {{CI_PLATFORM}}, {{CONTAINER_PLATFORM}}, {{DEPLOY_PLATFORM}}
  - {{TEST_LAYERS}}, {{TEST_LAYERS_TABLE}}, {{TEST_PLAN_LAYERS}}, {{INTEGRATION_TEST_PATH}}, {{SHARED_TEST_PATH}}
  - {{TEST_FRAMEWORK}}, {{TEST_INJECT_PATTERN}}, {{HTTP_VERB}} — used by the testing-patterns and api-contracts skill templates
  - {{SURFACE_KEYS}}, {{FRONTEND_SKILLS_REF}}, {{WEB_ROUTES_SECTION}}, {{MOBILE_SCREENS_SECTION}}
  - {{ACCEPTANCE_CRITERIA}}, {{STACK_TABLE}}, {{CODE_RULES}}, {{DOMAIN_MAP}}
  - {{AGENTS_LIST}}, {{SKILLS_LIST}}, {{COMMANDS_LIST}}, {{COMMANDS_CHEAT_SHEET}}, {{TICKET_PIPELINE_NOTE}}
  - {{GROOM_STEP_REF}} — the design command as referenced in CLAUDE.md's Process section: "/groom-ticket → /review-ticket" (team) or "/work-ticket" (solo)
  - {{REVIEW_TICKET_ROW}}, {{GROOM_STEP}}, {{REVIEW_STEP}}, {{DEPLOY_ROWS}}, {{DB_CHECKLIST}}
  - {{LEAD_1_NAME}}, {{LEAD_1_EMAIL}}, {{LEAD_1_GITHUB}}, {{SETUP_DATE}}
  - {{HOOK_CMD_BRANCH}}, {{HOOK_CMD_NAG}}, {{HOOK_CMD_SNAPSHOT}}
  - {{EXTRA_ALLOW}}, {{EXTRA_DENY}}, {{MOCKUP_HOOK}}, {{TOKEN_LEDGER_HOOK}}, {{SCHEMA_REMINDER_HOOK}}
  - {{SURFACE_GLOB}}, {{SURFACE_NAME}}, {{SURFACE_RULES}}, {{PRIMARY_SKILL}}
  - {{SURFACES}}, {{SURFACE_SPECIFIC_Q}}, {{DEV_DEPLOY_TRIGGER}}, {{DEPLOY_BRANCHES}}

G. Write the generation manifest as the plan content: a table listing every file to be written, its source template, and key placeholder values. Include a line naming what you deliberately did NOT generate, and why.

---

### Step 5 — EXIT PLAN MODE

Call ExitPlanMode with the generation manifest as the plan. The user must approve the exact file list before any write.

---

### Step 6 — OS detection (post-approval, before writing)

Run: uname -s 2>/dev/null || echo "Windows"
Run: which jq 2>/dev/null || where jq 2>/dev/null

Set HOOK_EXT = sh (bash) or js (node). Set HOOK_CMD_PREFIX = bash or node.

---

### Step 7 — Write files in dependency order

Never overwrite a file that already exists. Glob-check before each Write. Track skipped files for the report.

LAYER 1 — .claude/hooks/
Read from ~/.claude/skills/setup/templates/hooks/bash/ or .../node/ based on OS detection. Fill {{PROTECTED_BRANCHES_CASE}} or {{PROTECTED_BRANCHES_ARRAY}} placeholder. Write to .claude/hooks/:
- block-protected-branch.{sh|js} — always
- context-budget-nag.{sh|js} — if opted in (default yes)
- block-mockup-images.{sh|js} — if opted in (default yes for teams)
- post-session-snapshot.{sh|js} — always
- session-end-rollup.sh — if token ledger opted in (default yes). NOTE: bash only. There is no node twin. If the node path was taken, say so plainly in the completion report — the token ledger will not exist — rather than writing a settings.json that references a hook that isn't there.

LAYER 2 — .claude/settings.json
Read ~/.claude/skills/setup/templates/settings.json.tmpl. Fill all hook command references (bash vs node path) and the permissions allow/deny arrays from Batch 4 answers.

Its `extraKnownMarketplaces` and `enabledPlugins` keys are already filled in — do not touch them. They declare the `superpowers` and `ponytail` plugins that the generated commands invoke, and they are what makes this scaffold portable: a teammate cloning the repo gets both offered on their first session.

Watch the commas. The `{{EXTRA_ALLOW}}` token sits mid-array and its value must end with a trailing comma (or be empty); `{{EXTRA_DENY}}`, `{{MOCKUP_HOOK}}`, `{{SCHEMA_REMINDER_HOOK}}` and `{{TOKEN_LEDGER_HOOK}}` each follow a complete entry and must begin with a leading comma (or be empty). The template is not valid JSON until it is rendered. **After writing it, verify: `jq . .claude/settings.json`.** If that fails, the scaffold is broken on session one.

Write to .claude/settings.json.

LAYER 3 — .claude/rules/
For each detected surface, fill ~/.claude/skills/setup/templates/rules/rule.md.tmpl with:
- {{SURFACE_GLOB}}: language-appropriate glob (e.g. "src/**/*.{ts,py,go}" adapted to detected language)
- {{SURFACE_NAME}}: human name (e.g. "API (src/api/**)")
- {{SURFACE_RULES}}: 3-5 non-negotiable rules for this surface
- {{PRIMARY_SKILL}}: the main skill to load (e.g. api-contracts, ui-rules)
Write to .claude/rules/{surface}.md.

LAYER 4 — .claude/skills/
For each applicable skill, read ~/.claude/skills/setup/templates/skills/{skill}/SKILL.md. Fill ALL {{PLACEHOLDER}} tokens. Write to .claude/skills/{skill}/SKILL.md. Create the directory first.

**`grilling` is always generated**, solo or team, and it has no placeholders — copy it verbatim. The design rounds in `/groom-ticket` and `/work-ticket` and the lead review in `/review-ticket` all invoke it by name. It is vendored into the project rather than assumed present on the user's machine, because it is a personal skill and not a plugin.

LAYER 5 — .claude/agents/
For each applicable agent, read ~/.claude/skills/setup/templates/agents/{agent}.md.tmpl. Fill. Write to .claude/agents/{agent}.md.

`code-reviewer` is always generated. `superpowers:requesting-code-review` dispatches it from both `/build-ticket` and `/complete-feature` — without it, those review gates have no reviewer.

LAYER 6 — .claude/commands/
Read from ~/.claude/skills/setup/templates/commands/full/ (team) or .../lite/ (solo).
Fill all {{PLACEHOLDER}} tokens. Write to .claude/commands/{name}.md.

Full (11): new-feature, groom-ticket, review-ticket, claim-ticket, **build-ticket**, **fix-bug**, complete-feature, handoff, resume-session, dev-deploy, prod-deploy.
Lite (7): new-feature, work-ticket, **build-ticket**, **fix-bug**, complete-feature, handoff, resume-session.

`build-ticket` is where code gets written. Without it the pipeline designs a feature and then stops at the edge of implementing it.

`fix-bug` is the same discipline pointed at a shipped feature: grill the report, reproduce it, trace the root cause, **stop for human confirmation of the diagnosis**, then failing-test-first and fix at the root. It writes a slim BUG ticket rather than dragging a two-line fix through the feature template, and it hands off to `/complete-feature` rather than duplicating its gates.

LAYER 7 — docs/
Create directories if missing: docs/tickets, docs/decisions, docs/sessions
Write (skip if exists):
- docs/tickets/_TEMPLATE.md ← templates/docs/tickets/_TEMPLATE.md (fill surface-specific placeholders). Its `## Implementation Plan` section is the contract between the design commands and `/build-ticket` — keep its task structure (Files / Interfaces / TDD checkbox steps) intact.
- docs/tickets/_BUG_TEMPLATE.md ← templates/docs/tickets/_BUG_TEMPLATE.md (no placeholders — copy verbatim). The slim ticket `/fix-bug` writes: symptom, reproduction, root cause, blast radius, the fix, the regression test. Its `## Root Cause` and `## Blast Radius` sections are what the human confirms before any code is written.
- docs/tickets/_active.md ← templates/docs/tickets/_active.md.tmpl
- docs/STATE.md ← templates/docs/STATE.md.tmpl
- docs/TEAM.md ← templates/docs/TEAM.md.tmpl (team mode only — fill lead info)
- docs/PLAYBOOK.md ← templates/docs/PLAYBOOK.md.tmpl
- docs/DESIGN.md ← templates/docs/DESIGN.md.tmpl (frontend surfaces only — fill aesthetic + palette)
- docs/decisions/ADR-TEMPLATE.md ← templates/docs/decisions/ADR-TEMPLATE.md
- docs/sessions/.gitkeep ← empty marker file

LAYER 8 — CLAUDE.md (last, richest)
Read ~/.claude/skills/setup/templates/CLAUDE.md.tmpl. Fill all placeholders:
- {{STACK_TABLE}}: markdown table of layer/tech/path for each surface
- {{CODE_RULES}}: 4-6 non-negotiable rules derived from the interview (TypeScript strict? ORM-only? Response envelope?)
- {{DOMAIN_MAP}}: markdown table of feature domains (inferred from analysis or left as "not started" stubs)
- {{AGENTS_LIST}}: dot-separated list of agent names that were generated
- {{SKILLS_LIST}}: dot-separated list of skill names that were generated
- {{COMMANDS_LIST}}: slash commands with one-line descriptions
- {{GROOM_STEP_REF}}: "/groom-ticket → /review-ticket" (team) or "/work-ticket" (solo)
- {{TICKET_PIPELINE_NOTE}}: team-mode pipeline note, or omit for solo
- {{GENERATE_CMD}} and {{SCHEMA_FILE}}: for the "Before starting any work" checklist

Its `## Process — non-negotiable` section is pre-written and load-bearing. CLAUDE.md is the only file Claude reads every single session, so it is the one place the TDD iron law and the verification iron law are guaranteed to land. Do not trim it for brevity.

Write to CLAUDE.md in the repo root.

---

### Step 8 — Completion report

Print a formatted summary (see Important rules section for format). Include: every file written, every file skipped, pipeline mode, surfaces, hook type, and the next steps.

---

## Important rules

1. Read templates before filling. Always Read the template file first; then substitute {{PLACEHOLDER}} tokens.
2. Never write to the templates directory. All writes go to the target repo. ~/.claude/skills/setup/templates/ is read-only source material.
3. Never overwrite existing files. Glob-check before every Write. Skip and report at the end.
4. Fill every {{PLACEHOLDER}} before writing. An unfilled placeholder in a written file is a bug.
5. Infer from codebase first. Do not ask what you can detect. Reserve interview questions for decisions that genuinely cannot be inferred. (This is grilling's rule, applied to /setup itself: facts get looked up, decisions get asked.)
6. Hook type is automatic. Detect OS and jq. The user does not choose. Report what was detected.
7. Augment mode is silent. Skip existing files without asking. List them in the completion report.
8. Use today's date (from the currentDate context injection) for all {{SETUP_DATE}} placeholders.
9. Lite mode omits: TEAM.md, groom-ticket command, review-ticket command, claim-ticket command, deploy commands, Pending Lead Review section in _active.md. Replace review references in PLAYBOOK.md with "(solo — no review step)". Lite mode does NOT omit build-ticket, fix-bug, or grilling — solo developers need the build phase, the bug discipline, and the design grill more than teams do, because nobody else is going to catch a bad design or a symptom-level patch.
10. Do not paraphrase a skill into the commands. The commands *invoke* skills by name (`superpowers:test-driven-development`, `ponytail:ponytail-review`, `grilling`) and then constrain their output (e.g. "write the design into the ticket, not docs/superpowers/specs/"). Rewriting a skill's content inline means it goes stale the moment upstream changes.
11. Verify settings.json parses (`jq . .claude/settings.json`) before reporting success. It is the one generated file that can be syntactically broken.
12. Hook JSON contract (both bash and node): blocking = {"block":true,"message":"..."} to stderr + exit 2; advisory = {"feedback":"..."} to stdout + exit 0. Bash hooks read $CLAUDE_TOOL_INPUT (PreToolUse/PostToolUse) or stdin via cat (Stop event). Node hooks use process.env.CLAUDE_TOOL_INPUT and process.stdin respectively.
13. Completion report format:
    /setup complete
    Project: {name}
    Pipeline: {full/lite}
    Surfaces: {list}
    Hook type: {bash/node}
    Files written: {list}
    Files skipped: {list or "none"}
    Not generated: {what the ponytail pass cut, and why}
    Next steps:
    1. Restart Claude Code (or run /plugin) so the superpowers and ponytail plugins load — the commands invoke them and will not work until they do.
    2. {team/solo roster note}
    3. Review CLAUDE.md — especially the "Process — non-negotiable" section.
    4. Commit: git add .claude/ docs/ CLAUDE.md && git commit -m "chore: bootstrap AI-SDLC via /setup"
    5. /new-feature {your-first-feature}
