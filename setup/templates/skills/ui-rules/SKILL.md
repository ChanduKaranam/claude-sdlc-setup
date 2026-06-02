---
name: ui-rules
description: Use when building any UI for {{PROJECT_NAME}}. Covers design tokens, spacing scale, color palette, typography, and the 5-state rule. Always load alongside visual-direction and component-patterns.
---
# UI Rules — {{PROJECT_NAME}}

## Design tokens

```
Colors:
{{COLOR_TOKENS}}

Typography:
{{TYPE_TOKENS}}

Spacing scale:
{{SPACING_TOKENS}}
```

## The 5-state rule

Every list, table, or data-driven view must handle all five states — no exceptions:

1. **Loading** — skeleton rows or spinner.
2. **Empty (none)** — no data exists yet. Show CTA to create the first item.
3. **Empty (filtered)** — data exists but search/filter returned nothing. Show clear-filter affordance.
4. **Error** — fetch failed. Show retry + support copy.
5. **Success** — data loaded. Render the list.

## Layout principles

{{LAYOUT_PRINCIPLES}}

## NEVER (AI-slop fingerprints to avoid)

- Gradient backgrounds or glow effects.
- Centered hero text with a decorative subtitle.
- Card grids with drop shadows on every card.
- Emoji in button labels.
- Padding that looks "comfortable" — use the spacing scale.
