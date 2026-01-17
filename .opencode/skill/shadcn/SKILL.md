---
name: shadcn
description: shadcn/ui registry usage, CLI workflows, component composition. Use when adding shadcn/ui components.
metadata:
  domain: frontend
  stack: shadcn
  scope: workflow
---

# shadcn

## CLI

Rules:
- Use CLI, no copy/paste from docs.

List/search:
- `bunx shadcn@latest search @shadcn`
- `bunx shadcn@latest list @shadcn`

View:
- `bunx shadcn@latest view @shadcn/button`

Add:
- `bunx shadcn@latest add @shadcn/button`
- `bunx shadcn@latest add @shadcn/button @shadcn/card`

Init (new project only):
- `bunx shadcn@latest init`

## Registry Use

Rules:
- Prefer registry components.
- Extend via composition, not rewrite.

## Composition

```tsx
// GOOD
<Dialog>
  <DialogTrigger>Open</DialogTrigger>
  <DialogContent>
    <DialogHeader>Title</DialogHeader>
    <DialogBody>Content</DialogBody>
  </DialogContent>
</Dialog>
```
