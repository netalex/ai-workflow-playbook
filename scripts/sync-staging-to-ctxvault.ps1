<#
.SYNOPSIS
Copies a refined chunk corpus to staging and optionally runs ctxvault indexing.

.DESCRIPTION
This script exists to keep one rule explicit:
only the reviewed, pre-chunked corpus should be staged for vault indexing.

The source directory is expected to contain chunk files that are already in
their final retrieval shape.

.PARAMETER SourceDir
Directory containing the refined chunk corpus.

.PARAMETER StagingDir
Directory where the reviewed pre-chunked corpus will be copied.

.PARAMETER IndexVaultPath
Optional destination path or vault-facing path for ctxvault indexing.

.PARAMETER RunCtxVaultIndex
If set, runs `ctxvault index` after staging.

.NOTES
Example:
  pwsh ./scripts/sync-staging-to-ctxvault.ps1 -SourceDir ./work/chunks-refined -StagingDir ./staging -RunCtxVaultIndex
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$SourceDir,
  [Parameter(Mandatory = $true)][string]$StagingDir,
  [string]$IndexVaultPath,
  [switch]$RunCtxVaultIndex
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path $SourceDir)) {
  throw "Source directory not found: $SourceDir"
}

# Reset the staging area so it always reflects the current reviewed corpus.
if (Test-Path $StagingDir) {
  Remove-Item -Path $StagingDir -Recurse -Force
}

$null = New-Item -ItemType Directory -Force -Path $StagingDir
Copy-Item -Path (Join-Path $SourceDir '*') -Destination $StagingDir -Recurse -Force

Write-Host "Staging refreshed from refined chunk corpus." -ForegroundColor Green

if ($RunCtxVaultIndex) {
  $ctxvault = Get-Command ctxvault -ErrorAction SilentlyContinue
  if (-not $ctxvault) {
    throw "ctxvault not found in PATH."
  }

  $target = if ($IndexVaultPath) { $IndexVaultPath } else { $StagingDir }

  # This command is intentionally simple. Adjust to your ctxvault layout.
  # The main purpose here is to make the operational step explicit.
  & $ctxvault.Source index $target
  if ($LASTEXITCODE -ne 0) {
    throw "ctxvault index failed for: $target"
  }

  Write-Host "ctxvault index completed for: $target" -ForegroundColor Green
}
