---
name: state-management
description: Use when deciding where state lives in {{PROJECT_NAME}}. Decision tree for URL params, server state, local state, and global state.
---
# State Management — {{PROJECT_NAME}}

## Decision tree

Before adding state, ask in order:

1. **Can it be a URL param?** → Use URL param. Bookmarkable, shareable, free deduplication.
2. **Is it async server data?** → Use `{{QUERY_LIB}}`. Handles caching, loading states, refetching.
3. **Is it local UI state?** → Use `useState` / `useReducer`. Keep it as close to the leaf as possible.
4. **Is it truly cross-route global state?** → `{{GLOBAL_STATE_LIB}}` (last resort — justify in a comment).

## Server state with {{QUERY_LIB}}

- Define one hook per resource: `use{{Resource}}List`, `use{{Resource}}Detail`.
- Co-locate the hook with the feature it serves: `components/{feature}/hooks/`.
- Use `queryKey` arrays that include every filtering parameter.
- Invalidate on mutation: `queryClient.invalidateQueries({ queryKey: ['{resource}'] })`.

## When to lift state

Lift state **only** when two sibling components both need to read or write it. Default is to keep it down.

## NEVER

- Use global state for data that's only needed in one route.
- Derive state in an effect — derive in the render function instead.
- Store a copy of server data in local state — that's what the query cache is for.
