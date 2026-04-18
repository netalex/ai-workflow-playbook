# Commit style template

Use Conventional Commits and standard best practices.

## Rules

- use a valid Conventional Commit type
- keep the subject imperative
- keep the subject focused on one change set
- do not waste the subject on noise like “final” or “misc”
- use the body to capture context, trade-offs, and validation
- mention breaking changes explicitly when they exist

## Recommended structure

```text
type(scope): concise imperative summary

Why:
- why this change exists

What:
- what changed
- what was intentionally left out

Validation:
- commands run
- manual checks performed

Refs:
- issue, task, or note when relevant
```

## Examples

```text
docs(workflow): document token-aware repomix automation
```

```text
feat(scripts): add configurable composite repomix generator
```

```text
chore(hooks): refresh ai-input after checkout and merge
```

## Common types

- `feat`
- `fix`
- `docs`
- `refactor`
- `test`
- `build`
- `chore`
- `ci`
- `perf`

## Best-practice reminder

A good commit message explains the change to a future reader, not just to the current author.
