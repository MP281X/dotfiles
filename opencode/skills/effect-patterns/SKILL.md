---
name: effect-patterns
description: Strict Effect patterns for Schema, errors, services, layers, and data structures
---

# Effect Patterns

## What This Skill Does
- Effect rules for Schema, errors, services, layers, data.
- Error handling + Match + purity + immutability live here.

## When To Use
Use when working with Effect ecosystem (Effect, Schema, Layer, Context, Match, etc.).

## Non-Goals
- General TS style: naming, modules, comments (see `code-style`).
- React state/UI (see `react-patterns`, `tailwind`, `usability`).

---

## Schema

### Prefer Schema.Class over Schema.Struct

```ts
// BAD
export const Account = Schema.Struct({ id: AccountId, name: Schema.String })

// GOOD
export class Account extends Schema.Class<Account>("Account")({
  id: AccountId,
  name: Schema.String
}) {
  get displayName() {
    return `${this.name} (${this.id})`
  }
}
```

### Branded IDs

All IDs must be branded. Never use raw `string`.

```ts
export const AccountId = Schema.NonEmptyTrimmedString.pipe(
  Schema.brand("AccountId")
)
export type AccountId = typeof AccountId.Type
```

### Schema.TaggedError for errors

All domain errors use `Schema.TaggedError`. Include metadata and descriptive `message`.

```ts
export class AccountNotFound extends Schema.TaggedError<AccountNotFound>()(
  "AccountNotFound",
  { accountId: AccountId }
) {
  get message() {
    return `Account not found: ${this.accountId}`
  }
}
```

### Schema decoding

Never use sync decoding (throws). Always yield.

```ts
// BAD
const account = Schema.decodeUnknownSync(Account)(data)

// GOOD
const account = yield* Schema.decodeUnknown(Account)(data)
```

### Never use *FromSelf

Use `Schema.Option(X)` not `Schema.OptionFromSelf(X)`.

---

## Errors

### No throw / No try-catch

Never use `throw` or `try/catch`. Model errors explicitly.

```ts
// BAD
if (!user) throw new Error("User not found")

// GOOD - yield or return the error directly
if (!user) return yield* new UserNotFound({ userId })
```

`Schema.TaggedError` can be yielded or returned directly. No need for `Effect.fail`.

```ts
// Unnecessary
return Effect.fail(new UserNotFound({ userId }))

// Preferred
return yield* new UserNotFound({ userId })
// or in non-generator context
return new UserNotFound({ userId })
```

### Never use global Error

Always use domain-specific `Schema.TaggedError`.

```ts
// BAD
Effect.fail(new Error("failed"))

// GOOD
yield* new ValidationError({ field: "email", reason: "invalid format" })
```

### Use catchTag

```ts
fetchAccount(accountId).pipe(
  Effect.catchTag("AccountNotFound", () => Effect.succeed(defaultAccount)),
  Effect.catchTag("PersistenceError", (error) => Effect.logError(error.cause))
)
```

### Never catchAll on never

If error type is `never`, effect can't fail. Don't add catchAll.

### Never catchAllCause to wrap errors

Catches defects that should propagate. Use `mapError` instead.

---

## Services

### Service + Context.Tag

```ts
export type AccountService = {
  readonly findById: (id: AccountId) => Effect.Effect<Account, AccountNotFound>
  readonly findAll: () => Effect.Effect<ReadonlyArray<Account>>
}

export class AccountService extends Context.Tag("AccountService")<
  AccountService,
  AccountService
>() {}
```

### Naming: Suffix Live/Test/Mock

```ts
// BAD
export const AccountServiceLayer = Layer.effect(...)

// GOOD
export const AccountServiceLive = Layer.effect(...)
export const AccountServiceTest = Layer.effect(...)
```

### Layer.effect (no cleanup)

```ts
const make = Effect.gen(function* () {
  const sql = yield* SqlClient.SqlClient
  return {
    findById: (id) => Effect.gen(function* () { ... }),
    findAll: () => Effect.gen(function* () { ... })
  }
})

export const AccountServiceLive = Layer.effect(AccountService, make)
```

### Layer.scoped (with cleanup)

```ts
const make = Effect.gen(function* () {
  const changes = yield* PubSub.unbounded<AccountChange>()
  yield* Effect.forkScoped(backgroundFiber)
  return { ... }
})

export const AccountServiceLive = Layer.scoped(AccountService, make)
```

---

## Data Structures

### Use Effect's immutable structures

- `HashMap` / `HashSet` instead of `Map` / `Set`
- `Chunk` instead of `Array` when equality matters
- `Option` instead of `null` / `undefined`
- `DateTime` instead of `Date`

```ts
// BAD
const cache = new Map<UserId, User>()
const createdAt = new Date()

// GOOD
const cache = HashMap.empty<UserId, User>()
const createdAt = DateTime.unsafeNow()
```

### Value-based equality

```ts
const a1 = Account.make({ id, name: "Cash" })
const a2 = Account.make({ id, name: "Cash" })
Equal.equals(a1, a2) // true
```

---

## Utility Modules

### Predicate over JS checks

```ts
// BAD
if (!x) ...
if (typeof x === "string") ...

// GOOD
if (Predicate.isNullable(x)) ...
if (Predicate.isString(x)) ...
```

### String module

```ts
// BAD
x === ""

// GOOD
String.isEmpty(x)
```

### Match for exhaustive branching

All union switches must be exhaustive.

```ts
// BAD
x === "a" ? ... : x === "b" ? ... : ...

// GOOD
pipe(
  Match.type<Status>(),
  Match.when("pending", () => ...),
  Match.when("active", () => ...),
  Match.when("archived", () => ...),
  Match.exhaustive
)
```

---

## Purity and Boundaries

### Pure by default

Functions must be pure unless they return `Effect.Effect`.

```ts
// BAD - side effect in plain function
function saveUser(user: User): User {
  database.insert(user)
  return user
}

// GOOD
function saveUser(user: User): Effect.Effect<User, DatabaseError> {
  return Effect.gen(function* () {
    yield* database.insert(user)
    return user
  })
}
```

### Async only at boundaries

`async function` only at integration boundaries. Core logic uses `Effect.gen`.

### Allowed effect boundaries

Side effects (DOM, network, timers) only in:
- Effect services/layers
- Atom construction/effects
- TanStack Router loaders/actions
- UI event handlers (must immediately call Effect)

---

## Anti-Patterns

- Never use `any` or type casts.
- Never use `{ disableValidation: true }`.
- Don't wrap safe synchronous operations in `Effect` without reason.
- Never use `Promise` in core logic; convert at boundaries.
