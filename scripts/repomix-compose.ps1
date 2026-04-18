<#
.SYNOPSIS
Generates a configurable composite repomix bundle from an issue-style JSON config.

.DESCRIPTION
This script implements a practical pattern for token-aware repository packaging.

It supports a composite approach:
1. generate a structure-only pass for a broad root
2. generate a content pass for a targeted include list
3. merge both outputs into a single Markdown bundle

The expected config path is:
  config/repomix/issues/repomix-config.<slug>.json

Use this when the AI suggests the right active modules, files, and exclusions
for the current task, and you want that packaging encoded as a reusable config.

.PARAMETER Slug
Logical name of the issue bundle. Example:
  -Slug search-form

.PARAMETER RepoRoot
Optional repository root. Defaults to the parent of the scripts directory.

.PARAMETER WithTimestamp
If set, appends a timestamp to the output file name.

.PARAMETER List
Lists available repomix config slugs and exits.

.NOTES
Examples:
  pwsh ./scripts/repomix-compose.ps1 -Slug example
  pwsh ./scripts/repomix-compose.ps1 -Slug example -WithTimestamp
#>

[CmdletBinding()]
param(
  [string]$Slug,
  [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path,
  [switch]$WithTimestamp,
  [switch]$List
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$IssuesDir = Join-Path $RepoRoot 'config/repomix/issues'

function Get-RelativePath {
  param([string]$Path)
  $root = [System.IO.Path]::GetFullPath($RepoRoot).TrimEnd('\') + '\'
  $abs = [System.IO.Path]::GetFullPath($Path)
  if ($abs.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
    return ($abs.Substring($root.Length).TrimStart('\') -replace '\\', '/')
  }
  return $abs
}

function New-TempRepomixConfig {
  param(
    [string]$OutputPath,
    [array]$IncludePatterns,
    [bool]$IncludeFiles,
    [bool]$IncludeDirectoryStructure,
    [array]$ExtraIgnorePatterns = @()
  )

  # These defaults intentionally exclude common expensive or irrelevant paths.
  [array]$defaultIgnore = @(
    'ai-input/**',
    'ai-output/**',
    '.ctxvault/**',
    'node_modules/**',
    'dist/**',
    'coverage/**'
  )

  $merged = [System.Collections.Generic.List[string]]::new()
  if ($defaultIgnore.Count -gt 0) { $merged.AddRange([string[]]$defaultIgnore) }

  foreach ($pattern in $ExtraIgnorePatterns) {
    if (-not $merged.Contains($pattern)) {
      $merged.Add($pattern)
    }
  }

  $cfg = [ordered]@{
    '$schema' = 'https://repomix.com/schemas/latest/schema.json'
    output = [ordered]@{
      filePath = ($OutputPath -replace '\\', '/')
      style = 'markdown'
      fileSummary = $false
      directoryStructure = $IncludeDirectoryStructure
      files = $IncludeFiles
      removeComments = $false
      removeEmptyLines = $false
    }
    include = $IncludePatterns
    ignore = [ordered]@{
      useGitignore = $true
      useDefaultPatterns = $true
      customPatterns = $merged.ToArray()
    }
  }

  $tmpPath = Join-Path $env:TEMP "repomix-tmp-$([System.IO.Path]::GetRandomFileName()).json"
  $cfg | ConvertTo-Json -Depth 10 | Set-Content $tmpPath -Encoding UTF8
  return $tmpPath
}

function Invoke-RepomixWithConfig {
  param(
    [string]$ConfigPath,
    [string]$Label
  )

  $repomix = Get-Command repomix -ErrorAction SilentlyContinue
  if (-not $repomix) {
    throw "repomix was not found in PATH. Install with: npm install -g repomix"
  }

  Write-Host "[$Label] running repomix..." -ForegroundColor DarkGray
  & $repomix.Source -c $ConfigPath
  if ($LASTEXITCODE -ne 0) {
    throw "Repomix failed for label: $Label"
  }
}

if ($List) {
  if (-not (Test-Path $IssuesDir)) {
    Write-Warning "Issues config directory not found: $IssuesDir"
    exit 0
  }

  $configs = Get-ChildItem -Path $IssuesDir -Filter 'repomix-config.*.json' | Sort-Object Name
  if ($configs.Count -eq 0) {
    Write-Host "No issue configs found." -ForegroundColor Yellow
  }
  else {
    Write-Host "Available issue slugs:" -ForegroundColor Cyan
    foreach ($file in $configs) {
      $slugName = $file.BaseName -replace '^repomix-config\.', ''
      Write-Host "- $slugName"
    }
  }
  exit 0
}

if (-not $Slug) {
  throw "Missing -Slug. Example: pwsh ./scripts/repomix-compose.ps1 -Slug example"
}

$ConfigPath = Join-Path $IssuesDir "repomix-config.$Slug.json"
if (-not (Test-Path $ConfigPath)) {
  throw "Repomix issue config not found: $ConfigPath"
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json

if (-not $config.output -or -not $config.output.filePath) {
  throw "Missing output.filePath in config: $ConfigPath"
}

$outputPath = Join-Path $RepoRoot $config.output.filePath
if ($WithTimestamp) {
  $ts = Get-Date -Format 'yyyyMMdd-HHmm'
  $dir = [System.IO.Path]::GetDirectoryName($outputPath)
  $base = [System.IO.Path]::GetFileNameWithoutExtension($outputPath)
  $ext = [System.IO.Path]::GetExtension($outputPath)
  $outputPath = Join-Path $dir "$base-$ts$ext"
}

$null = New-Item -ItemType Directory -Force -Path (Split-Path -Parent $outputPath)

$contextText = if ($config.context) { [string]$config.context } else { '(no context text set)' }
$structureRoot = if ($config.structureRoot) { [string]$config.structureRoot } else { $null }
[array]$include = if ($config.include) { @($config.include) } else { @() }
[array]$listedOnly = if ($config.listedOnly) { @($config.listedOnly) } else { @() }
[array]$extraIgnore = @()
if ($config.ignore -and $config.ignore.customPatterns) {
  $extraIgnore = @($config.ignore.customPatterns)
}

Write-Host ""
Write-Host "[repomix] slug:    $Slug" -ForegroundColor Cyan
Write-Host "[context] $contextText" -ForegroundColor Cyan
Write-Host "[config]  $(Get-RelativePath $ConfigPath)" -ForegroundColor DarkGray
Write-Host "[output]  $(Get-RelativePath $outputPath)" -ForegroundColor DarkGray

$tmpFiles = [System.Collections.Generic.List[string]]::new()

try {
  if ($structureRoot) {
    # Composite mode:
    # - pass 1 = structure only for the broad area
    # - pass 2 = full content only for the selected files or modules
    # This keeps the bundle informative without paying full token cost everywhere.
    $stamp = [System.IO.Path]::GetRandomFileName()
    $tmpStructure = Join-Path $env:TEMP "repomix-structure-$stamp.md"
    $tmpContent = Join-Path $env:TEMP "repomix-content-$stamp.md"
    $tmpFiles.Add($tmpStructure)
    $tmpFiles.Add($tmpContent)

    $cfg1 = New-TempRepomixConfig `
      -OutputPath $tmpStructure `
      -IncludePatterns @("$structureRoot/**/*") `
      -IncludeFiles $false `
      -IncludeDirectoryStructure $true `
      -ExtraIgnorePatterns $extraIgnore

    $cfg2 = New-TempRepomixConfig `
      -OutputPath $tmpContent `
      -IncludePatterns $include `
      -IncludeFiles $true `
      -IncludeDirectoryStructure $false `
      -ExtraIgnorePatterns ($extraIgnore + $listedOnly)

    $tmpFiles.Add($cfg1)
    $tmpFiles.Add($cfg2)

    Push-Location $RepoRoot
    try {
      Invoke-RepomixWithConfig -ConfigPath $cfg1 -Label 'structure'
      Invoke-RepomixWithConfig -ConfigPath $cfg2 -Label 'content'
    }
    finally {
      Pop-Location
    }

    $merged = @()
    $merged += "# Repomix composite bundle"
    $merged += ""
    $merged += "## Context"
    $merged += ""
    $merged += $contextText
    $merged += ""
    $merged += "## Packaging policy"
    $merged += ""
    $merged += "- structure root: `$structureRoot`"
    $merged += "- targeted include content generated from config"
    if ($listedOnly.Count -gt 0) {
      $merged += "- listed-only patterns were excluded from content to save tokens"
    }
    $merged += ""
    $merged += "## Structure pass"
    $merged += ""
    $merged += (Get-Content $tmpStructure -Raw)
    $merged += ""
    $merged += "## Content pass"
    $merged += ""
    $merged += (Get-Content $tmpContent -Raw)

    [System.IO.File]::WriteAllText($outputPath, ($merged -join [Environment]::NewLine), (New-Object System.Text.UTF8Encoding($false)))
  }
  else {
    # Simple mode:
    # only generate one repomix output from the include patterns.
    $cfg = New-TempRepomixConfig `
      -OutputPath $outputPath `
      -IncludePatterns $include `
      -IncludeFiles $true `
      -IncludeDirectoryStructure $true `
      -ExtraIgnorePatterns ($extraIgnore + $listedOnly)

    $tmpFiles.Add($cfg)

    Push-Location $RepoRoot
    try {
      Invoke-RepomixWithConfig -ConfigPath $cfg -Label 'single-pass'
    }
    finally {
      Pop-Location
    }
  }
}
finally {
  foreach ($file in $tmpFiles) {
    Remove-Item $file -Force -ErrorAction SilentlyContinue
  }
}

Write-Host "Bundle written to $(Get-RelativePath $outputPath)" -ForegroundColor Green
