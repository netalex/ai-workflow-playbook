# Stack

## Reference stack

### Base

- VS Code

### Reasoning

- Claude Desktop

### In-editor execution

- Cline
- GitHub Copilot

### Durable memory

- CtxVault

### Context packaging

- Repomix

### Optional extraction and conversion tools

- Docling
- MarkItDown
- Pandoc

### Optional MCP servers

- filesystem MCP
- repomix MCP
- markitdown MCP
- Playwright MCP
- DebugMCP
- framework-specific MCP servers
- GitHub or Git provider integrations

## Why this split works

Each tool is used for what it does best.

### VS Code

Best for:

- editing and review
- Git operations
- running tests
- terminal work
- managing local automation
- acting as the common base between multiple AI assistants

### Claude Desktop

Best for:

- cross-file reasoning
- architecture
- prompt-heavy synthesis
- drafting durable docs
- turning mixed notes into coherent operating guidance

### Cline

Best for:

- bounded implementation
- file edits with local feedback
- terminal-aware work
- task execution inside a controlled workspace
- workflows that benefit from MCP tools

### GitHub Copilot

Best for:

- inline completion
- lightweight chat
- small transformations
- local code assistance with minimal overhead

### CtxVault

Best for:

- persistent knowledge
- project snapshots
- taskboards
- open questions
- historical reference material
- custom skills that should survive chat resets

### Repomix

Best for:

- packaging only the needed repository slice
- producing repeatable context bundles
- separating structure-only context from full file content
- reducing token usage compared with raw repository exposure

## Default ownership model

| Need                    | Primary owner    | Secondary       |
| ----------------------- | ---------------- | --------------- |
| architectural reasoning | Claude Desktop   | repository docs |
| in-repo execution       | Cline            | Copilot         |
| quick local coding help | Copilot          | Cline           |
| durable memory          | CtxVault         | repository docs |
| focused packaging       | Repomix          | manual bundles  |
| local validation        | VS Code terminal | shell scripts   |

## Anti-patterns

Avoid these:

- using one assistant for everything
- indexing raw documents directly into a vault
- giving filesystem MCP unrestricted repository access by default
- asking the code assistant to infer business context from scratch
- leaving repeated prompts undocumented
- storing changing project state only in chat
- using expensive repomix bundles when a small vault subset would do
- do not git versioning vaults (if they corrupts, there's no way to recover original chunks from ctxvault)

## Substitution rule

The workflow should survive tool changes.

Keep the **role**, not the brand.

Examples:

- replace Claude Desktop with another reasoning layer with MCP client
- replace Cline with another editor execution layer
- replace CtxVault with another durable local memory system
- replace Repomix with another packaging layer that can preserve the same discipline
