---
name: code-style
description: Strict TS conventions for naming, control flow, functions, types, and modules
---

# Code Style

## What This Skill Does
- Strict TS conventions.
- Optimize explicitness; easy grep; safe refactor.

## When To Use
Use when writing or refactoring any TS/JS code.

## Non-Goals
- React architecture (see `react-patterns`).
- UI/UX conventions (see `tailwind`, `usability`).
- Effect idioms (errors, Schema, Match, purity) (see `effect-patterns`).
- Formatting/linting (Biome).
- Type errors (TypeScript LSP).

---

## Naming

**No abbreviations**

Names must be fully spelled out and self-explanatory.

```ts
// BAD
const cfg = getConfig()
const btn = document.querySelector("button")

// GOOD
const config = getConfig()
const button = document.querySelector("button")
```

**No generic names**

Ban: `data`, `info`, `item`, `stuff`, `util`, `helper`, `value`, `result`. Use domain-specific names.

```ts
// BAD
const data = fetchAccounts()

// GOOD
const accounts = fetchAccounts()
```

**Verb functions**

Function names are verbs. Predicates start with `is`/`has`/`can`/`should`.

```ts
// BAD
function user(id: UserId) { ... }

// GOOD
function fetchUser(id: UserId) { ... }
function isValid(input: string) { ... }
```

**No destructuring**

Prefer explicit access paths.

```ts
// BAD
const { state } = props.part

// GOOD
const command = getString(props.part.state.input, "command")
```

**No local aliasing**

Don't create local aliases for deep properties.

```ts
// BAD
const state = props.part.state

// GOOD
const completed = props.part.state.time.completed
```

---

## Functions

**Max arity = 2**

Functions have at most 2 parameters. For more inputs, use a config object.

```ts
// BAD
function createUser(name: string, email: string, role: Role, orgId: OrgId) { ... }

// GOOD
function createUser(name: string, config: CreateUserConfig) { ... }
```

**Config object typing**

- Simple (1–2 keys): inline type acceptable.
- Complex (nested): extract to named type using namespace pattern.

```ts
export declare namespace CreateUser {
  export type Config = {
    email: string
    role: Role
    organizationId: OrgId
  }
}

export function createUser(name: string, config: CreateUser.Config) { ... }
```

**Function declarations over arrows**

Prefer `function name()` for named functions. Arrows only for callbacks.

```ts
function handleClick() { ... }

items.map((item) => transform(item))
```

---

## Control Flow

**Flat + vertical**

Prefer early returns over nested conditionals.

```ts
// BAD
function process(x) {
  if (x) {
    if (x.valid) {
      return x.value
    }
  }
  return null
}

// GOOD
function process(x) {
  if (!x) return null
  if (!x.valid) return null
  return x.value
}
```

**Avoid long boolean chains**

Decompose long `||` / `&&` chains and nested ternaries into named guards.

---

## Types

**No enums**

Use literal unions.

```ts
// BAD
enum Status { Pending, Active }

// GOOD
type Status = "pending" | "active"
```

**No interface**

Use `type` only.

```ts
// BAD
interface User { ... }

// GOOD
type User = { ... }
```

**Namespace pattern**

For complex props/configs, use `declare namespace`:

```ts
export declare namespace UserCard {
  export type Props = {
    userId: UserId
    showActions: boolean
  }
}

export function UserCard(props: UserCard.Props) { ... }
```

Simple types (1–2 keys) can be inline.

---

## Modules

**No default exports**

Always use named exports.

```ts
// BAD
export default function UserCard() { ... }

// GOOD
export function UserCard() { ... }
```

**No relative parent imports**

Use absolute/alias imports.

```ts
// BAD
import { User } from "../../models/user"

// GOOD
import { User } from "@/models/user"
```

**One concept per module**

Each module focuses on one specific functionality. Keep related code together.

**Code organization**

- Types before functions that use them.
- Group logically (caller near callee).

---

## Abstraction

**Prefer duplication over 1–2 use helpers**

Only introduce helpers with 3+ uses or significant complexity isolation.

```ts
// BAD (used once)
function formatLabel(input: string) {
  return input === "" ? "-" : input.trim()
}

// GOOD
const label = String.isEmpty(value) ? "-" : String.trim(value)
```

---

## Comments

**Minimal comments**

Code should be self-explanatory. Comments only explain *why*, never *how*.

- Docstrings for public APIs explaining rationale/constraints.
- No inline comments for obvious code.

---

## Regex

**Named regex only**

Extract regex to named constants with examples.

```ts
// BAD
if (/^[a-z0-9]+(-[a-z0-9]+)*$/.test(input)) { ... }

// GOOD
const SKILL_NAME_PATTERN = /^[a-z0-9]+(-[a-z0-9]+)*$/
// Matches: "foo", "foo-bar"
// Rejects: "Foo", "foo--bar"

if (SKILL_NAME_PATTERN.test(input)) { ... }
```
