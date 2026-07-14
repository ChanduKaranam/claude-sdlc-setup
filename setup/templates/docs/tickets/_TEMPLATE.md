---
ticket: TICKET-XXX
feature: { feature-slug }
branch: feature/{feature-slug}
status: TODO   # TODO | GROOMED | CHANGES_REQUESTED | APPROVED | IN_PROGRESS | BLOCKED | READY_FOR_REVIEW | COMPLETED
co_claimants:
  {{SURFACE_KEYS}}: ""
estimated_sessions: "—"
estimated_hours: "—"
started_at: ""
target_end_date: ""
actual_end_date: ""
api_contract_frozen: false
groomed_by: ""
groomed_at: ""
grooming_round: 1
approved_by: ""
approved_at: ""
last_feedback_by: ""
last_feedback_at: ""
review_notes: ""
claimed_by: ""
claimed_at: ""
---

# TICKET-XXX — {Feature Name}

**Depends on:** none
**ADR:** (only if architectural — delete this line otherwise)

---

## Goal

One paragraph. Why this exists and what a user will be able to do once it ships.

---

## Reference

- Skills to load before API work: `api-contracts`, `db-conventions`
{{FRONTEND_SKILLS_REF}}
- Deviations from prior behavior: none

---

## UI Walkthrough

> _Filled by `/groom-ticket`._ Per route/screen, prose walkthrough: layout, key elements, interactions, transitions, empty/loading/error states.

---

## Data Model

> _Filled by `/groom-ticket`._

- **Models touched:** {list}
- **New tables:** {name → columns}
- **New columns / indexes:** {model.column → type}
- **FK relationships:** {from → to, onDelete}
- **Migration order:** {free-form}

---

## Detailed API Contracts

> _Filled by `/groom-ticket`._

### `{VERB} /api/v1/{path}`

```ts
const RequestSchema = z.object({});
const ResponseSchema = z.object({});
```

- **Permissions:** {prose}
- **Idempotency:** not required / Idempotency-Key required

---

## Test Scenarios

> _Filled by `/groom-ticket`._

- **Happy path:** {bulleted}
- **Error paths:** {400 / 403 / 404 / 409}
- **Component states:** empty | loading | error | success
- **Edge cases:** {bulleted}

---

## Test Plan

> _Filled by `/groom-ticket`._ Check the box when the file lands; replace path with `N/A — {reason}` if the layer doesn't apply.

{{TEST_PLAN_LAYERS}}

---

## Risks, Dependencies, Rollback

> _Filled by `/groom-ticket`._

- **Migration risks:** none — small table
- **Feature flag:** none
- **Depends on:** none
- **Rollback plan:** {prose}
- **Performance concerns:** none

---

## Implementation Plan

> _Filled by `/groom-ticket` via the `superpowers:writing-plans` skill. Executed by `/build-ticket`._
>
> **No placeholders.** "TBD", "TODO", "add appropriate error handling", "similar to Task 1" — each of these is a plan failure, not a plan. A task is the smallest unit of work that carries its own test cycle. Steps are 2–5 minutes each.

### Global Constraints

> Verbatim values from the design above. These get copied word-for-word into every implementer prompt — paraphrasing a constraint is how it gets violated.

- **Response envelope:** {{RESPONSE_ENVELOPE}}
- **Validation:** {{VALIDATION_LIB}}
- **ORM:** {{ORM}}
- **Test command:** `{{TEST_CMD}}`
- {other non-negotiables from Data Model / API Contracts}

### Task 1: {name}

**Files:** Create `{path}` · Modify `{path}` · Test `{path}`
**Interfaces:** Consumes `{exact signature}` → Produces `{exact signature}`

- [ ] Write failing test in `{path}` asserting `{specific behavior}`
- [ ] Run `{{TEST_CMD}}` — verify RED, and that it fails for the right reason
- [ ] Implement `{path}` — minimal code to pass
- [ ] Run `{{TEST_CMD}}` — verify GREEN, output pristine
- [ ] Commit `type(scope): description (TICKET-XXX)`

### Task 2: {name}

_(same structure — one task per test cycle)_

---

## Acceptance Criteria

{{ACCEPTANCE_CRITERIA}}

---

## API Endpoints

- `POST   /api/v1/{resource}` — create
- `GET    /api/v1/{resource}` — list
- `GET    /api/v1/{resource}/:id` — get one
- `PATCH  /api/v1/{resource}/:id` — update
- `DELETE /api/v1/{resource}/:id` — archive

---

{{WEB_ROUTES_SECTION}}

{{MOBILE_SCREENS_SECTION}}

## Out of Scope

- Things explicitly deferred
- {edge cases known but not in this ticket}

---

## Lead Feedback

> _Appended by `/review-ticket` only when a lead requests changes._

---

## Documentation

- **ADRs:** (or "n/a")
- **Parent ticket:** none
- **Follow-up tickets:** none

---

## Automation Tests

| Layer | Path | Suites | Status |
|-------|------|--------|--------|
| — | — | — | — |

---

## Change Log

| Date | Change | Driver | Migration / Commit |
|------|--------|--------|--------------------|
| —    | —      | —      | —                  |

---

## Delays & Blockers

**Active blockers:** none

---

## Verification Log

Filled by `/build-ticket` (done gate) and `/complete-feature` (pre-merge gate), both via the `superpowers:verification-before-completion` skill — do not edit manually. Every row is a command that was actually run, with its actual output. An unrun row is an empty row, not a ticked one.

| Surface | Bullet | Verified by | Date | Pass |
|---------|--------|-------------|------|------|
| —       | —      | —           | —    | —    |

---

## Token Ledger

Filled by SessionEnd hook — do not edit manually.

**Estimate:** {N} sessions · ~{H}h
**Sessions:** 0 · **Total tokens:** 0 in / 0 out / 0 cache

| session_id | dev | started | duration | input | output | cache_read | cost_usd |
|------------|-----|---------|----------|-------|--------|------------|---------|
