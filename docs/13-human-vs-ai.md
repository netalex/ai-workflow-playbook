# Human vs AI responsibilities

## Why this separation matters

Without an explicit boundary, AI workflows drift into one of two bad extremes:

- the human micromanages every trivial transformation
- the AI is treated like an autonomous owner

This playbook rejects both extremes.

## The human is responsible for

- defining the deliverable
- approving architecture
- setting the context boundary
- validating generated bundles
- deciding what becomes durable knowledge
- checking correctness and business fit
- approving commits and releases
- maintaining scripts, hooks, and skills

## The AI is responsible for

- proposing structure
- drafting code or documentation
- summarizing context
- suggesting bundle scopes
- identifying likely risks
- generating alternative options
- converting raw notes into cleaner formats

## Decision rule

If a choice affects architecture, security, scope, or acceptance, it belongs to the human.

If a choice is a candidate transformation inside a declared boundary, it may be delegated to the AI.

## Production rule

The AI can produce:

- drafts
- options
- summaries
- bundle suggestions
- structured notes
- candidate scripts
- candidate skills

The human decides which of those become:

- code
- docs
- vault content
- hooks
- commit history

## Durable-knowledge rule

The AI may propose durable knowledge, but the human chooses the destination:

- repository
- running-knowledge vault
- historical-value vault
- skill vault

## Review rule

Never accept AI output solely because it is fluent.

Accept it only after one or more of these:

- source review
- diff review
- local execution
- test confirmation
- document spot-check
- retrieval QA
