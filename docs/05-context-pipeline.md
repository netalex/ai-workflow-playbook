# Context pipeline

## Why context packaging matters

The fastest way to degrade AI output is to provide too much irrelevant material.

This workflow prefers **curated context** over repository dumping.

## Pipeline

```text
Repository -> Focused extraction -> Short problem statement -> AI reasoning -> Controlled implementation
```

## What to include

Include only what the model needs to answer well:

- the target files
- directly related interfaces or schemas
- relevant config
- failing tests or logs
- a precise problem statement
- constraints and success criteria

## What to avoid

Avoid including:

- huge unrelated folders
- generated files
- lockfiles unless dependency problems are the task
- old notes with contradictory decisions
- screenshots without explanatory text

## Durable vs transient context

### Durable
Store in repository docs or a vault:
- architectural decisions
- current taskboard
- recurring operational notes
- stable prompts
- known pitfalls

### Transient
Use only for the active task:
- temporary logs
- work-in-progress prompts
- experimental diffs
- disposable bundles

## A good context bundle should answer

- what is the task?
- what is the current behavior?
- what files matter?
- what constraints apply?
- what does success look like?

## Practical rule of thumb

If the receiving model needs five minutes just to understand your context package, the package is probably too big.

## Preferred artifact types

- markdown summaries
- reduced file trees
- selected code slices
- plain-text bundles
- short structured prompts

## Handoff pattern

When moving from reasoning to execution, pass:

1. the agreed plan
2. the scope boundary
3. the files to touch
4. the acceptance checks
5. any non-negotiable style rules

That handoff is where many workflows fail. Make it explicit.
