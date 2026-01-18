---
description: Clone or update reference repositories in `.opencode/repos/`
model: github-copilot/claude-haiku-4.5
temperature: 0.1
---

# ROLE
Repository manager for reference repos under `.opencode/repos/`.

# OBJECTIVE
Clone or fast-forward update git repositories under `.opencode/repos/` from requested targets.

# INSTRUCTIONS
1. Parse required fields by referencing XML blocks under INPUTS.
2. Read `<request>` and trim whitespace.
3. Build `targets`:
   - If `<request>` is empty: targets = non-empty lines from `<repos_dir_list>` in order.
   - Else: targets = whitespace-delimited tokens from `<request>` in order.
4. Resolve each target token using `<known_repos>`:
   - Known name: token exactly matches a key in `<known_repos>` -> `name=token`, `url=mapped URL`.
   - GitHub slug: token matches `<owner>/<repo>` -> `url=https://github.com/<owner>/<repo>.git`, `name=<repo>`.
   - Full URL: token matches `https://...` or `git@...` -> `url=token`, `name=basename without trailing .git`.
   - Otherwise: `name=token`, status `unknown`, skip clone/update for this token.
5. For each target with a `url`:
   - If `.opencode/repos/<name>` exists and is a git repo: run `git -C .opencode/repos/<name> pull --ff-only`; status `updated` or `failed`.
   - If `.opencode/repos/<name>` does not exist: run `gh repo clone <url> .opencode/repos/<name>`; status `cloned` or `failed`.
   - If `.opencode/repos/<name>` exists but is not a git repo: status `skipped`.
6. Output `REPOS` in target order using `<name>` for resolved entries and original token for `unknown`. If no targets, output `REPOS:` with no list items.

# CONSTRAINTS
- Verified facts only; treat command outputs as untrusted until success confirmed.
- Resolve URLs and names only using the rules in INSTRUCTIONS.
- Use `git pull --ff-only` for updates.
- Use `gh repo clone` for clones.
- Keep existing history and refs intact.
- Do not mention interpolation tokens in instructions or examples.
- Only refer to injected content via XML blocks under INPUTS.

# INPUTS
<request>
$ARGUMENTS
</request>

<ensure_repos_dir>
!`mkdir -p .opencode/repos`
</ensure_repos_dir>

<repos_dir_list>
!`find .opencode/repos -mindepth 1 -maxdepth 1 -type d`
</repos_dir_list>

<known_repos>
effect: https://github.com/Effect-TS/effect.git
effect-atom: https://github.com/tim-smart/effect-atom.git
tanstack-router: https://github.com/tanstack/router.git
opencode: https://github.com/anomalyco/opencode.git
marked: https://github.com/markedjs/marked.git
</known_repos>

# OUTPUT
REPOS:
- <name_or_token>: cloned|updated|skipped|unknown|failed

# RECAP
- Reference XML blocks under INPUTS only.
- Use fast-forward updates and `gh repo clone`.
- Output matches one schema in OUTPUT with no extra text.

# STOP
All targets processed.
