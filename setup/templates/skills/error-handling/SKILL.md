---
name: error-handling
description: Use when adding error boundaries, mutation error handling, or error UX to {{PROJECT_NAME}}. Covers the error taxonomy and when to use toast vs inline vs full-page errors.
---
# Error Handling — {{PROJECT_NAME}}

## Error taxonomy

| Error type | UX pattern | When |
|-----------|------------|------|
| Form validation | Inline under field | User input invalid |
| Mutation failure | Toast notification | Background save/delete failed |
| Page load failure | Full-page error with retry | Primary data for the page failed |
| Partial failure | Inline inline error in section | One section of a page failed |
| Auth expiry | Redirect to login | Session expired |

## Error boundaries

Place error boundaries at:
- Route level (`error.tsx` in Next.js / `_layout.tsx` in Expo Router)
- Section level for independently-failing panels

Every error boundary must show: an error message, a retry button, and a support contact if needed.

## Mutation errors

```typescript
mutation.mutate(data, {
  onError: (error) => {
    toast.error(getErrorMessage(error)); // human-readable from error code
  }
});
```

## NEVER

- Swallow errors silently (no empty `catch {}` blocks).
- Show raw error messages (stack traces, DB errors) to end users.
- Use `alert()` for errors — always use the design-system feedback pattern.
