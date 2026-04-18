# CtxVault and skills

## Why CtxVault matters here

CtxVault is the durable local memory layer in this playbook.

It is used for two classes of value:

1. **knowledge**
2. **skills**

## Rule: vaults only contain pre-chunked material

This is the central operating rule.

A vault should receive:

- chunked markdown from the ingestion workflow
- manually prepared chunk files
- reviewed notes that already represent a retrieval unit
- skill files that are already intentionally shaped

It should not receive raw source documents as the retrieval unit.

## Two vault types

### 1. Running-knowledge vault

Use this for material that changes.

Examples:

- current taskboard
- current status snapshot
- evolving operating notes
- live design questions
- project-specific conventions

This vault is meant to be updated.

### 2. Historical-value vault

Use this for material that should remain queryable but stable.

Examples:

- archived designs
- obsolete but still useful code references
- immutable external documents
- frozen migration artifacts

This vault is meant to preserve reference value.

## Skill vaults

A skill is not just “a good prompt.”

A skill is a reusable unit that affects repeated work in a durable way.

Examples:

- how to prepare a bug-investigation bundle
- how to write a repo-specific code review
- how to convert raw meeting notes into durable docs
- how to build a constrained repomix for a certain subsystem

## Rule for repeated prompts

If a prompt affects repeated work, store it in the repository or the vault.

A good next question is:

**Should this be a template, or should this be a skill?**

### Prefer a repository template when

- the content is general
- it should be visible to collaborators
- it belongs in version control

### Prefer a skill when

- it is operational
- it is repeatedly used in chat or agent workflows
- it belongs with other durable memory assets
- it may evolve without touching the repository every time

## Example skill shape

See [templates/skill-template.md](../templates/skill-template.md).

## Suggested skill categories

- session kickoff
- code review
- bug triage
- repomix selection
- document chunking QA
- commit message generation
- migration planning

## CtxVault installation note

This playbook assumes `ctxvault` is installed with `uv tool`, together with `ctxvault-mcp`.

See [docs/03-setup-windows.md](03-setup-windows.md) and [docs/03-setup-linux.md](03-setup-linux.md).

## Indexing rule

Before indexing a vault, ask:

- is the content pre-chunked?
- is the vault type correct?
- does this belong in the repo instead?
- is this knowledge still changing?
- would a skill be more appropriate than another repeated prompt?
