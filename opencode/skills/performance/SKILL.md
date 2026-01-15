---
name: performance
description: Performance rules for React and Effect. Use for caching, rendering, data flow.
metadata:
  domain: cross
  stack: react,effect
  scope: rules
---

# Performance

## React Render

Rules:
- One atom subscription per component.
- Derived atoms over component work.
- Avoid inline object/array in hooks.
- Use `toSorted`, not `sort`.

```ts
export const sortedEntriesAtom = Atom.readable(get => {
  const result = get(entriesAtom)
  const sortBy = get(sortByAtom)
  if (!Result.isSuccess(result)) return result
  return Result.success(result.value.toSorted((a, b) => a[sortBy] < b[sortBy] ? -1 : 1))
})
```

```ts
// BAD
const atom = ApiClient.query('items', 'list', { urlParams: { page } })

// GOOD
const atom = useMemo(
  () => ApiClient.query('items', 'list', { urlParams: { page } }),
  [page]
)
```

## React UI

Rules:
- Avoid layout thrash.
- Use `content-visibility` for long lists.

```css
.message-item {
  content-visibility: auto;
  contain-intrinsic-size: 0 80px;
}
```

## Effect Runtime

Rules:
- Cache with explicit TTL.
- Provide once at entry.
- Avoid wrapping pure code in Effect.

```ts
const cached = Cache.get(id)
if (cached) return Effect.succeed(cached)

return fetchUser(id).pipe(
  Effect.tap(user => Cache.set(id, user, { ttl: Duration.minutes(5) }))
)
```
