---
description: Deep analysis mode
model: github-copilot/claude-opus-4.5
temperature: 0.4
---

<task>
  ULTRATHINK to complete the task below. THINK HARD before acting — verify all assumptions. Every claim and decision must be grounded in evidence you have directly observed, not guessed or assumed.
</task>

<arguments>
$ARGUMENTS
</arguments>

<constraints>
  - Do not assume — read, search, or run commands to verify.
  - If you cannot verify something, say so explicitly.
  - Cite sources (file:line, command output) when relevant.
  - Prefer investigation over guessing.
</constraints>

<example>
  <arguments>
    Refactor the auth flow to use httpOnly cookies instead of localStorage
  </arguments>

  <output>
    1. Read packages/web/src/lib/auth.ts — found token stored in localStorage (line 12).
    2. Read packages/api/src/routes/auth.ts — found login endpoint (line 34).
    3. Searched for "localStorage" — found 3 usages in auth.ts, client.ts.
    4. Plan: modify API to set httpOnly cookie, remove localStorage calls, update client to rely on cookie.
    5. Implemented changes, verified with existing auth tests.
  </output>
</example>
