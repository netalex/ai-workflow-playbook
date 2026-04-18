<#
.SYNOPSIS
Runs the document ingestion pipeline end to end.

.DESCRIPTION
This script coordinates the main stages required to convert markdown-ready
documents into a pre-chunked corpus suitable for CtxVault.

The pipeline intentionally stops before and after clear review points.

Stages:
1. prerequisite checks
2. build raw chunks
3. refine chunks
4. build indexes
5. sync the refined corpus to staging
6. optionally trigger ctxvault indexing

.PARAMETER InputDir
Directory containing normalized markdown source files.

.PARAMETER WorkDir
Directory where chunks, refined chunks, and indexes will be written.

.PARAMETER StagingDir
Directory that will receive the final reviewed pre-chunked corpus.

.PARAMETER IndexVaultPath
Optional filesystem path to the target ctxvault staging or vault-facing directory.

.PARAMETER RunCtxVaultIndex
If set, the script will call `ctxvault index` on the destination after staging.

.NOTES
Example:
  pwsh ./scripts/run-ingestion-pipeline.ps1 `
    -InputDir ./documents-to-ingest/normalized `
    -WorkDir ./documents-to-ingest/work `
    -StagingDir ./documents-to-ingest/staging
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$InputDir,
  [Parameter(Mandatory = $true)][string]$WorkDir,
  [Parameter(Mandatory = $true)][string]$StagingDir,
  [string]$IndexVaultPath,
  [switch]$RunCtxVaultIndex
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$chunksDir = Join-Path $WorkDir 'chunks'
$refinedDir = Join-Path $WorkDir 'chunks-refined'
$indexesDir = Join-Path $WorkDir 'indexes'
$manifestPath = Join-Path $WorkDir 'chunk-manifest.csv'

Write-Host "Running ingestion pipeline..." -ForegroundColor Cyan
Write-Host "Input:   $InputDir"
Write-Host "Work:    $WorkDir"
Write-Host "Staging: $StagingDir"

# Step 1: fail fast if the environment is not ready.
& (Join-Path $PSScriptRoot 'test-ingestion-prerequisites.ps1') `
  -InputDir $InputDir `
  -StagingDir $StagingDir

# Create the work directories up front so the output layout is stable.
$null = New-Item -ItemType Directory -Force -Path $chunksDir, $refinedDir, $indexesDir

# Step 2: chunk the normalized markdown corpus.
& python (Join-Path $PSScriptRoot 'build-kb-chunks.py') `
  --input-dir $InputDir `
  --output-dir $chunksDir `
  --manifest-path $manifestPath

# Step 3: refine and normalize the raw chunks.
& python (Join-Path $PSScriptRoot 'refine-kb-chunks.py') `
  --input-dir $chunksDir `
  --output-dir $refinedDir

# Step 4: build indexes and summaries for human QA.
& python (Join-Path $PSScriptRoot 'build-chunk-index.py') `
  --input-dir $refinedDir `
  --output-dir $indexesDir

# Step 5: copy only the refined, pre-chunked material to the staging area.
& (Join-Path $PSScriptRoot 'sync-staging-to-ctxvault.ps1') `
  -SourceDir $refinedDir `
  -StagingDir $StagingDir `
  -IndexVaultPath $IndexVaultPath `
  -RunCtxVaultIndex:$RunCtxVaultIndex

Write-Host "Ingestion pipeline completed." -ForegroundColor Green
