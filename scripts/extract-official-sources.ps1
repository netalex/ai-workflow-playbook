<#
.SYNOPSIS
Runs a dual extraction flow for official or sensitive source documents.

.DESCRIPTION
This script orchestrates a practical local pipeline for DOCX-heavy official drops.
It is intentionally conservative and review-oriented.

For each DOCX input it can produce:
- a Pandoc probe markdown
- a Pandoc master markdown
- extracted media for both passes
- optional Docling markdown and JSON output
- a small manifest describing what was generated

This script does not modify the source DOCX files.
It is designed for a workbench repository or a workbench-style area.

.PARAMETER InputFiles
One or more DOCX files to process.

.PARAMETER OutputRoot
Root directory where extracted artifacts will be written.

.PARAMETER RunDocling
If set, also invoke Docling for structured Markdown and JSON output.

.NOTES
Example:
  pwsh ./scripts/extract-official-sources.ps1     -InputFiles ./sources/drop/working-copy/doc1.docx, ./sources/drop/working-copy/doc2.docx     -OutputRoot ./sources/drop/extracted     -RunDocling
#>

[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [string[]]$InputFiles,

  [Parameter(Mandatory = $true)]
  [string]$OutputRoot,

  [switch]$RunDocling
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function New-Directory {
  param([Parameter(Mandatory = $true)][string]$Path)
  $null = New-Item -ItemType Directory -Force -Path $Path
}

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][AllowEmptyString()][string]$Content
  )

  $parent = Split-Path -Parent $Path
  if ($parent) {
    $null = New-Item -ItemType Directory -Force -Path $parent
  }

  [System.IO.File]::WriteAllText($Path, $Content, (New-Object System.Text.UTF8Encoding($false)))
}

$pandoc = Get-Command pandoc -ErrorAction SilentlyContinue
if (-not $pandoc) {
  throw 'pandoc was not found in PATH.'
}

$docling = Get-Command docling -ErrorAction SilentlyContinue
if ($RunDocling -and -not $docling) {
  throw 'docling was requested but was not found in PATH.'
}

$markdownRoot = Join-Path $OutputRoot 'markdown'
$probeRoot = Join-Path $markdownRoot 'probe'
$masterRoot = Join-Path $markdownRoot 'master'
$mediaRoot = Join-Path $OutputRoot 'media'
$doclingRoot = Join-Path $OutputRoot 'docling'
$manifestRoot = Join-Path $OutputRoot 'manifests'

New-Directory $probeRoot
New-Directory $masterRoot
New-Directory $mediaRoot
New-Directory $manifestRoot
if ($RunDocling) { New-Directory $doclingRoot }

$manifestLines = @(
  '# Official-source extraction manifest',
  '',
  ('- run_utc: ' + (Get-Date).ToUniversalTime().ToString('s') + 'Z'),
  ('- output_root: ' + $OutputRoot),
  ('- pandoc_path: ' + $pandoc.Source),
  ('- docling_enabled: ' + $RunDocling.IsPresent),
  ''
)

foreach ($input in $InputFiles) {
  if (-not (Test-Path $input)) {
    throw "Input file not found: $input"
  }

  $item = Get-Item $input
  $slug = ($item.BaseName.ToLower() -replace '[^a-z0-9]+', '-').Trim('-')
  if (-not $slug) { $slug = 'document' }

  $probeOut = Join-Path $probeRoot "$slug.probe.md"
  $masterOut = Join-Path $masterRoot "$slug.master.md"
  $probeMedia = Join-Path $mediaRoot "$slug-probe"
  $masterMedia = Join-Path $mediaRoot "$slug-master"

  New-Directory $probeMedia
  New-Directory $masterMedia

  Write-Host "[pandoc] probe  -> $probeOut" -ForegroundColor Cyan
  & $pandoc.Source $input -f docx+styles -t gfm --track-changes=all --extract-media=$probeMedia -o $probeOut
  if ($LASTEXITCODE -ne 0) {
    throw "Pandoc probe extraction failed for: $input"
  }

  Write-Host "[pandoc] master -> $masterOut" -ForegroundColor Cyan
  & $pandoc.Source $input -f docx -t gfm --track-changes=accept --extract-media=$masterMedia -o $masterOut
  if ($LASTEXITCODE -ne 0) {
    throw "Pandoc master extraction failed for: $input"
  }

  $manifestLines += @(
    "## $($item.Name)",
    '',
    ('- probe_markdown: ' + $probeOut),
    ('- master_markdown: ' + $masterOut),
    ('- probe_media_dir: ' + $probeMedia),
    ('- master_media_dir: ' + $masterMedia)
  )

  if ($RunDocling) {
    Write-Host "[docling]      -> $doclingRoot" -ForegroundColor Cyan
    & $docling.Source --from docx --to md --to json --image-export-mode referenced --output $doclingRoot $input
    if ($LASTEXITCODE -ne 0) {
      throw "Docling extraction failed for: $input"
    }
    $manifestLines += ('- docling_output_root: ' + $doclingRoot)
  }

  $manifestLines += ''
}

$manifestPath = Join-Path $manifestRoot 'official-source-extraction.md'
Write-Utf8NoBom -Path $manifestPath -Content ($manifestLines -join [Environment]::NewLine)
Write-Host "[OK] manifest  -> $manifestPath" -ForegroundColor Green
