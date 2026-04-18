# Windows setup

This guide assumes a Windows-first environment with PowerShell or PowerShell Core, Git, Python, Node.js, and VS Code.

## Baseline tools

Install and verify:

- Git
- Node.js and npm
- Python
- `uv`
- VS Code
- Claude Desktop
- Cline and/or GitHub Copilot
- Repomix
- CtxVault via `uv tool`

## Install commands

### Core tools

Use the package manager you prefer. A typical Windows setup may look like this:

```powershell
git --version
node --version
npm --version
python --version
uv --version
code --version
```

### Install Repomix

```powershell
npm install -g repomix
repomix --version
```

### Install CtxVault via `uv tool`

```powershell
uv tool install ctxvault
uv tool install ctxvault-mcp
ctxvault --help
ctxvault-mcp --help
```

This playbook assumes `ctxvault` and `ctxvault-mcp` are installed this way.

## Recommended directory pattern

Use a stable layout such as:

```text
C:\Users\<you>\Work\
  ├── repos\
  ├── ai-input\
  ├── ai-output\
  ├── repomix-output\
  ├── vault-staging\
  └── documents-to-ingest\
```

Consistency matters more than exact names.

## Recommended local conventions

### Keep these separate

- `repos/` for real repositories
- `ai-input/` for LLM-safe staged inputs
- `ai-output/` for transient drafts
- `repomix-output/` for generated bundles
- `vault-staging/` for pre-chunked files waiting to be indexed
- `documents-to-ingest/` for raw source documents

### Treat VS Code as the base

Use VS Code for:

- terminal commands
- Git review
- diff inspection
- extension-based AI execution
- opening generated bundles and staged markdown
- validating what the AI actually changed

### Keep prompts versioned

If a prompt affects repeated work, store it in:

- the repository
- a running-knowledge vault
- a skill vault

Do not leave critical instructions trapped in GUI settings only.

## Claude Desktop configuration

The example file in [config/claude/claude_desktop_config.example.json](../config/claude/claude_desktop_config.example.json) illustrates three important patterns:

1. **filesystem MCP restricted to `ai-input/` and `ai-output` first**
2. **project-specific MCP servers declared explicitly**
3. **CtxVault exposed through its own MCP command**

Do not expose the whole repository unless the task actually requires it.

## Safe filesystem MCP pattern

A good default is to allow only:

- `ai-input/`
- `ai-output/`
- a narrow working subdirectory when necessary

That protects the rest of the repo from casual reading and keeps prompts smaller.

## First local checks

Run:

```powershell
pwsh ./scripts/check-tools.ps1
pwsh ./scripts/pre-publish-checklist.ps1
```

## Git hooks

Install the bundled hooks:

```powershell
pwsh ./scripts/install-git-hooks.ps1
```

This sets:

```powershell
git config core.hooksPath .githooks
```

The hooks are documented in [docs/12-repomix-automation.md](12-repomix-automation.md).

## What to configure first

1. VS Code
2. Git
3. Python and Node.js
4. Repomix
5. CtxVault
6. Claude Desktop
7. editor assistants
8. optional MCP servers

## Security notes

Before using public or cloud-hosted AI:

- remove secrets from bundles
- avoid copying `.env` files
- do not index confidential raw documents directly
- keep filesystem MCP scoped tightly
- prefer pre-chunked markdown over arbitrary full files
