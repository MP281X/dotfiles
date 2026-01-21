---
description: Commit staged changes, rebase, push.
model: opencode/big-pickle
---

commit and push

## Inputs
<request>
$ARGUMENTS
</request>

<repo_status>
!`git status`
</repo_status>

<branch_vv>
!`git branch -vv`
</branch_vv>

<staged_diff>
!`git diff --staged`
</staged_diff>

## Prefixes (Conventional Commits)
- `feat:` new feature
- `fix:` bug fix
- `docs:` documentation
- `refactor:` restructuring
- `perf:` performance
- `test:` tests
- `chore:` maintenance (deps/config)
- `ci:` CI/CD
- `style:` formatting only

## Message style
- Subject: `<prefix>: <what happened>` (<= 72 chars).
- Body (optional): 1-3 lines, user impact / why. Avoid implementation detail.
- Use `<request>` only if consistent with `<staged_diff>`.

## Safety stops
- If `<repo_status>` shows an in-progress rebase/merge/cherry-pick, STOP and report it.
- If `<staged_diff>` is empty, STOP and ask the user to stage changes.
- If `<branch_vv>` shows no upstream tracking branch, STOP and ask which remote/branch to push to.
- Never force-push; never use destructive flags.

## Process (git commands you DO run)
1. Draft commit message from `<staged_diff>`.
2. `git commit` (one commit).
3. `git pull --rebase` (if conflicts: STOP and tell user to resolve manually).
4. `git push`.

## Output
Return:
- Commit message used
- Commands run + one-line result each
- Final result (success or STOP reason)
