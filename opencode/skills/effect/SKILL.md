---
name: effect
description: Effect patterns for Schema, errors, services, layers, Match, data. Use for Effect code and APIs.
metadata:
  domain: backend
  stack: effect
  scope: rules
---

# Effect

## Method (step-by-step)

1. Model data with Schema.
2. Model errors with Schema.TaggedError.
3. Wire services with Context.Tag + Layer.
4. Compose effects with Effect.gen.
5. Handle errors with catchTag/Match.

## Schema

Rules:
- Prefer Schema.Class over Schema.Struct.
- Brand primitives for IDs and domain values.
- Avoid `*FromSelf` schemas.

```ts
// BAD
export const Account = Schema.Struct({ id: AccountId, name: Schema.String })

// GOOD
export class Account extends Schema.Class<Account>('Account')({
  id: AccountId,
  name: Schema.String
}) {}
```

```ts
export const AccountId = Schema.NonEmptyTrimmedString.pipe(
  Schema.brand('AccountId')
)
export type AccountId = typeof AccountId.Type
```

```ts
// BAD
export class User extends Schema.Class<User>('User')({
  roles: Schema.Array(Role)
}) {}

// GOOD
export class User extends Schema.Class<User>('User')({
  roles: Schema.Chunk(Role)
}) {}
```

## Errors

Rules:
- No `Error` in error channel.
- Use Schema.TaggedError.
- Yield tagged errors directly.

```ts
// BAD
if (!user) throw new Error('User not found')

// GOOD
if (!user) return yield* UserNotFound.make({ userId })
```

```ts
fetchAccount(accountId).pipe(
  Effect.catchTag('AccountNotFound', () => Effect.succeed(defaultAccount))
)
```

## Effect.gen and Effect.fn

Rules:
- Prefer Effect.gen for sequencing.
- Use Effect.fn for named effects.

```ts
const processUser = Effect.fn('Users.process')(function* (userId: UserId) {
  const user = yield* Users.get(userId)
  return yield* Users.process(user)
})
```

## Services + Layers

Rules:
- Use Context.Tag with readonly methods.
- Provide once at entry.
- Layer.effect for normal setup, Layer.scoped for resources.

```ts
export class AccountService extends Context.Tag('@app/AccountService')<
  AccountService,
  { readonly findById: (id: AccountId) => Effect.Effect<Account, AccountNotFound> }
>() {}

export const AccountServiceLive = Layer.effect(AccountService, make)
```

```ts
const appLayer = AccountServiceLive.pipe(Layer.provide(DatabaseLive))

Effect.runPromise(program.pipe(Effect.provide(appLayer)))
```

## Data

Rules:
- Prefer Effect data types (Chunk, HashMap, HashSet).

```ts
// BAD
const cache = new Map<UserId, User>()

// GOOD
const cache = HashMap.empty<UserId, User>()
```

## Match

Rules:
- Exhaustive matches.

```ts
pipe(
  Match.type<Status>(),
  Match.when('pending', () => ...),
  Match.when('active', () => ...),
  Match.exhaustive
)
```

## IO at the Edge

Rules:
- Decode input at edges.
- Map unknown errors to Schema.Defect.

```ts
export class ApiError extends Schema.TaggedError<ApiError>()('ApiError', {
  error: Schema.Defect
}) {}

const program = Effect.gen(function* () {
  const input = yield* Schema.decodeUnknown(Input)(payload)
  return yield* Users.create(input)
}).pipe(
  Effect.mapError(error => ApiError.make({ error }))
)
```
