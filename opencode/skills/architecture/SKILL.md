---
name: architecture
description: System boundaries, runtime wiring, module layout, integration edges. Use for architecture decisions and high-level design.
metadata:
  domain: backend
  stack: effect,tanstack-start,bun
  scope: rules
---

# Architecture

## Method (step-by-step)

1. State verified facts (repo + request).
2. State constraints (runtime, stack, tools).
3. Define boundaries (domain vs IO).
4. List options (≤3).
5. Compare tradeoffs.
6. Recommend ONE path.
7. Provide steps + validation.

## Output Template

```
DECISION: [1-2 sentences]
WHY: [key reasoning]
STEPS:
1. [action + file/location]
2. ...
RISKS:
- [risk]: [mitigation]
EFFORT: Quick | Short | Medium | Large
```

## Boundaries

Rules:
- Domain stays pure. No IO.
- IO lives at edges (db/http/fs).
- Dependencies flow inward only.
- Effects return typed errors.

```ts
// BAD
function saveUser(user: User): User {
  database.insert(user)
  return user
}

// GOOD
function saveUser(user: User): Effect.Effect<User, DatabaseError> {
  return Effect.gen(function* () {
    yield* Database.insert(user)
    return user
  })
}
```

## Dependency Direction

Rules:
- UI -> application -> domain -> infra.
- Domain imports no infra.
- Infra depends on domain types only.

```ts
// BAD (domain imports infra)
import { SqlClient } from '@/infra/sql'

// GOOD (infra imports domain)
import { Account } from '@/domain/Account'
```

## Runtime Wiring

Rules:
- Compose layers once at entry.
- Provide once at top-level.

```ts
const appLayer = ApiLayer.pipe(Layer.provide(DatabaseLayer))

const program = Effect.gen(function* () {
  const api = yield* Api
  return yield* api.start
})

Effect.runPromise(program.pipe(Effect.provide(appLayer)))
```

## Module Layout

Rules:
- One concept per module.
- Types before functions.
- Named exports only.
- No barrel files.

```ts
// GOOD
export type UserId = Brand<'UserId'>
export type User = { id: UserId; name: string }
export function createUser(input: CreateUserInput) {}
```

## Integration Edges

Rules:
- Validate input at edge.
- Map external errors to domain errors.

```ts
// GOOD
const handler = Effect.gen(function* () {
  const input = yield* Schema.decodeUnknown(CreateUserInput)(payload)
  return yield* Users.create(input)
}).pipe(
  Effect.catchTag('ParseError', error => new BadRequest({ error }))
)
```

## Example Decision

```
DECISION: Split user write path into service + repo boundary.
WHY: Clear IO boundary, typed errors, testable core.
STEPS:
1. Add Users service tag in src/users/Users.ts
2. Implement UsersLive layer in src/users/UsersLive.ts
3. Wire layer at entry in src/main.ts
4. Add unit tests with test layer
RISKS:
- Missing adapter coverage: add integration test
EFFORT: Medium
```
