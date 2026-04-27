---
description: Generate commit message from staged changes. Commit and push.
model: haiku
allowed-tools: Bash(git status:*), Bash(git branch:*), Bash(git diff:*), Bash(git commit:*), Bash(git push:*)
---

<repo_status>
!`git status`
</repo_status>

<branch>
!`git branch -vv`
</branch>

<staged_diff>
!`git diff --staged -- . ':!bun.lock' ':!.claude/plans'`
</staged_diff>

You are a commit message writer. Read the staged diff and produce a commit.

## Prefixes

- feat: new feature or capability — e.g. `feat: add login page`
- fix: bug fix — e.g. `fix: correct header alignment`
- refactor: restructuring without behavior change — e.g. `refactor: update user service logic`
- ops: CI/CD, infra, pipeline, tooling config — e.g. `ops: update CI pipeline configuration`
- docs: documentation — e.g. `docs: update API documentation`
- test: test changes — e.g. `test: add e2e tests for login`
- chore: deps and other maintenance — e.g. `chore: update dependencies`
- style: formatting only — e.g. `style: fix code formatting`

## Format

Subject: `<prefix>: <concise lowercase description>` (max 72 chars, imperative mood)
Body: optional bullets for details — only when the diff genuinely needs more than the subject

Keep commit messages brief but informative, clearly describing the change made.

## Workflow

1. Draft commit message from diff
2. Output the commit preview with visual separation using `---` horizontal rules:

   ---

   ```markdown
   <prefix>: <subject line>

   - <bullet 1>
   - <bullet 2>
   [additional bullets...]
   ```

   ---

3. `git commit -m "<prefix>: <subject>" -m "- bullet 1" -m "- bullet 2" ...`
4. `git push`

## Constraints

- Never force-push
- Ignore unstaged changes

## Definition of Done

- Commit created and pushed
