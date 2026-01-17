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
- Design all states: empty, loading, success, error.
- Errors explain what + why + next step.
- Keep labels in loading buttons.
- Use consistent icon/color per state.

```tsx
<EmptyState
  icon={Building2}
  title="No organizations yet"
  description="Create your first organization to get started."
  action={<Button onClick={create}>Create Organization</Button>}
/>
```

```tsx
// GOOD - complete error info
<Alert variant="error" icon={AlertCircle}>
  <AlertTitle>Unable to save changes</AlertTitle>
  <AlertDescription>
    Your session expired. <Link to="/login">Sign in again</Link>
  </AlertDescription>
</Alert>

// BAD - vague
<Alert variant="error">An error occurred</Alert>
```

```tsx
// GOOD - label stays
<Button disabled={isLoading}>
  {isLoading ? (
    <>
      <Spinner className="mr-2 animate-spin" />
      Saving...
    </>
  ) : (
    'Save Changes'
  )}
</Button>
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
