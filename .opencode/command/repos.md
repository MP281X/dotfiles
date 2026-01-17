---
description: Clone or update reference repositories in `.repos/`

model: github-copilot/claude-haiku-4.5
temperature: 0.1
---

$ARGUMENTS

<role>
Repository manager. Clone or update repos under `.repos/`.
</role>

<repos>
Known repo index (optional). Clone only on explicit user request.

# name: url
# (User may request any URL/owner/repo not listed here.)

effect: https://github.com/Effect-TS/effect.git
effect-atom: https://github.com/tim-smart/effect-atom.git
tanstack-router: https://github.com/tanstack/router.git
opencode: https://github.com/anomalyco/opencode.git
marked: https://github.com/markedjs/marked.git
</repos>

<interface>
- `/repos`:
  - Ensure `.repos/` exists
  - Pull all existing repos under `.repos/`
- `/repos <name>` or `/repos <url>` or `/repos <name>/<url>` or `/repos <owner>/<repo>`:
  - If `<url>` provided: clone into `.repos/<name>` (derive `<name>` from URL if missing)
  - Else if `<owner>/<repo>` provided: clone `https://github.com/<owner>/<repo>.git` into `.repos/<repo>`
  - Else if `<name>` matches `<repos>` index: use mapped URL
  - Else: report unknown name (ask for URL or owner/repo)
</interface>

<constraints>
- Use tools to edit files; do not emit "check then echo" shell snippets
- Use `git pull --ff-only`
- Prefer shallow clone: `--depth 1 --single-branch`
</constraints>

<workflow>
1. Ensure `.repos/` is ignored
   - Edit `.gitignore` and add `.repos/` if missing

2. Ensure `.repos/` exists
   ```bash
   mkdir -p .repos
   ```

3. Resolve targets from `$ARGUMENTS`
   - Empty: all directories under `.repos/`
   - Name: `.repos/<name>`
   - URL: `.repos/<derived-name>`
   - Name + URL: `.repos/<name>`

4. Clone or update
   ```bash
   # Clone
   git clone --depth 1 --single-branch <url> .repos/<name>

   # Update
   git -C .repos/<name> pull --ff-only
   ```
</workflow>

<output>
GITIGNORE: added|already_present
REPOS:
- <name>: cloned|updated|skipped|unknown
</output>
