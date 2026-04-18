# Windows setup

This guide assumes a Windows-first development environment with PowerShell and VS Code.

## Baseline tools

Install and verify:

- Git
- Node.js and npm
- Python
- VS Code
- Claude Desktop
- Cline or GitHub Copilot
- CtxVault
- Repomix

## Recommended directory pattern

Use a stable structure such as:

```text
C:\Users\<you>\Documents\Work\
  ├── repos\
  ├── prompts\
  ├── ai-output\
  ├── repomix-bundles\
  └── ctxvault\
```

The exact names do not matter. The consistency does.

## Suggested local conventions

### 1. Separate durable knowledge from transient output
Keep these distinct:

- `repos/` -> real repositories
- `ai-output/` -> generated drafts, scratch files, exports
- `repomix-bundles/` -> compact context packages
- `ctxvault/` -> long-lived knowledge artifacts

### 2. Keep prompts versioned
Do not leave important prompts trapped inside app settings.

Store them in a repository or vault.

### 3. Standardize naming
Examples:

- `project-status-snapshot-YYYY-MM-DD.md`
- `taskboard-YYYY-MM-DD.md`
- `open-questions-YYYY-MM-DD.md`
- `repo-slice-<area>-YYYY-MM-DD.txt`

## Minimum setup checks

Run these in PowerShell:

```powershell
git --version
node --version
npm --version
python --version
code --version
```

Then confirm your AI-specific tools through their own commands or UI.

## What to configure first

1. editor
2. source control
3. reasoning tool
4. durable memory
5. packaging pipeline
6. only then optional integrations

## Security notes

Before using public or cloud-hosted AI:

- remove secrets from bundles
- avoid copying `.env` files into prompts
- strip private URLs when publishing examples
- treat prompts as potentially sensitive operational assets
