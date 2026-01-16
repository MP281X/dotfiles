---
name: tailwind
description: Tailwind conventions for composition, selectors, responsive, animation. Use for Tailwind code.
metadata:
  domain: frontend
  stack: tailwind
  scope: rules
---

# Tailwind

## Composition

Rules:
- Use `clsx` for conditional classes.
- Group by purpose (layout, colors, states).
- Extract variant patterns to const objects.

```tsx
import { clsx } from 'clsx'

<button
  className={clsx(
    // Base
    'px-4 py-2 rounded-md font-medium',
    // Colors
    'bg-blue-600 text-white hover:bg-blue-700',
    // States
    loading && 'animate-pulse',
    disabled && 'opacity-50 cursor-not-allowed',
    // Props
    className
  )}
/>
```

```tsx
// GOOD - variant pattern
const buttonVariants = {
  primary: 'bg-blue-600 hover:bg-blue-700 text-white',
  secondary: 'bg-gray-200 hover:bg-gray-300 text-gray-900',
  danger: 'bg-red-600 hover:bg-red-700 text-white'
}

<button className={clsx('px-4 py-2 rounded-md', buttonVariants.primary)} />
```

## Selectors over JS

Rules:
- Prefer Tailwind selectors to JS conditionals.

```tsx
// GOOD
<div className="last:pb-0" />

// BAD
<div className={props.isLast ? 'pb-0' : 'pb-4'} />
```

Common selectors: `first:` `last:` `odd:` `even:` `empty:` `disabled:` `checked:` `focus:` `focus-visible:` `hover:` `active:` `group-hover:` `peer-checked:`

## Responsive

```tsx
<div className="flex flex-col md:flex-row gap-4 p-4 md:p-6 lg:p-8" />
```

## Animation

Rules:
- No `transition-all`.
- Prefer `opacity` and `transform`.

```tsx
<div className="transition-opacity duration-200" />
<div className="transition-transform hover:scale-105" />
```

## Layout

```tsx
<div className="flex items-center justify-between" />
<div className="grid place-items-center" />
```
