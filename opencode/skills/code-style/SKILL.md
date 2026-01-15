---
name: code-style
description: TypeScript naming, functions, control flow, types, modules. Use for code style and conventions.
metadata:
  domain: cross
  stack: typescript
  scope: rules
---

# Code Style

## Naming

Rules:
- Full words. No abbreviations.
- Plural for arrays.
- Boolean starts with is/has/should.

```ts
// BAD
const cfg = getConfig()
const data = fetchAccounts()
const ok = user.active

// GOOD
const config = getConfig()
const accounts = fetchAccounts()
const isActive = user.active
```

## Functions (object args)

Rule: >1 arg => config object.

```ts
// BAD
function createUser(name: string, email: string, role: Role, orgId: OrgId) {}

// GOOD
type CreateUserInput = {
  name: string
  email: string
  role: Role
  orgId: OrgId
}

function createUser(input: CreateUserInput) {}
```

```ts
// BAD
function updateAccount(id: AccountId, name: string, status: Status) {}

// GOOD
function updateAccount(input: { id: AccountId; name: string; status: Status }) {}
```

## Control Flow

Rules:
- Guard clauses.
- No nested ifs for error paths.

```ts
// BAD
if (x) {
  if (x.valid) return x.value
}
return null

// GOOD
if (!x) return null
if (!x.valid) return null
return x.value
```

## Types

Rules:
- Prefer `type` over `interface`.
- Prefer unions over enums.

```ts
// BAD
interface User {}

// GOOD
type User = {}
```

```ts
// BAD
enum Status { Pending }

// GOOD
type Status = 'pending' | 'active'
```

## Objects and Records

Rules:
- Readonly for public props.
- Prefer `Record` over index signatures.

```ts
// GOOD
type UserCardProps = {
  readonly userId: UserId
  readonly isSelected?: boolean
}

type UsersById = Record<UserId, User>
```

## Modules

Rules:
- Named exports only.
- No default exports.
- No barrel files.
- Use alias paths.

```ts
// BAD
export default function UserCard() {}

// GOOD
export function UserCard() {}
```

```ts
// BAD
import { User } from '../../models/user'

// GOOD
import { User } from '@/models/user'
```

```ts
export declare namespace UserCard {
  export type Props = { userId: UserId }
}

export function UserCard(props: UserCard.Props) {}
```
