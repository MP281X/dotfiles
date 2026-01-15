---
name: ux
description: UX patterns for states, forms, accessibility, copy, navigation. Use for UI behavior and a11y.
metadata:
  domain: frontend
  stack: ux,a11y
  scope: rules
---

# UX

## States

Rules:
- Design empty, loading, error.
- Errors explain what + why + next step.
- Keep labels in loading buttons.

```tsx
<EmptyState
  icon={Building2}
  title="No organizations yet"
  description="Create your first organization to get started."
  action={<Button onClick={create}>Create Organization</Button>}
/>
```

```ts
// BAD
'An error occurred'

// GOOD
'Unable to save. Check your connection and try again.'
```

## Forms

Rules:
- Validate on blur.
- Focus first invalid field on submit.
- Labels required.
- Placeholder ends with ellipsis.
- Do not block paste.

```tsx
<Label htmlFor="email">Email</Label>
<Input id="email" type="email" placeholder="name@domain.com…" />
```

## Accessibility

Rules:
- Keyboard works everywhere.
- Visible focus ring.
- Icon-only buttons need aria-label.
- Touch targets ≥ 44px.

```tsx
<button aria-label="Close" className="min-h-[44px] min-w-[44px]">
  <X />
</button>
<div aria-live="polite" aria-busy={loading} />
```

## Navigation

Rules:
- Logo links home.
- Active route highlighted.
- Breadcrumbs for deep pages.

```tsx
<Link to="/">Home</Link>
```
