---
name: tailwind
description: Strict Tailwind CSS patterns with clsx, selectors, responsive design, and animations
---

# Tailwind Patterns

## What This Skill Does
- Defines strict Tailwind + class composition conventions.
- Predictable styling; minimal custom CSS; accessible selectors.
- These rules are non-negotiable and must always be followed.

## When To Use
Use when implementing styling for components (especially `shadcn/ui` + Base UI components).

## Non-Goals
- UX patterns (empty/loading/error states, forms UX) (see `usability`).
- React state/data patterns (see `react-patterns`).
- Effect-specific idioms (see `effect-patterns`).

---

## Rules

### Conditional Classes

Use `clsx` (or the repo’s `cn`) to compose classes; keep order stable with `className` last.

```tsx
import { clsx } from "clsx"

<button
  className={clsx(
    "px-4 py-2 rounded-md font-medium",
    "bg-blue-600 text-white hover:bg-blue-700",
    loading && "animate-pulse",
    className
  )}
/>
```

### Prefer Selectors Over JS

Prefer Tailwind state selectors rather than branching in JS.

```tsx
// GOOD - Tailwind selector
<div className="last:pb-0" />

// BAD - JS prop
<div className={props.isLast ? "pb-0" : "pb-4"} />
```

Common selectors: `first:`, `last:`, `odd:`, `even:`, `empty:`, `disabled:`, `checked:`, `focus:`, `focus-visible:`, `hover:`, `active:`, `group-hover:`, `peer-checked:`

### Responsive

Use breakpoint prefixes; keep defaults mobile-first.

```tsx
<div className="flex flex-col md:flex-row gap-4 p-4 md:p-6 lg:p-8" />
<div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4" />
```

### Animations

Prefer CSS over JS-driven animations. Prefer compositor-friendly transitions (transform/opacity). Avoid `transition-all`.

```tsx
<div className="transition-opacity duration-200" />
<div className="animate-pulse" />
<div className="animate-spin" />
<div className="transition-transform hover:scale-105" />
```

### Layout

Prefer flex/grid/intrinsic layout over measuring in JS.

```tsx
<div className="flex items-center justify-between" />
<div className="grid place-items-center" />
```

If the project defines safe-area utilities, use them intentionally.
