---
description: Deep analysis mode
model: github-copilot/claude-opus-4.5
temperature: 0.4
---

<task>
  ULTRATHINK to complete the task below. THINK HARD before acting — verify all assumptions. Every claim and decision must be grounded in evidence you have directly observed, not guessed or assumed.
</task>

<arguments hint="true">
$ARGUMENTS
</arguments>

<constraints>
  - Do not assume — read, search, or run commands to verify.
  - If you cannot verify something, say so explicitly.
  - Cite sources (file:line, command output) when relevant.
  - Prefer investigation over guessing.
</constraints>

<examples>
  <example type="bad">
    <context>Why is the API slow?</context>
    <output>It's probably the database. Try adding an index.</output>
    <reason>Guessed without profiling or reading code</reason>
  </example>

  <example type="good">
    <context>Why is the API slow?</context>
    <output>
      1. Ran timing on each handler → /users takes 2.3s
      2. Read users.ts:45 → fetches all users, then filters in JS
      3. DB has 50k rows, no WHERE clause
      4. Fix: add WHERE to query, add index on status column
    </output>
  </example>

  <example type="bad">
    <context>Add caching to reduce API calls</context>
    <output>I'll add Redis caching to all endpoints.</output>
    <reason>No analysis of which endpoints need caching</reason>
  </example>

  <example type="good">
    <context>Add caching to reduce API calls</context>
    <output>
      1. Grep for fetch calls → 12 endpoints
      2. Checked access logs → /config called 500x/min, others <10x/min
      3. /config returns static data (verified in config.ts:12)
      4. Plan: cache only /config with 5min TTL
    </output>
  </example>
</examples>
