<#
.SYNOPSIS
Runs a small repository sanity check before public publication.

.DESCRIPTION
This script does not try to prove the repository is perfectly safe.
It simply catches common misses early:

- missing top-level files
- missing key directories
- missing docs or templates that the README links to

It is intentionally conservative and easy to audit.

.NOTES
Run from the repository root:
  pwsh ./scripts/pre-publish-checklist.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

Write-Host "Repository pre-publish quick check" -ForegroundColor Cyan
Write-Host ""

$requiredFiles = @(
  'README.md',
  'LICENSE',
  'CONTRIBUTING.md',
  'CHANGELOG.md',
  '.editorconfig',
  '.gitignore',
  'config/claude/claude_desktop_config.example.json',
  'config/repomix/issues/repomix-config.example.json'
)

$requiredDirs = @(
  '.github',
  '.githooks',
  'docs',
  'templates',
  'scripts',
  'ai-input',
  'config'
)

foreach ($file in $requiredFiles) {
  if (Test-Path $file) {
    Write-Host "[OK] $file" -ForegroundColor Green
  }
  else {
    Write-Host "[MISSING] $file" -ForegroundColor Yellow
  }
}

foreach ($dir in $requiredDirs) {
  if (Test-Path $dir) {
    Write-Host "[OK] $dir/" -ForegroundColor Green
  }
  else {
    Write-Host "[MISSING] $dir/" -ForegroundColor Yellow
  }
}

Write-Host ""
Write-Host "Manual reminders:" -ForegroundColor Cyan
Write-Host "- Review prompts and skills for confidential wording"
Write-Host "- Review config examples for personal filesystem paths"
Write-Host "- Remove proprietary documents and screenshots"
Write-Host "- Confirm acknowledgments and references render correctly"
Write-Host "- Confirm the chosen license still matches your publication intent"
