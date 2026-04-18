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

- Pandoc
- Docling
- Mammoth
- MarkItDown
- ImageMagick or another local image conversion tool
- LibreOffice Writer for visual QA only

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

### Pandoc

Best for:

- canonical markdown export from office-style documents
- deterministic local conversion
- media extraction
- producing a human-readable master markdown file

### Docling

Best for:

- structured document conversion
- JSON output that preserves document semantics better than plain markdown alone
- feeding a chunking step that cares about document structure, not only text length

### Mammoth

Best for:

- semantic QA of DOCX files
- identifying whether headings and lists are real Word structures or just visual formatting
- producing a secondary view that helps detect conversion risks before chunking

## Default ownership model

| Need                         | Primary owner    | Secondary       |
| ---------------------------- | ---------------- | --------------- |
| architectural reasoning      | Claude Desktop   | repository docs |
| in-repo execution            | Cline            | Copilot         |
| quick local coding help      | Copilot          | Cline           |
| durable memory               | CtxVault         | repository docs |
| focused packaging            | Repomix          | manual bundles  |
| local validation             | VS Code terminal | shell scripts   |
| official document extraction | Pandoc           | Docling         |
| DOCX semantic QA             | Mammoth          | manual review   |

## Anti-patterns

Avoid these:

- using one assistant for everything
- indexing raw documents directly into a vault
- giving filesystem MCP unrestricted repository access by default
- asking the code assistant to infer business context from scratch
- leaving repeated prompts undocumented
- storing changing project state only in chat
- using expensive repomix bundles when a small vault subset would do
- treating a DOCX converter as the canonical source of truth without preflight QA
- mixing raw official sources, extracted work products, and final project docs in one undifferentiated folder
- treating screenshots as decorative media when they carry UI or workflow knowledge
- treating live vault internals as the canonical store instead of versioning the source chunks, manifests, and skills

## Substitution rule

The workflow should survive tool changes.

Keep the **role**, not the brand.

Examples:

- replace Claude Desktop with another reasoning layer with MCP client capabilities, long-context synthesis, and reusable workspace or project instructions
  - possible examples: 5ire, Dive, or CodePilot
- replace Cline with another editor execution layer that can edit files, run terminal commands, and respect repository boundaries
  - possible examples: Continue or Kilo Code
- replace CtxVault with another durable local memory system that supports pre-chunked knowledge, search, and explicit separation between running and historical material
  - closest examples: Basic Memory, vault-mcp, or OpenMemory
  - note: these are not exact drop-in replacements; you may need to recreate the pre-chunk discipline and the running-vs-historical split with your own conventions
- replace Repomix with another packaging layer that can emit narrow, reviewable bundles instead of exposing the whole repository
  - possible examples: GitIngest, Code2Prompt, or llmctx
- replace Pandoc or Docling with another local extraction layer only if it still supports deterministic offline conversion, asset extraction, and a reviewable intermediate representation
- replace Mammoth with another semantic DOCX QA tool only if it still helps you distinguish real document structure from styling noise before chunking
