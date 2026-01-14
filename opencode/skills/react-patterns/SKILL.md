---
name: react-patterns
description: Strict React patterns for atoms, suspense, hooks, and component structure
---

# React Patterns

## What This Skill Does
- React rules for atoms, suspense, hooks, components.
- Assumes `Atom` APIs exist: `Atom.make`, `Atom.readable`, `Atom.family`, `useAtom`, `useAtomSuspense`.

## When To Use
Use when editing React code: components, routes, loaders, state.

## Non-Goals
- General TS style (see `code-style`).
- Tailwind classes (see `tailwind`).
- UX/copy patterns (see `usability`).
- Effect idioms (see `effect-patterns`).

---

## Hooks

### No useMemo / No useCallback

Avoid unless repo explicitly requires; prefer derived values.

```ts
// BAD
const sorted = useMemo(() => items.sort(...), [items])

// GOOD
const sorted = items.toSorted(...)
```

### No useEffect

Ban except:
- DOM interop (focus, measurements, imperative APIs)
- Third-party lib integration
- `useLayoutEffect` to prevent flicker

**Never for:** data fetching, state sync, subscriptions.

```ts
// BAD
useEffect(() => {
  fetchUsers().then(setUsers)
}, [])

// GOOD
const usersAtom = Atom.family(() => ApiClient.query("users", "list"))

function UsersList() {
  const { value: users } = useAtomSuspense(usersAtom)
  return <List items={users} />
}
```

---

## State: Atoms First

All shared state lives in atoms.

```ts
export const sidebarOpenAtom = Atom.make(true)
export const searchQueryAtom = Atom.make("")
```

### Naming: Suffix Atom/Family

```ts
// BAD
export const sidebar = Atom.make(true)

// GOOD
export const sidebarOpenAtom = Atom.make(true)
export const userFamily = Atom.family(...)
```

### When useState is OK

Only truly local, ephemeral state:
- Form draft before submission
- Hover/focus state
- Animation state

### useState anti-patterns

```ts
// BAD - belong in atoms
const [isLoading, setIsLoading] = useState(false)
const [users, setUsers] = useState<User[]>([])
const [showModal, setShowModal] = useState(false)
```

### Derived state

Derive, don't duplicate.

```ts
export const filteredEntriesAtom = Atom.readable((get) => {
  const entries = get(entriesAtom)
  const filter = get(statusFilterAtom)
  return entries.filter((entry) => entry.status === filter)
})
```

### Atom rules

**No write in render**

```ts
// BAD
function Bad() {
  const [, setCount] = useAtom(countAtom)
  setCount(5) // during render!
  return <div />
}

// GOOD
function Good() {
  const [, setCount] = useAtom(countAtom)
  function handleClick() { setCount(5) }
  return <button onClick={handleClick}>Set</button>
}
```

**Families for parameterized state**

```ts
// BAD
const userCacheAtom = Atom.make<Record<string, User>>({})

// GOOD
export const userFamily = Atom.family((id: UserId) =>
  ApiClient.query("users", "get", { path: { id } })
)
```

---

## Suspense

Place `Suspense` and error boundaries at route/layout level.

```tsx
<Suspense fallback={<PageSkeleton />}>
  <ErrorBoundary fallback={<ErrorPage />}>
    <Outlet />
  </ErrorBoundary>
</Suspense>
```

### useAtomSuspense

Components use `useAtomSuspense`. No manual loading/error handling.

```tsx
function ProjectList() {
  const { value: projects } = useAtomSuspense(ProjectsAtom)
  return <ul>{projects.map((p) => <ProjectRow key={p.id} project={p} />)}</ul>
}
```

---

## Props: No Prop Drilling

Don't pass large objects or many props through layers.

**Allowed patterns:**
- Atoms for cross-tree data; pass only IDs/handlers locally
- Compound/composition components
- Context for tree-scoped concerns (theme, form)

```tsx
// BAD
function App() {
  const user = useUser()
  return <Dashboard user={user} />
}
function Dashboard({ user }) {
  return <Sidebar user={user} />
}

// GOOD
function UserAvatar() {
  const { value: user } = useAtomSuspense(currentUserAtom)
  return <Avatar src={user.avatarUrl} />
}
```

---

## Component Structure

### Composition over props

```tsx
// GOOD
<Card>
  <CardHeader><h2>Title</h2></CardHeader>
  <CardBody><p>Content</p></CardBody>
</Card>

// BAD
<Card title="Title" content={<p>Content</p>} />
```

### Split by data dependency

Each component subscribes to its atoms.

```tsx
function Dashboard() {
  return (
    <div>
      <StatsPanel />
      <UsersList />
    </div>
  )
}

function StatsPanel() {
  const { value: stats } = useAtomSuspense(statsAtom)
  return <Stats data={stats} />
}
```

### Namespace pattern for props

For complex props, use namespace pattern (see `code-style`).

Simple components (1–2 props) can inline.

---

## Data Fetching

Use atom families for parameterized queries.

```ts
export const companyFamily = Atom.family((id: CompanyId) =>
  ApiClient.query("companies", "get", {
    path: { id },
    timeToLive: Duration.minutes(5)
  })
)
```

---

## Performance

### Compute in atoms

```ts
export const sortedEntriesAtom = Atom.readable((get) => {
  const entries = get(entriesAtom)
  const sortBy = get(sortByAtom)
  return entries.toSorted(...)
})
```

### Minimize re-renders

- One atom subscription per component
- Use families for parameterized data
