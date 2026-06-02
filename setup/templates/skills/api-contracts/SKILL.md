---
name: api-contracts
description: Use when building, modifying, or reviewing API endpoints in {{PROJECT_NAME}}. Covers request/response shapes, error handling, auth patterns, and validation conventions.
---
# API Contracts — {{PROJECT_NAME}}

## Response envelope

Every endpoint returns the same envelope on success and error:

```typescript
// Success
{ success: true, data: T }

// Error
{ success: false, error: { code: string, message: string, details?: unknown } }
```

## Validation

Use **{{VALIDATION_LIB}}** schemas defined in `{{SHARED_SCHEMAS_PATH}}`. Validate at the route boundary before any business logic runs. Never trust raw request data downstream.

## Error codes

| Code | HTTP status | When |
|------|-------------|------|
| VALIDATION_ERROR | 400 | Zod/schema parse failure |
| UNAUTHORIZED | 401 | Missing or invalid auth token |
| FORBIDDEN | 403 | Valid token but insufficient permission |
| NOT_FOUND | 404 | Resource doesn't exist (or hidden from caller) |
| CONFLICT | 409 | Unique constraint violation / duplicate |
| INTERNAL_ERROR | 500 | Unhandled server error |

## Auth pattern

- Protected routes: apply `{{AUTH_MIDDLEWARE}}` — aborts with 401 if no valid token.
- Public routes: opt out explicitly with an inline comment explaining why.

## Route naming

`{{HTTP_VERB}} /api/v1/{resource}[/:id][/{sub-resource}]` — lowercase, plural, hyphenated.

## NEVER

- Return raw DB rows — always shape through a response schema.
- Expose internal error details (stack traces, query text) to the client.
- Skip validation on any route, even "internal" ones.
