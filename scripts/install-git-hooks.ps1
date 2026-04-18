<#
.SYNOPSIS
Installs the repository Git hooks by setting core.hooksPath.

.DESCRIPTION
This repository ships its hooks inside .githooks/.
Git will not use them automatically unless core.hooksPath is set.

This script configures the current repository to use:
  .githooks/

The hook automation is intentionally small and non-destructive.
It refreshes ai-input metadata after common Git events.

.NOTES
Run from the repository root:
  pwsh ./scripts/install-git-hooks.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# Resolve the repository root as the parent of the scripts directory.
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

Push-Location $repoRoot
try {
  # This is the key step: tell Git to use the versioned hook directory.
  git config core.hooksPath .githooks
  Write-Host "Git hooks installed. core.hooksPath = .githooks" -ForegroundColor Green
}
finally {
  Pop-Location
}
