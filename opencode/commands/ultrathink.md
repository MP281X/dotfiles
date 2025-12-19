---
description: Deep analysis mode
model: github-copilot/claude-opus-4.5
---

Task (required):
$ARGUMENTS

Analyze step-by-step using only verified facts. Do not assume or speculate.

## Example

```
Task: "Why does the form submission fail silently in production?"

Approach:
1. Read packages/web/src/components/LoginForm.tsx — trace form submission
2. Check packages/api/src/routes/auth.ts — verify Effect error handling
3. Search for Effect.catchAll without proper logging or toasts
4. Verify React error boundaries catch all Effect fiber failures
5. Check if Layer.toRuntime errors are surfaced to UI

Report: exact line where Effect failure is swallowed + fix with Effect.tapError
```
