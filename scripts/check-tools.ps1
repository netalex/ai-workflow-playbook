<#
.SYNOPSIS
Checks whether the core tools required by the workflow are available.

.DESCRIPTION
This script is intentionally simple and readable.
It verifies the presence of the local tools most frequently used in the playbook:

- Git
- Node.js and npm
- Python
- uv
- VS Code
- ctxvault
- ctxvault-mcp
- repomix
- pandoc
- docling
- magick

The output is designed for humans first.
The script does not modify the machine state.

.NOTES
Run from the repository root:
  pwsh ./scripts/check-tools.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

# The ordered list is deliberate: show the most foundational tools first.
$tools = @(
  'git',
  'node',
  'npm',
  'python',
  'uv',
  'code',
  'ctxvault',
  'ctxvault-mcp',
  'repomix',
  'pandoc',
  'docling',
  'magick'
)

Write-Host "Checking local tool availability..." -ForegroundColor Cyan
Write-Host ""

# Build a small table that tells the reader:
# - which tool was found
# - where it was found
# This is often enough to catch PATH problems immediately.
$results = foreach ($tool in $tools) {
  $command = Get-Command $tool -ErrorAction SilentlyContinue

  if ($command) {
    [PSCustomObject]@{
      Tool = $tool
      Available = $true
      Path = $command.Source
    }
  }
  else {
    [PSCustomObject]@{
      Tool = $tool
      Available = $false
      Path = ''
    }
  }
}

$results | Format-Table -AutoSize

$missing = @($results | Where-Object { -not $_.Available })

Write-Host ""
if ($missing.Count -eq 0) {
  Write-Host "All listed tools are available." -ForegroundColor Green
}
else {
  Write-Host "Missing tools detected:" -ForegroundColor Yellow
  foreach ($item in $missing) {
    Write-Host "- $($item.Tool)" -ForegroundColor Yellow
  }

  Write-Host ""
  Write-Host "Hint: this playbook assumes ctxvault and ctxvault-mcp are installed via uv tool." -ForegroundColor DarkGray
  Write-Host "Hint: pandoc, docling, and a local image conversion tool matter more when you process official DOCX-heavy source drops." -ForegroundColor DarkGray
}
