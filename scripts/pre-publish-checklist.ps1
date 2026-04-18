$ErrorActionPreference = 'Continue'

Write-Host "Repository pre-publish quick check" -ForegroundColor Cyan
Write-Host ""

$requiredFiles = @(
  'README.md',
  'LICENSE',
  'CONTRIBUTING.md',
  'CHANGELOG.md',
  '.editorconfig',
  '.gitignore'
)

$requiredDirs = @(
  '.github',
  'docs',
  'templates',
  'scripts'
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
Write-Host "- Review prompts for confidential wording"
Write-Host "- Remove private URLs and local paths"
Write-Host "- Confirm license choice"
Write-Host "- Confirm the repository name and description"
