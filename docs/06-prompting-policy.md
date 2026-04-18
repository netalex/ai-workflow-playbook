# Prompting policy

Use prompts as repeatable operational tools, not improvised one-off messages.

## Prompt layers

### 1. Identity and style

Stable instructions such as:

- language conventions
- coding preferences
- review expectations
- output structure
- documentation tone

These belong in templates, skills, or tool settings.

### 2. Project context

Semi-stable instructions such as:

- architecture rules
- framework constraints
- repository conventions
- team expectations
- security boundaries
- allowed directories

These belong in repository docs, vault notes, or project-level prompt assets.

### 3. Task instructions

Highly specific instructions such as:

- deliverable
- files in scope
- constraints
- acceptance criteria
- validation rule
- output format

These belong in the session itself.

## Default prompt skeleton

```text
Role or mode
Task
Context
Constraints
Files or bundle in scope
Expected output
Validation or review rule
```

## Review-first prompting

For non-trivial work, prefer this order:

1. ask for analysis
2. ask for options
3. select the option yourself
4. ask for implementation
5. ask for review
6. convert stable findings into durable knowledge

This reduces large unreviewed jumps.

## Prompt versioning rule

If a prompt affects repeated work, store it in one of these places:

- repository template
- running-knowledge vault
- skill vault

Do not keep paying for the same instruction in every session.

## Good prompting habits

- declare the scope boundary
- give the AI the smallest useful context
- state what not to touch
- request trade-offs before code for non-trivial work
- demand file-by-file reasoning when the scope is broad
- ask for uncertainty to be called out explicitly

## Bad prompting habits

- “clean this up”
- “fix the whole project”
- “use whatever files you need”
- “just make it better”
- “remember this forever” without deciding whether it belongs in the repo or a vault

## Skill rule

If a prompt should affect many future tasks, it is probably not just a prompt anymore.

It is probably a **skill**.

See [templates/skill-template.md](../templates/skill-template.md) and [docs/14-ctxvault-and-skills.md](14-ctxvault-and-skills.md).
