# Prompting policy

## Objective

Use prompts as repeatable operational tools, not improvised one-off messages.

## Prompt layers

### 1. Identity and style

Stable instructions such as:

- language conventions
- coding preferences
- review expectations
- commit style
- documentation tone

### 2. Project context

Semi-stable instructions such as:

- architecture rules
- framework constraints
- repository conventions
- team expectations

### 3. Task instructions

Highly specific instructions such as:

- deliverable
- touched files
- constraints
- validation needs
- output format

## Good prompt traits

A good prompt is:

- scoped
- explicit about success
- honest about uncertainty
- clear on constraints
- strict about output shape when needed

## Bad prompt traits

A bad prompt is:

- vague
- overloaded
- contradictory
- reliant on hidden prior context
- missing acceptance criteria

## Standard prompt skeleton

```text
Role / mode
Context
Task
Constraints
Expected output
Validation or review rule
```

## Review-first prompting

For non-trivial work, prefer this order:

1. ask for analysis
2. ask for options
3. choose an option
4. ask for implementation
5. ask for review

This reduces large unreviewed jumps.

## Prompt versioning rule

If a prompt affects repeated work, store it in the repository or the vault.

Examples:

- system prompt variants
- code review prompts
- doc synthesis prompts
- session kickoff prompts
