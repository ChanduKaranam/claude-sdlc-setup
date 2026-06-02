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

Filled by `/complete-feature` — do not edit manually.

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
