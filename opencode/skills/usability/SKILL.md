---
name: usability
description: Strict UX patterns for states, forms, feedback, accessibility, and user-facing copy
---

# Usability Patterns

## What This Skill Does
- Defines strict UX + accessibility requirements for UI states, forms, feedback, and navigation.
- Written for `shadcn/ui` + Base UI + TanStack Router/Start.
- These rules are non-negotiable and must always be followed.

## When To Use
Use when building UI flows, forms, dialogs, toasts, tables/lists, or any user-facing copy and interaction.

## Non-Goals
- Tailwind class composition (see `tailwind`).
- React data/state architecture (see `react-patterns`).
- Effect-specific idioms (see `effect-patterns`).

---

## States

### Empty State

Every empty state includes:
1. Visual (icon/illustration)
2. What would appear here
3. Concrete next action

```tsx
<EmptyState
  icon={Building2}
  title="No organizations yet"
  description="Create your first organization to get started."
  action={<Button onClick={create}>Create Organization</Button>}
/>
```

### Loading State

- Skeleton mirrors the final layout to avoid layout shift.
- Buttons show a spinner and keep the label ("Saving...").
- Disable controls during submission.

### Error State

Error messages answer:
1. What happened?
2. Why (if known)?
3. What should the user do next?

```ts
// BAD
"An error occurred"

// GOOD
"Unable to save. Check your connection and try again."
```

## Forms

### Labels
- Every control has an accessible label.
- Use `htmlFor` to associate label and input.
- Mark optional fields; do not mark required fields.

### Validation
- Validate on blur, not on every keystroke.
- Show errors adjacent to the field.
- On submit, focus the first invalid field.

### Password Fields
- Provide show/hide.
- Show requirements while typing.
- Show Caps Lock warning when relevant.

### Input Types
- Use correct `type` / `inputMode` for the best keyboard.

## Feedback

### Success
Use a toast or inline confirmation for completed actions.

### Destructive Actions

Require confirmation (prefer `AlertDialog`).

```tsx
<AlertDialog>
  <AlertDialogTitle>Delete "Acme Inc"?</AlertDialogTitle>
  <AlertDialogDescription>This cannot be undone.</AlertDialogDescription>
</AlertDialog>
```

### Unsaved Changes

Warn before navigation when changes would be lost.

## Accessibility

### Keyboard
All interactive elements are keyboard operable.

### ARIA

Prefer semantics first; use ARIA to fill gaps.

```tsx
<button aria-label="Close">
  <X />
</button>
<div aria-live="polite" aria-busy={loading}>
  <div role="alert">{error}</div>
</div>
```

### Touch Targets
Minimum 44x44 px for touch.

## Navigation

- Logo links home.
- Active route is highlighted.
- Back button works predictably.
- URL reflects state for deep linking.

---

## Copy and Error Messages

### No vague copy

Error messages and user-facing copy must be specific and actionable.

```ts
// BAD
"An error occurred"
"Something went wrong"

// GOOD
"Unable to save changes. Check your connection and try again."
"Organization not found. It may have been deleted."
```

### Error mapping

Map domain errors to user-facing messages. See `effect-patterns` for `Schema.TaggedError` and `Match` usage.
