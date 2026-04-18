# Stack

## Reference stack

### Reasoning

- Claude Desktop

### In-editor execution

- VS Code
- Cline
- GitHub Copilot

### Durable memory

- CtxVault

### Context packaging

- Repomix

### Optional tool adapters

- filesystem MCP
- markitdown MCP
- DebugMCP
- Playwright MCP
- GitHub integrations
- framework-specific MCP servers (i.e. Angulr-cli MCP for angular best practices retreival and application and code conformity)

## Why this split works

Each tool is used for what it does best.

### Claude Desktop

Best for:

- long-form reasoning
- architecture
- synthesis across sources
- prompt-heavy work
- turning scattered notes into coherent documents

### Cline

Best for:

- bounded implementation inside the repo
- surgical edits
- terminal-aware iteration
- local validation loops

### GitHub Copilot

Best for:

- fast inline completions
- lightweight chat in the editor
- quick transformations
- low-friction coding support

### CtxVault

Best for:

- persistent project memory
- operational notes
- snapshots
- reusable context outside chat silos

### Repomix

Best for:

- targeted context extraction
- building compact inputs for AI tools
- avoiding raw repository overload

## Tool ownership model

Use this default assignment:

| Need                      | Primary owner  | Secondary       |
| ------------------------- | -------------- | --------------- |
| architectural reasoning   | Claude Desktop | none            |
| code execution in repo    | Cline          | Copilot         |
| quick local coding help   | Copilot        | Cline           |
| long-lived project memory | CtxVault       | repository docs |
| focused packaging         | Repomix        | manual bundles  |

## Anti-patterns

Avoid these:

- using one tool for every task
- asking the editor agent to infer the whole project from scratch
- storing durable project knowledge only in chat
- mixing strategic reasoning and large destructive edits in one step
- treating AI output as authoritative without review

## Substitution rule

The workflow should survive tool changes.

If you replace one tool, preserve the **role**, not the brand.

Example:

- replace Claude Desktop -> keep a reasoning layer
- replace Cline -> keep an execution layer
- replace CtxVault -> keep durable memory
- replace Repomix -> keep focused context packaging
