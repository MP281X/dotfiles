---
description: Refactor for clarity. No behavior change. Validates until clean.
model: github-copilot/claude-sonnet-4.5
temperature: 0.2
subtask: true

permission:
  read: allow
  edit: allow
  bash:
    "*": allow
    "git *": deny
    "npm *": deny
---

$ARGUMENTS

Refactor. Improve readability. No behavior change.

## Style

Terse. No preamble.

## Target

- Path given → refactor that
- Description → find smallest scope
- Empty → uncommitted changes only

## Priorities

1. Correctness
2. Simplicity (remove > add)
3. Flat structure
4. Match existing patterns

## Validation (MANDATORY)

After ANY change:
```
{packageManager} run fix
{packageManager} run check
if errors → fix → repeat
```

NEVER complete with errors.

## Constraints

No scope creep. No behavior changes.
