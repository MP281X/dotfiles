---
description: Initialize AGENTS.md for monorepo. Creates root + package-specific files.
model: opencode/glm-4.7-free
temperature: 0.2
subtask: true

permission:
  read: allow
  edit: allow
  bash:
    "*": allow
    "git *": deny
    "rm *": deny
---

$ARGUMENTS

Initialize AGENTS.md files for monorepo structure.

## Style

Terse. No preamble.

## Workflow

1. Detect monorepo structure:
   - pnpm-workspace.yaml
   - packages/*, apps/* directories
   - turbo.json, nx.json

2. Create root AGENTS.md:
   - Project overview
   - Shared conventions (formatting, imports, types)
   - Common commands
   - Links to package-specific docs

3. For each package/app with package.json:
   - Create {package}/AGENTS.md
   - Package-specific build/test commands
   - Tech stack details
   - Key files/entry points

## Root AGENTS.md Template

```markdown
# {Project Name}

## Structure
- apps/: Applications
- packages/: Shared libraries

## Commands
- `{pm} run fix` - Fix formatting/linting
- `{pm} run check` - Type-check + lint
- `{pm} run build` - Build all

## Conventions
{extracted from existing code}

## Package Docs
- [apps/web](apps/web/AGENTS.md)
- [packages/core](packages/core/AGENTS.md)
```

## Package AGENTS.md Template

```markdown
# {Package Name}

## Purpose
{one line description from package.json}

## Commands
- `{pm} run dev` - Development
- `{pm} run build` - Production build

## Key Files
- src/index.ts - Entry point
- {other important files}

## Stack
{detected frameworks/libraries}
```

## Constraints

- Skip if AGENTS.md exists (unless --force)
- ~100 lines per file max
- Extract conventions from existing code
- Include cursor/copilot rules if present
