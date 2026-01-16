---
name: react
description: React patterns for Effect Atom state, Suspense, hooks, component structure. Use for React UI work.
metadata:
  domain: frontend
  stack: react,effect-atom
  scope: rules
---

# React

## Method (step-by-step)

1. Identify shared state.
2. Move shared state to atoms.
3. Derive state with readable atoms.
4. Render by Result state.
5. Split container vs presentational.

## State: Atoms First

Rules:
- Shared state in atoms.
- useState only for local ephemeral UI.
- No useState for data, loading, errors.

```ts
// GOOD
export const sidebarOpenAtom = Atom.make(true)
export const userFamily = Atom.family((id: UserId) => ApiClient.query('users', 'get', { path: { id } }))
```

```ts
// BAD
const [users, setUsers] = useState<User[]>([])
const [error, setError] = useState<string | null>(null)
```

## Derived State

Rules:
- Derive in atoms, not components.

```ts
export const filteredEntriesAtom = Atom.readable(get => {
  const result = get(entriesAtom)
  const filter = get(statusFilterAtom)
  if (!Result.isSuccess(result)) return result
  return Result.success(result.value.filter(entry => entry.status === filter))
})
```

## Results and Suspense

Rules:
- Handle all Result states.
- Use Suspense for async UI.

```tsx
function DataList() {
  const result = useAtomValue(entriesAtom)
  if (Result.isInitial(result)) return <Skeleton />
  if (Result.isWaiting(result)) return <LoadingOverlay />
  if (Result.isFailure(result)) return <ErrorState cause={result.cause} />
  return <EntriesList entries={result.value} />
}
```

```tsx
<Suspense fallback={<PageSkeleton />}>
  <ErrorBoundary fallback={<ErrorPage />}>
    <Outlet />
  </ErrorBoundary>
</Suspense>
```

## Hooks

Rules:
- Never manually memoize with `useMemo` or `useCallback`.
- Lazy init for expensive state.
- Use functional setState updates.
- Never use useRef for state.

```ts
// BAD - manual memoization
const sorted = useMemo(() => items.toSorted(sortByName), [items])
const onAdd = useCallback((item: Item) => {
  setItems(curr => [...curr, item])
}, [])

// GOOD - inline, compiler handles memoization
const sorted = items.toSorted(sortByName)
const onAdd = (item: Item) => {
  setItems(curr => [...curr, item])
}
```

```ts
// GOOD - runs only once
const [searchIndex] = useState(() => buildSearchIndex(items))
```

```ts
// BAD - useRef for state
const countRef = useRef(0)
countRef.current++

// GOOD - useState for state
const [count, setCount] = useState(0)
```

## Component Structure

Rules:
- Container reads atoms.
- Presentational receives props.
- Composition over prop drilling.

```tsx
function UserListContainer() {
  const result = useAtomValue(usersAtom)
  if (!Result.isSuccess(result)) return <LoadingOrError result={result} />
  return <UserList users={result.value} />
}

function UserList({ users }: { users: ReadonlyArray<User> }) {
  return <ul>{users.map(user => <UserRow key={user.id} user={user} />)}</ul>
}
```

```tsx
<Card>
  <CardHeader><h2>Title</h2></CardHeader>
  <CardBody><p>Content</p></CardBody>
</Card>
```

## Data Fetching

Rules:
- Use Atom.family for parameterized queries.
- Avoid atom creation in render.

```ts
const companyFamily = Atom.family((id: CompanyId) =>
  ApiClient.query('companies', 'get', { path: { id } })
)
```

## Performance

Rules:
- Prefer derived atoms over component sorting.
- Avoid inline object creation in hooks.
- Use `toSorted` for immutability.

```ts
export const sortedEntriesAtom = Atom.readable(get => {
  const result = get(entriesAtom)
  if (!Result.isSuccess(result)) return result
  return Result.success(result.value.toSorted((a, b) => a.date.localeCompare(b.date)))
})
```
