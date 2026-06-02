---
name: testing-patterns
description: Use when writing tests for {{PROJECT_NAME}}. Covers test taxonomy, file placement, framework conventions, and the test plan requirements per ticket.
---
# Testing Patterns — {{PROJECT_NAME}}

## Test taxonomy

| Layer | Framework | Location | When required |
|-------|-----------|----------|---------------|
{{TEST_LAYERS_TABLE}}

## Test-first rule

For API routes: write the integration test **before** the route implementation. This is non-negotiable — it forces clarity on the contract before any code exists.

## File placement

- Integration/E2E tests: `{{INTEGRATION_TEST_PATH}}`
- Unit tests: co-located with the source file (`{module}.test.{ts,tsx}`)
- Shared tests: `{{SHARED_TEST_PATH}}`

## What to test

- **Happy path** — the main user action succeeds.
- **Error paths** — 400 (bad input), 403 (permission), 404 (not found), 409 (conflict).
- **Component states** — empty, loading, error, and success for every list/detail view.
- **Edge cases** — only ones with real risk of regression, not exhaustive enumeration.

## What NOT to test

- Framework behavior (routing, ORM queries by themselves) — test at integration level instead.
- Implementation details — test behavior (inputs → outputs), not internal structure.
- Every possible input combination — property-based testing only when the logic warrants it.

## Test plan in tickets

The `## Test Plan` section in every ticket lists a concrete file path per layer, or `N/A — {reason}`. `/complete-feature` enforces that every checked-box path exists on disk before the PR opens.
