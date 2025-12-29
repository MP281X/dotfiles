---
description: git commit and push
model: zai-coding-plan/glm-4.7
temperature: 0.3
subtask: true
---

<task>
Create concise Conventional Commits describing WHAT changed. Add optional body for complex changes. Commit, pull --rebase, and push. Stop on rebase conflicts.
</task>

<arguments hint="true">
$ARGUMENTS
</arguments>

<prefixes>
feat, fix, docs, refactor, perf, test, chore, ci, style
</prefixes>

<constraints>
- Title under 72 chars: <prefix>: <what changed>
- Use ONLY the prefixes listed above
- Be specific, never generic ("update code", "fix bug")
- Focus on WHAT, not WHY or HOW
- Add body (1-3 bullets) only for substantial/multi-area changes
- Stop immediately on rebase conflicts
</constraints>

<examples>
<example type="bad">
  <output>feat: updated API client</output>
  <reason>Too generic</reason>
</example>

<example type="good">
  <output>feat: add retry logic to API client</output>
</example>

<example type="good_with_body">
  <output>refactor: restructure auth module

- Split auth logic into validator and handler files
- Extract error handling into dedicated module
- Update imports across 15 files</output>
</example>
</examples>
