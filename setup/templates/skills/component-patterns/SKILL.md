---
name: component-patterns
description: Use when building React components for {{PROJECT_NAME}}. Covers component structure, naming, composition patterns, and file tiers.
---
# Component Patterns — {{PROJECT_NAME}}

## Component tiers

| Tier | Path | Rule |
|------|------|------|
| Atoms | `components/ui/` | Single-purpose, no business logic. From the UI library first. |
| Feature components | `components/{feature}/` | Composed from atoms. May call hooks. |
| Page-level | `app/{route}/` | Thin shell. Orchestrates feature components and data fetching. |

## Composition rules

- **Outer-controlled**: data and callbacks flow in as props. No internal API calls in atoms.
- **Single responsibility**: one component does one thing. Extract when a component exceeds ~100 lines.
- **Co-locate tests**: `{ComponentName}.test.tsx` beside `{ComponentName}.tsx`.

## Naming

- PascalCase for component files and exports.
- camelCase for hooks (`useProjectList`).
- Never prefix with "I" for interfaces or "C" for components — just the name.

## State management decision tree

1. Can it live in a URL param? → URL param (shareable, bookmarkable).
2. Is it server-state (async data)? → TanStack Query / SWR.
3. Is it UI-only local state? → useState / useReducer.
4. Is it truly global cross-route state? → Zustand / Context (last resort).

## NEVER

- Fetch data inside an atom component.
- Use index as a list key when items have stable IDs.
- Mix business logic and rendering in the same component.
