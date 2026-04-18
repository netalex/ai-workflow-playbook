# Overview

## Goal

Build a practical AI workflow that is:

- repeatable
- reviewable
- cost-aware
- resilient to context loss
- independent from any single chat silo

## The model

This workflow is built from six layers.

1. **Execution base**  
   VS Code is the operational center for code, terminal work, local validation, Git, and most day-to-day file editing.

2. **Reasoning layer**  
   A higher-level reasoning tool is used for architecture, synthesis, planning, document consolidation, and cross-source thinking.

3. **Execution assistant layer**  
   Editor-native assistants are used for bounded implementation, local refactors, test iteration, and tactical changes.

4. **Memory layer**  
   Durable local memory is stored in vaults and repository docs, not only in chat history.

5. **Packaging layer**  
   Context is prepared through repomix bundles and pre-chunked vault material.

6. **Human review layer**  
   The human defines the target, approves the direction, validates the result, and decides what becomes durable knowledge.

## Why VS Code is the base

VS Code is not just “an editor” in this workflow.

It is the shared operational base because it concentrates:

- source control
- terminal execution
- code review
- local testing
- extension-based AI execution
- workspace-level configuration
- file-level validation

That makes it the most stable place to anchor the workflow, even if the reasoning tool changes.

## Main outcome

The outcome is not “more chat.”

The outcome is a durable loop:

```text
Deliverable
  -> bounded context
  -> AI reasoning
  -> editor execution
  -> local validation
  -> durable notes
  -> clean commit-ready state
```

## Failure modes this playbook tries to reduce

- sending full repositories to an LLM by default
- relying on chat memory for project facts
- mixing architecture, implementation, and review in one uncontrolled prompt
- repeating the same instructions every session
- indexing raw documents without chunking
- exposing more files to filesystem MCP than the task requires
- paying token cost for context that adds no value

## Design assumptions

This playbook assumes:

- medium or large repositories
- real constraints on time and token budget
- the need to preserve project knowledge over multiple sessions
- a preference for human-in-the-loop operation
- a willingness to invest in scripts, hooks, and durable prompts

## Success criteria

A healthy workflow should make it easier to:

- recover context after interruption
- package the right input faster
- reduce prompt repetition
- reduce token waste
- keep a clear line between transient drafts and durable assets
- move from question to validated change with fewer blind spots
