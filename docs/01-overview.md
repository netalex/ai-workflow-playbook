# Overview

## Goal

Create an AI workflow that is:

- practical in daily software delivery
- robust against context loss
- adaptable across tools
- easy to publish, explain, and evolve

## The model

This workflow splits the problem into five layers:

1. **Reasoning layer**  
   Used for planning, synthesis, architecture, document drafting, decision support.

2. **Execution layer**  
   Used inside the editor for implementation, small edits, test iteration, and local code navigation.

3. **Memory layer**  
   Used to preserve stable project knowledge outside ephemeral chat history.

4. **Packaging layer**  
   Used to prepare focused context bundles instead of dumping whole repositories into prompts.

5. **Human review layer**  
   Used to validate architecture, correctness, style, and business fit.

## Design assumptions

This playbook assumes:

- you do not want a fully autonomous coding agent
- you prefer a review-first workflow
- you care about repository hygiene
- you work on non-trivial codebases
- you may need both local and cloud tools
- you want prompt discipline, not prompt chaos

## Main outcome

The outcome is not just “better prompts”.

The outcome is a repeatable loop:

```text
Task -> Context selection -> AI reasoning -> Controlled execution -> Verification -> Durable notes -> Commit-ready state
```

## Failure modes this playbook tries to reduce

- massive irrelevant context
- contradictory prompts across tools
- hidden assumptions
- chat-only decisions that never reach the repo
- AI-generated changes with no review boundary
- brittle workflows tied to one single vendor

## Success criteria

A healthy workflow should make it easier to:

- start a session quickly
- recover from interruptions
- ask better questions
- compare tools without rebuilding everything
- move from idea to verified change with less friction
