---
name: setup
description: Bootstraps a complete AI-assisted SDLC scaffold into any repo â€” empty or existing. Runs a deep interview, analyzes existing code, enters extended thinking, then generates rules, hooks, agents, commands, skills, ticketing system, and CLAUDE.md tailored to the project. Trigger: /setup
trigger: /setup
---

# /setup Skill

## What this skill does

Takes any repo â€” empty or an existing codebase â€” and generates a complete Claude Code AI-SDLC scaffold. The output is a .claude/ directory (rules, hooks, agents, commands, skills, settings.json) plus a docs/ scaffold (tickets, STATE.md, TEAM.md, PLAYBOOK.md, and optionally DESIGN.md and ADRs), and a root CLAUDE.md operating manual â€” all tailored to the specific project by interview.

## When to invoke

The user types /setup when:
- Starting a brand-new project and wanting the full AI-SDLC from day one.
- Onboarding an existing codebase into this workflow.
- Generating the setup for a team that uses a different stack than the reference implementation.

---

## INSTRUCTIONS FOR THE AGENT

You are executing the /setup skill. Follow every step below in strict order. Do not write any files until Step 7 (after user approval of the generation plan in Step 5). Read everything before writing anything.

Templates live at: ~/.claude/skills/setup/templates/ â€” read them, fill placeholders, write to the target repo. NEVER modify the templates themselves.

---

### Step 0 â€” Announce

Tell the user what /setup will do: analyze the repo, run a 5-6 batch interview, enter extended thinking, show the generation plan for approval, then write all files without overwriting existing ones. Expected time: ~5 minutes.

---

### Step 1 â€” Safety check

Run: git status 2>/dev/null

If the working tree is dirty, warn and ask whether to continue. If no, stop.

Run: ls -la .claude/ 2>/dev/null

If .claude/ already exists, announce AUGMENT MODE: existing files will be skipped, only missing files generated.

---

### Step 2 â€” Detect repo state

Run: git log --oneline -5 2>/dev/null

If no commits, skip analysis and go to Step 3.

Otherwise glob **/* (skip: node_modules, .git, dist, build, .next, __pycache__, *.lock, *.log). Read in parallel (first 80 lines each):
- package.json / pyproject.toml / go.mod / Cargo.toml
- Framework configs: next.config.*, vite.config.*, app.py, main.go
- ORM: prisma/schema.prisma, drizzle.config.*, alembic.ini
- CI: .github/workflows/*.yml, .gitlab-ci.yml

Build an analysis brief (language, package manager, monorepo, surfaces, test framework, ORM, CI) and show it for confirmation before the interview begins.

---

### Step 3 â€” Interview (ENTER PLAN MODE)

Enter Plan Mode. Run interview in batched AskUserQuestion calls (max 4 per batch).

BATCH 1 â€” Project identity
1. What is this project? One sentence. (pre-fill name from package.json)
2. Solo project or team? (solo = no review gates; team = full leads/devs pipeline with groom/review/approve)
3. Confirm or correct detected surfaces. Any missing or to remove?
4. Primary language/framework per surface? (pre-fill from analysis; confirm or correct)

BATCH 2 â€” Branches and deployment
1. Main/base branch? (default: main)
2. Feature PRs target which branch? (default: integration for teams, main for solo)
3. Protected branches, pipe-separated (e.g. main|develop|integration|prod):
4. Dev environment promotion branch? (e.g. develop â€” or "none" for solo)

BATCH 3 â€” Tech-specific rules (if backend detected)
1. API response envelope? (e.g. { success, data } / { status, result } / none/bare)
2. Validation library? (e.g. Zod / Yup / Joi / Pydantic / none)
3. Shared schemas path? (e.g. packages/shared / src/schemas)
4. ORM / migration tool? (pre-filled from detection â€” confirm or correct)

BATCH 4 â€” Permissions and hooks
1. Which shell command families should be auto-allowed? (pre-select based on detected package manager + test runner)
2. Enable context-budget nag at 50/80 tool calls? (recommended: yes)
3. Enable mockup-image blocker under docs/? (recommended: yes for teams)
4. Enable token ledger per session? (recommended: yes)

BATCH 5 â€” Frontend/visual (only if frontend surfaces detected)
1. Visual aesthetic in 2-3 words (e.g. Editorial Minimal, Playful Consumer, Dense Enterprise):
2. UI component library? (e.g. shadcn/ui, Radix, MUI, custom, none)
3. State/query library? (e.g. TanStack Query, SWR, Redux, Zustand, none)
4. Form library? (e.g. react-hook-form, Formik, none)

BATCH 6 â€” Team roster (only if team mode)
1. Your name (will be added to TEAM.md as first lead):
2. Your email (same as git config user.email):
3. Your GitHub username:
4. Add other team members now? Format: name|email|github|role per line, or "skip"

---

### Step 4 â€” Extended thinking synthesis

After the interview, enter extended thinking mode. Think through:

A. PIPELINE MODE â€” full (team) or lite (solo)?
- Solo: lite commands (new-feature, work-ticket, complete-feature, handoff, resume-session). No TEAM.md, no groom/review commands, no Pending Lead Review in _active.md.
- Team: all 9 full commands. TEAM.md with leads/devs roster. Groom/review/approve gates.

B. SURFACE RULES â€” one .md per detected surface (api, web, mobile, shared, db) with path-scoped globs.

C. AGENTS â€” which apply?
- Always: code-reviewer
- Backend: api-builder, schema-designer
- Frontend: frontend-architect, design-review
- Docker/CI detected: devops-agent

D. SKILL SEEDS â€” only for detected surfaces:
- Backend always: api-contracts, db-conventions, testing-patterns
- Frontend: ui-rules, component-patterns, state-management, forms, error-handling

E. HOOK TYPE (OS + jq detection):
  Run: uname -s 2>/dev/null || echo "Windows"
  Run: which jq 2>/dev/null || where jq 2>/dev/null
  - Linux/macOS, or Windows+jq found: bash hooks (.sh)
  - Windows + no jq: Node.js hooks (.js)

F. PLACEHOLDER VALUES â€” compile a complete mapping of every {{PLACEHOLDER}} to its resolved value from the interview and analysis. Key ones:
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
  - {{SURFACE_KEYS}}, {{FRONTEND_SKILLS_REF}}, {{WEB_ROUTES_SECTION}}, {{MOBILE_SCREENS_SECTION}}
  - {{ACCEPTANCE_CRITERIA}}, {{STACK_TABLE}}, {{CODE_RULES}}, {{DOMAIN_MAP}}
  - {{AGENTS_LIST}}, {{SKILLS_LIST}}, {{COMMANDS_LIST}}, {{TICKET_PIPELINE_NOTE}}
  - {{REVIEW_TICKET_ROW}}, {{GROOM_STEP}}, {{REVIEW_STEP}}, {{DEPLOY_ROWS}}
  - {{LEAD_1_NAME}}, {{LEAD_1_EMAIL}}, {{LEAD_1_GITHUB}}, {{SETUP_DATE}}
  - {{HOOK_CMD_BRANCH}}, {{HOOK_CMD_NAG}}, {{HOOK_CMD_SNAPSHOT}}
  - {{EXTRA_ALLOW}}, {{EXTRA_DENY}}, {{MOCKUP_HOOK}}, {{TOKEN_LEDGER_HOOK}}, {{SCHEMA_REMINDER_HOOK}}
  - {{SURFACE_GLOB}}, {{SURFACE_NAME}}, {{SURFACE_RULES}}, {{PRIMARY_SKILL}}
  - {{SURFACES}}, {{SURFACE_SPECIFIC_Q}}, {{DEV_DEPLOY_TRIGGER}}, {{DEPLOY_BRANCHES}}

G. Write the generation manifest as the plan content: a table listing every file to be written, its source template, and key placeholder values.

---

### Step 5 â€” EXIT PLAN MODE

Call ExitPlanMode with the generation manifest as the plan. The user must approve the exact file list before any write.

---

### Step 6 â€” OS detection (post-approval, before writing)

Run: uname -s 2>/dev/null || echo "Windows"
Run: which jq 2>/dev/null || where jq 2>/dev/null

Set HOOK_EXT = sh (bash) or js (node). Set HOOK_CMD_PREFIX = bash or node.

---

### Step 7 â€” Write files in dependency order

Never overwrite a file that already exists. Glob-check before each Write. Track skipped files for the report.

LAYER 1 â€” .claude/hooks/
Read from ~/.claude/skills/setup/templates/hooks/bash/ or ...\node\ based on OS detection. Fill {{PROTECTED_BRANCHES_CASE}} or {{PROTECTED_BRANCHES_ARRAY}} placeholder. Write to .claude/hooks/:
- block-protected-branch.{sh|js} â€” always
- context-budget-nag.{sh|js} â€” if opted in (default yes)
- block-mockup-images.{sh|js} â€” if opted in (default yes for teams)
- post-session-snapshot.{sh|js} â€” always
- session-end-rollup.{sh|js} â€” if token ledger opted in (default yes)

LAYER 2 â€” .claude/settings.json
Read ~/.claude/skills/setup/templates/settings.json.tmpl. Fill all hook command references (bash vs node path) and the permissions allow/deny arrays from Batch 4 answers. Write to .claude/settings.json.

LAYER 3 â€” .claude/rules/
For each detected surface, fill ~/.claude/skills/setup/templates/rules/rule.md.tmpl with:
- {{SURFACE_GLOB}}: language-appropriate glob (e.g. "src/**/*.{ts,py,go}" adapted to detected language)
- {{SURFACE_NAME}}: human name (e.g. "API (src/api/**)")
- {{SURFACE_RULES}}: 3-5 non-negotiable rules for this surface
- {{PRIMARY_SKILL}}: the main skill to load (e.g. api-contracts, ui-rules)
Write to .claude/rules/{surface}.md.

LAYER 4 â€” .claude/skills/
For each applicable skill, read ~/.claude/skills/setup/templates/skills/{skill}/SKILL.md. Fill ALL {{PLACEHOLDER}} tokens. Write to .claude/skills/{skill}/SKILL.md. Create the directory first.

LAYER 5 â€” .claude/agents/
For each applicable agent, read ~/.claude/skills/setup/templates/agents/{agent}.md.tmpl. Fill. Write to .claude/agents/{agent}.md.

LAYER 6 â€” .claude/commands/
Read from ~/.claude/skills/setup/templates/commands/full/ (team) or ...\lite\ (solo).
Fill all {{PLACEHOLDER}} tokens. Write to .claude/commands/{name}.md.

LAYER 7 â€” docs/
Create directories if missing: docs/tickets, docs/decisions, docs/sessions
Write (skip if exists):
- docs/tickets/_TEMPLATE.md â† templates\docs\tickets\_TEMPLATE.md (fill surface-specific placeholders)
- docs/tickets/_active.md â† templates\docs\tickets\_active.md.tmpl
- docs/STATE.md â† templates\docs\STATE.md.tmpl
- docs/TEAM.md â† templates\docs\TEAM.md.tmpl (team mode only â€” fill lead info)
- docs/PLAYBOOK.md â† templates\docs\PLAYBOOK.md.tmpl
- docs/DESIGN.md â† templates\docs\DESIGN.md.tmpl (frontend surfaces only â€” fill aesthetic + palette)
- docs/decisions/ADR-TEMPLATE.md â† templates\docs\decisions\ADR-TEMPLATE.md
- docs/sessions/.gitkeep â† empty marker file

LAYER 8 â€” CLAUDE.md (last, richest)
Read ~/.claude/skills/setup/templates/CLAUDE.md.tmpl. Fill all placeholders:
- {{STACK_TABLE}}: markdown table of layer/tech/path for each surface
- {{CODE_RULES}}: 4-6 non-negotiable rules derived from the interview (TypeScript strict? ORM-only? Response envelope?)
- {{DOMAIN_MAP}}: markdown table of feature domains (inferred from analysis or left as "not started" stubs)
- {{AGENTS_LIST}}: dot-separated list of agent names that were generated
- {{SKILLS_LIST}}: dot-separated list of skill names that were generated
- {{COMMANDS_LIST}}: slash commands with one-line descriptions
- {{TICKET_PIPELINE_NOTE}}: team-mode pipeline note, or omit for solo
- {{GENERATE_CMD}} and {{SCHEMA_FILE}}: for the "Before starting any work" checklist
Write to CLAUDE.md in the repo root.

---

### Step 8 â€” Completion report

Print a formatted summary (see Important rules section for format). Include: every file written, every file skipped, pipeline mode, surfaces, hook type, and the 4 next steps.

---

## Important rules

1. Read templates before filling. Always Read the template file first; then substitute {{PLACEHOLDER}} tokens.
2. Never write to the templates directory. All writes go to the target repo. ~/.claude/skills/setup/templates/ is read-only source material.
3. Never overwrite existing files. Glob-check before every Write. Skip and report at the end.
4. Fill every {{PLACEHOLDER}} before writing. An unfilled placeholder in a written file is a bug.
5. Infer from codebase first. Do not ask what you can detect. Reserve interview questions for decisions that genuinely cannot be inferred.
6. Hook type is automatic. Detect OS and jq. The user does not choose. Report what was detected.
7. Augment mode is silent. Skip existing files without asking. List them in the completion report.
8. Use today's date (from the currentDate context injection) for all {{SETUP_DATE}} placeholders.
9. Lite mode omits: TEAM.md, groom-ticket command, review-ticket command, Pending Lead Review section in _active.md. Replace review references in PLAYBOOK.md with "(solo â€” no review step)".
10. Hook JSON contract (both bash and node): blocking = {"block":true,"message":"..."} to stderr + exit 2; advisory = {"feedback":"..."} to stdout + exit 0. Bash hooks read $CLAUDE_TOOL_INPUT (PreToolUse/PostToolUse) or stdin via cat (Stop event). Node hooks use process.env.CLAUDE_TOOL_INPUT and process.stdin respectively.
11. Completion report format:
    /setup complete
    Project: {name}
    Pipeline: {full/lite}
    Surfaces: {list}
    Hook type: {bash/node}
    Files written: {list}
    Files skipped: {list or "none"}
    Next steps:
    1. {team/solo roster note}
    2. Review CLAUDE.md.
    3. Commit: git add .claude/ docs/ CLAUDE.md && git commit -m "chore: bootstrap AI-SDLC via /setup"
    4. /new-feature {your-first-feature}
