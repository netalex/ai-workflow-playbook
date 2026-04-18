# `ai-input/`

This directory is a safe staging area for LLM-facing inputs.

## Why it exists

A practical security and cost pattern is to expose `ai-input/` to filesystem MCP instead of the whole repository.

That helps with:

- limiting what the LLM can read directly
- reducing accidental disclosure
- lowering token usage
- making the current context explicit and reviewable

## Good contents

- current repomix bundle
- last-commit bundle
- workspace snapshot
- selected markdown notes
- small ad-hoc context files

## Bad contents

- secrets
- raw `.env` files
- giant unfiltered repository exports
- raw source documents that should have been chunked first
