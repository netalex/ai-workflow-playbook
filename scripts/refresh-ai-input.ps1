<#
.SYNOPSIS
Refreshes the ai-input staging area used by the workflow.

.DESCRIPTION
This script creates or updates a minimal set of LLM-facing artifacts:

- ai-input/00-manifest/workspace-snapshot.json
- ai-input/00-manifest/changed-files.txt

If a matching repomix config exists, it can also generate a last-commit bundle.

The goal is to keep the staged context small, explicit, and easy to review.

.PARAMETER RepoRoot
Optional repository root. Defaults to the parent of the scripts directory.

.PARAMETER GenerateLastCommitBundle
If set, the script also generates a small repomix bundle for the files changed in HEAD.

.NOTES
Run from the repository root:
  pwsh ./scripts/refresh-ai-input.ps1
#>

[CmdletBinding()]
param(
  [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
  [switch]$GenerateLastCommitBundle
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$AiInput = Join-Path $RepoRoot 'ai-input'
$ManifestDir = Join-Path $AiInput '00-manifest'
$CodeDir = Join-Path $AiInput '20-code'
$null = New-Item -ItemType Directory -Force -Path $ManifestDir, $CodeDir

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Content
  )

  $parent = Split-Path -Parent $Path
  if ($parent) {
    $null = New-Item -ItemType Directory -Force -Path $parent
  }

  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

function Get-GitLines {
  param(
    [Parameter(Mandatory = $true)][string[]]$Args
  )

  Push-Location $RepoRoot
  try {
    $raw = & git @Args 2>$null
    if ($LASTEXITCODE -ne 0) {
      return @()
    }

    return @($raw | Where-Object { $_ -and $_.Trim() -ne '' } | ForEach-Object { $_.TrimEnd() })
  }
  finally {
    Pop-Location
  }
}

function Get-RepoState {
  # Build a small, durable snapshot that can be reused by humans or tools.
  $branch = (Get-GitLines -Args @('rev-parse', '--abbrev-ref', 'HEAD') | Select-Object -First 1)
  if (-not $branch) { $branch = 'unknown' }

  $head = (Get-GitLines -Args @('rev-parse', 'HEAD') | Select-Object -First 1)
  if (-not $head) { $head = 'unknown' }

  [ordered]@{
    generated_at_utc = (Get-Date).ToUniversalTime().ToString('s') + 'Z'
    repo_root = $RepoRoot
    git_branch = $branch
    git_head = $head
    working_tree_status = Get-GitLines -Args @('status', '--short')
    last_commit_changed_files = Get-GitLines -Args @('diff-tree', '--root', '--no-commit-id', '--name-only', '-r', 'HEAD')
    ai_input_role = 'Prepared and reviewable LLM-facing input surface.'
  }
}

$state = Get-RepoState

# Write a text file that is convenient to open in any editor.
$changedFilesPath = Join-Path $ManifestDir 'changed-files.txt'
if (@($state.last_commit_changed_files).Count -gt 0) {
  Write-Utf8NoBom -Path $changedFilesPath -Content ((@($state.last_commit_changed_files) -join "`r`n") + "`r`n")
}
else {
  Write-Utf8NoBom -Path $changedFilesPath -Content "No files detected in the last commit.`r`n"
}

# Write the JSON snapshot for machine-readable inspection.
$stateJson = $state | ConvertTo-Json -Depth 8
Write-Utf8NoBom -Path (Join-Path $ManifestDir 'workspace-snapshot.json') -Content $stateJson

if ($GenerateLastCommitBundle) {
  $repomix = Get-Command repomix -ErrorAction SilentlyContinue
  $eligible = @($state.last_commit_changed_files | Where-Object {
    $_ -notlike 'docs/*' -and
    $_ -notlike 'ai-input/*' -and
    $_ -notlike 'ai-output/*' -and
    $_ -notlike '.ctxvault/*'
  })

  if (-not $repomix) {
    Write-Host "[skip] repomix not found in PATH." -ForegroundColor DarkYellow
  }
  elseif ($eligible.Count -eq 0) {
    Write-Host "[skip] No eligible non-doc files in the last commit." -ForegroundColor DarkYellow
  }
  else {
    $tmpConfig = Join-Path $env:TEMP "repomix-last-commit-$([System.IO.Path]::GetRandomFileName()).json"
    $bundlePath = Join-Path $CodeDir 'last-commit-bundle.md'

    $config = [ordered]@{
      '$schema' = 'https://repomix.com/schemas/latest/schema.json'
      output = [ordered]@{
        filePath = ($bundlePath -replace '\\', '/')
        style = 'markdown'
        directoryStructure = $true
        files = $true
      }
      include = $eligible
      ignore = [ordered]@{
        useGitignore = $true
        useDefaultPatterns = $true
        customPatterns = @('node_modules/**', 'dist/**', 'coverage/**')
      }
    }

    try {
      $config | ConvertTo-Json -Depth 10 | Set-Content $tmpConfig -Encoding UTF8
      Push-Location $RepoRoot
      try {
        & $repomix.Source -c $tmpConfig
      }
      finally {
        Pop-Location
      }
    }
    finally {
      Remove-Item $tmpConfig -Force -ErrorAction SilentlyContinue
    }
  }
}

Write-Host "ai-input refreshed." -ForegroundColor Green
