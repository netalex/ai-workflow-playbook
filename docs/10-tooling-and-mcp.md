# Tooling and MCP usage

## Why this document exists

“Uses AI tools” is too vague to be useful.

This page defines the role of each major tool and MCP class so the workflow remains understandable and replaceable.

## VS Code

Use VS Code as the execution base.

### Use it for

- editing code and docs
- local terminal work
- diff review
- Git history and branch work
- running tests
- opening generated repomix bundles
- inspecting staged chunk files

### Do not use it as

- the only place where durable knowledge lives

## Claude Desktop

Use Claude Desktop as the main reasoning workspace.

### Use it for

- planning
- architecture
- multi-source synthesis
- doc consolidation
- generating repomix selection ideas
- proposing chunking or ingestion rules
- drafting skills and operating notes

### Do not use it as

- the sole durable memory layer

## Cline

Use Cline for bounded implementation.

### Use it for

- file edits
- local execution
- refactors inside explicit boundaries
- tool-driven work through MCP
- applying repo rules under supervision

### Guardrails

- do not give it unconstrained repo access by default
- give it `ai-input/` or a narrow workspace slice first
- prefer reviewable steps

## GitHub Copilot

Use Copilot for the lightest-weight assistance.

### Use it for

- inline completion
- quick transformations
- local chat for narrow questions
- generating small code fragments

### Do not use it for

- project-wide reasoning
- being the system of record for project decisions

## CtxVault

Use CtxVault for durable local memory.

### Use it for

- running knowledge
- historical knowledge
- project notes
- snapshots
- taskboards
- reusable skills

### Rules

- index only pre-chunked material
- do not dump raw source documents into a vault
- keep vault purpose explicit
- separate changing knowledge from immutable reference

## Repomix

Use Repomix to package repository context.

### Use it for

- issue-focused bundles
- last-commit bundles
- structure-only passes
- content-only passes
- mixed composite bundles

### Rules

- configure include patterns deliberately
- exclude docs, caches, and irrelevant assets when possible
- store outputs under `ai-input/` or a dedicated output directory
- annotate the bundle purpose in the file name or config

## filesystem MCP

Use filesystem MCP sparingly.

### Prefer this order

1. expose `ai-input/`
2. expose `ai-output/`
3. expose a narrow project subdirectory when edits are truly needed
4. expose the whole repository only as an exception

### Why

- better security
- lower accidental disclosure
- lower token cost
- easier review

## repomix MCP

Use repomix MCP when the assistant should help generate bundles without manual CLI work.

### Use it for

- packaging a repository slice
- generating a context file for a remote assistant
- exploring inclusion and exclusion strategies

## markitdown MCP, Docling, and Pandoc

Use extraction tools to turn source documents into markdown before chunking.

### Good default order

1. prefer a stable markdown converter for the document type
2. normalize the output
3. chunk the markdown
4. index the chunked corpus

## Playwright MCP

Use Playwright MCP for browser-driven validation or reproducible UI exploration.

Examples:
- generating application screenshot lively updated during development

### Do not use it for

- tasks that can be answered from code or docs alone

## DebugMCP or debugger integrations

Use them for local validation and debugging flows that benefit from a runtime view.

## Framework-specific MCP servers

Use them when a framework has important project conventions that the LLM should not improvise.

Examples include framework CLI tools, schema-aware tooling, or official migration helpers.

## Rule of thumb

If a tool adds uncontrolled context, it is probably being used too broadly.
