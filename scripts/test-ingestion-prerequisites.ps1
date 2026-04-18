<#
.SYNOPSIS
Validates the prerequisites for the document ingestion pipeline.

.DESCRIPTION
This script checks that the tooling and directories required by the chunking
pipeline are available before any expensive work begins.

The checks are intentionally lightweight and explicit so they can be audited easily.

.PARAMETER InputDir
Directory that contains the extracted or normalized markdown input.

.PARAMETER StagingDir
Directory that will receive the pre-chunked output before ctxvault indexing.

.NOTES
Example:
  pwsh ./scripts/test-ingestion-prerequisites.ps1 -InputDir ./documents-to-ingest/normalized -StagingDir ./documents-to-ingest/staging
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$InputDir,
  [Parameter(Mandatory = $true)][string]$StagingDir
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$checks = @(
  @{ Name = 'python'; Command = 'python' },
  @{ Name = 'ctxvault'; Command = 'ctxvault' }
)

Write-Host "Checking ingestion prerequisites..." -ForegroundColor Cyan

foreach ($check in $checks) {
  $cmd = Get-Command $check.Command -ErrorAction SilentlyContinue
  if (-not $cmd) {
    throw "Required tool not found in PATH: $($check.Command)"
  }

  Write-Host "[OK] tool: $($check.Name) -> $($cmd.Source)" -ForegroundColor Green
}

if (-not (Test-Path $InputDir)) {
  throw "Input directory not found: $InputDir"
}

$null = New-Item -ItemType Directory -Force -Path $StagingDir
Write-Host "[OK] input dir:  $InputDir" -ForegroundColor Green
Write-Host "[OK] staging dir: $StagingDir" -ForegroundColor Green
