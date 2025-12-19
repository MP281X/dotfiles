---
description: git commit and push
model: opencode/glm-4.6
subtask: true
---

commit and push

## Prefixes (Conventional Commits)
- `feat:` — new feature
- `fix:` — bug fix
- `docs:` — documentation
- `refactor:` — code restructuring
- `perf:` — performance improvement
- `test:` — tests
- `chore:` — maintenance (deps, config)
- `ci:` — CI/CD changes
- `style:` — formatting, no logic change

## Message Style
Explain WHY from user perspective, not WHAT. Be specific, avoid generic phrases.

Examples:
- `feat: allow filtering results by date range`
- `fix: prevent memory leak when closing multiple tabs`
- `refactor: simplify error handling to reduce code duplication`
- `perf: cache parsed config to reduce startup time`

## Process

1. **Pull changes** — `git fetch` then `git pull --rebase` if needed. If conflicts: STOP and notify user.

2. **Review** — Check `git status` and diffs to determine prefix.

3. **Commit** — Draft specific message explaining user impact. Stage, commit, push.

If rebase conflicts occur, DO NOT fix them. Output: "Rebase conflicts detected. Resolve manually."
