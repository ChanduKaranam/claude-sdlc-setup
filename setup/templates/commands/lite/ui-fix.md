---
name: ui-fix
description: A visual change to an existing screen — spacing, color, type, layout, copy, states. No ticket, no plan, no TDD. Finds the file, checks who else uses it, designs the change, and proves it with screenshots.
---

You are making a UI-level change: **$ARGUMENTS**

This command is deliberately light. A padding change does not need an architectural interview, an Implementation Plan, or a failing test — the check for a visual change is that you looked at it.

Light is not the same as careless. Two things get skipped constantly on UI work and cause most of the damage: **knowing which file actually renders the pixel you're looking at**, and **knowing who else renders that same component**. This command refuses to skip either.

---

## Step 1 — The scope gate. Read this before anything else.

**A UI fix changes how something looks. The moment it changes how something *works*, it stops being a UI fix.**

In scope — proceed:
- Spacing, sizing, alignment, layout, responsive behavior at a breakpoint
- Color, typography, borders, elevation, iconography
- Copy: labels, headings, empty-state text, error text, button verbs
- Hover / focus / active / disabled styling
- A visual defect with an obvious cause (an element overflows, a token wasn't applied, a state renders unstyled)
- Swapping a hardcoded value for a design token
- A new visual variant of an existing component

Out of scope — **stop and route it**:
- It changes what data is fetched, or when → this is a feature. `/new-feature`, then `/work-ticket`.
- It changes a component's props contract, or its state shape → other callers depend on that. `/new-feature`, or `/fix-bug` if the contract is what's broken.
- It adds a route, a screen, or a component that carries business logic → `/new-feature`.
- It changes permissions or what a role can see → **never** a UI fix. That is a security boundary. `/new-feature`.
- The thing is visually wrong and **you don't know why** → that is a bug with a visual symptom. `/fix-bug`. Do not restyle around a cause you haven't found; you will hide it, not fix it.

Say which one this is, out loud, before you continue. If it's out of scope, name the command that owns it and stop. Shipping a feature through `/ui-fix` is how a permissions change reaches production with no test and no review.

---

## Step 2 — Find the file that actually renders it

Do not guess, and do not ask the user to guess. Find it.

- Search for the visible string — the label, the heading, the button text. Copy is the fastest route to a component.
- Follow the route from `app/` or the router to the page, then down through the component tree to the leaf that owns the element.
- Check whether the value you're changing is a **token** (in the design system) or **hardcoded at the call site**. This determines the blast radius entirely, and it is the single most important thing to establish before you touch anything.

Then confirm it with the user, in one message:

```
UI-FIX — $ARGUMENTS

Renders in:   {path}:{line} — <{ComponentName}>
Currently:    {the exact current value / markup}
Owned by:     a design token ({token name}) | hardcoded here | a shared style

Is this the right element?
```

Getting this wrong means editing a component that looks identical to the one on screen but isn't the one on screen. It happens constantly, and every minute spent here is cheaper than the confusion later.

Solo, you are also the reviewer. Confirm it against the running app, not against your memory of the file tree.

---

## Step 3 — Blast radius. Who else renders this?

**Grep every usage before you edit.** This is the step that separates a safe UI fix from a silent regression across six screens.

```bash
grep -rn "ComponentName" --include=* src/     # every import, every render site
```

Then answer, explicitly:

- **How many places render this component?** If it's one, you're free. If it's twelve, you're about to change twelve screens.
- **Are you editing a shared atom or a local instance?** Editing `components/ui/Button.tsx` changes every button in the product. If the user asked for "this one button on the settings page", the change belongs at the *call site* (a prop, a variant), not in the atom.
- **Is the value a token?** Changing a token is a design-system change. It is legitimate — sometimes it's exactly right — but it is never a local change, and it never happens without saying so.

Report it plainly:

```
Blast radius:
  <Button> is rendered in 12 places.
  Editing the component changes all 12.
  The user asked for 1 (settings page).
  → the change belongs at the call site, not in the atom.
```

If the change would touch places the user did not ask about, **stop and ask which they meant.** "Make the button bigger" has two completely different implementations, and only one of them is what they wanted.

---

## Step 4 — Design the change

**Invoke the `frontend-design:frontend-design` skill** for the visual decision itself. It is not a styling free-for-all — this project has a house style, and the change must land inside it.

Load, in this order, and let them constrain the design:
1. **`docs/DESIGN.md`** — the project's aesthetic direction, palette, type scale, spacing scale.
2. **The `ui-rules` skill** — the non-negotiables. Especially **the 5-state rule**: every list, table, and data view handles loading, empty-none, empty-filtered, error, and success. If your change touches any data view, all five states still have to work when you're done.
3. **The `component-patterns` skill** — where this component belongs in the tier system (atom / feature / page), which decides *where* the change goes.

**Ponytail governs the diff.** Climb the ladder before writing a line:

1. **Does this change need to exist at all?** Sometimes the answer is that the design is fine and the request is a preference. Say so, once, and then do what they asked.
2. **Is it already in this codebase?** A variant, a utility class, an existing component that does this. Reuse beats writing.
3. **Can the platform do it?** CSS before JavaScript, every time. `<details>` before a disclosure library. `:focus-visible` before a focus-tracking hook. A CSS grid before a layout component. Native form validation before a validation state machine.
4. **Is there a token for it?** Use the token. A hardcoded `#3B82F6` next to eleven other components using `--color-primary` is a bug that hasn't happened yet.
5. **Can it be one line?** Then it is one line.

Do not add a dependency for a UI change. Do not introduce an abstraction for one call site. Do not refactor the component because you're already in the file — a visual change that also restructures a module is two changes, and when it breaks nobody will know which one did it.

Never lazy about: **keyboard focus being visible**, **contrast**, **hit-target size**, **reduced-motion**, and **the 5 states**. These are accessibility, not polish, and they are the first thing dropped and the last thing noticed.

---

## Step 5 — Make the change

Smallest diff that achieves it. At the right tier — the call site if it's local, the component if it's genuinely shared, the token if it's genuinely systemic.

If you cut a corner deliberately, mark it:

```tsx
{/* ponytail: hardcoded 14px, promote to a token if a third component needs it */}
```

---

## Step 6 — Look at it. This is the verification.

There is no unit test for "the spacing looks right". The proof is that you rendered it and looked.

**Invoke the `design-review` agent.** It screenshots the affected route at **1440px and 390px**, checks the result against `docs/DESIGN.md` and the `ui-rules` skill, runs an accessibility scan, and returns a BLOCK / WARN / NIT punch-list.

The dev server must be running. **If it isn't, the agent will say so and stop — let it.** Do not substitute reading the code for looking at the screen; the entire point of this step is that the code looked correct to you already, which is why the bug is still there.

Check, and paste what you saw:

- [ ] **Desktop (1440px)** — screenshot. The change is what was asked for.
- [ ] **Mobile (390px)** — screenshot. It did not break the small viewport. This is where UI changes go wrong.
- [ ] **Every state still works** — if this touches a data view: loading, empty, filtered-empty, error, success. All five. A styling change that breaks the empty state is a very common way to ship a blank screen.
- [ ] **Keyboard focus is still visible** on anything interactive you touched.
- [ ] **The other call sites still look right** — if Step 3 found more than one, look at them too. Not "they should be fine". Look.

Then, in this message:

```bash
{{LINT_CMD}}
{{TYPECHECK_CMD}}
{{TEST_CMD}}
```

**Invoke the `superpowers:verification-before-completion` skill.** Same iron law as everywhere else in this pipeline: if you did not run it in this message, you cannot claim it passes. A UI change is exempt from the *ceremony*, not from the *evidence*.

---

## Step 7 — Ship it

```bash
git switch -c ui/$ARGUMENTS {{BASE_BRANCH}}    # if not already on a branch
git add -A && git commit -m "style($ARGUMENTS): {what changed, visually}"
git push -u origin ui/$ARGUMENTS

gh pr create \
  --base {{PR_TARGET_BRANCH}} \
  --head ui/$ARGUMENTS \
  --title "style($ARGUMENTS): {one line}" \
  --body "$(cat <<'EOF'
## What changed
{one or two lines, in visual terms — what a reviewer will see}

## Where
`{path}` — <{Component}>

## Blast radius
{n} call sites render this. {which ones this change affects, or "local to this call site"}

## Verified
- Desktop 1440px — {what you saw}
- Mobile 390px — {what you saw}
- States: {loading / empty / filtered-empty / error / success — or "n/a, not a data view"}
- Lint / types / tests: {actual output}
EOF
)"
```

This command opens its own PR rather than routing through `/complete-feature` — that command reconciles against a ticket's Test Plan and Implementation Plan, and a UI fix deliberately has neither. The gates here are different in kind (visual evidence instead of a test plan), not weaker.

---

## Notes for Claude

- **The scope gate is the whole command.** Everything visual is in; anything behavioral is out. When you are unsure which side a change falls on, it is behavioral — route it.
- **Grep the usages before you edit.** "Make the button bigger" is a one-line change or a twelve-screen change, and only the user knows which one they meant.
- **CSS before JavaScript. Token before hardcode. Call site before shared component.**
- **Look at the screen.** On both widths. A UI change verified by reading the diff is not verified.
- No ticket, no plan, no failing test — that is the point of this command. The evidence is the screenshot, and it is not optional.
