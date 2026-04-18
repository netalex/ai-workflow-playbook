# Linux or WSL setup

This guide covers Linux and WSL environments. The workflow stays the same: VS Code remains the base, even when execution happens inside WSL.

## Baseline tools

Install and verify:

- Git
- Node.js and npm
- Python 3
- `uv`
- PowerShell Core (`pwsh`) if you want script parity
- VS Code
- Claude Desktop on the host OS, when applicable
- Repomix
- CtxVault via `uv tool`

## Official-document extras

If you plan to process complex local document sets, add:

- Pandoc
- Docling
- ImageMagick or another local image conversion tool
- Mammoth through `npm` or `npx` when you need semantic DOCX QA
- LibreOffice Writer or another local visual office suite for QA only

## Verify the toolchain

```bash
git --version
node --version
npm --version
python3 --version
uv --version
code --version
pwsh --version
pandoc --version
docling --help
```

## Install Repomix

```bash
npm install -g repomix
repomix --version
```

## Install CtxVault with `uv tool`

```bash
uv tool install ctxvault
uv tool install ctxvault-mcp
ctxvault --help
ctxvault-mcp --help
```

## Recommended directory pattern

```text
~/work/
  repos/
  ai-input/
  ai-output/
  repomix-output/
  vault-staging/
  documents-to-ingest/
  document-workbenches/
```

## VS Code and WSL

If you use WSL:

- keep the repository inside the Linux filesystem when possible
- open it through VS Code Remote - WSL
- run Python, Git, repomix, and `ctxvault` inside WSL
- keep Claude Desktop on the host side if required by your setup
- make sure any filesystem MCP paths point to the correct WSL-visible directories

## Claude Desktop and config handoff

Claude Desktop runs on the host, but the repository or staged folders may live inside WSL.

In that case, decide one of these patterns:

1. expose a Windows-accessible mirror of `ai-input/`
2. run packaging inside WSL and copy the output into a host-visible `ai-input/`
3. keep only the bundle output host-visible and keep the rest private in WSL

The third option is usually the safest.

## Safe filesystem MCP pattern

Expose only what is needed:

- `ai-input/`
- `ai-output/`
- a carefully chosen subdirectory if file-level edits are required

Avoid giving the host tool a blind view of the entire Linux workspace.

The same logic applies to document workbenches: keep the raw workbench local and expose only reviewed exports.

## Git hooks

If the repository is Linux-native, the bundled shell hooks in `.githooks/` work directly.

Install them with:

```bash
pwsh ./scripts/install-git-hooks.ps1
```

or manually:

```bash
git config core.hooksPath .githooks
```

## Common Linux or WSL pitfalls

- Windows and Linux paths mixed inside config files
- missing execute bit on hook files
- using `python` vs `python3`
- different `repomix` or `ctxvault` locations between host and WSL
- storing large bundles on synced folders with slow I/O
- forgetting that a raw official source drop may deserve a workbench before it belongs in the main repo

## Good default

Use Linux or WSL for the heavy local tooling, but keep the LLM-facing surface small and explicit.
