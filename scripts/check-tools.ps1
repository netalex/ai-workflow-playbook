$ErrorActionPreference = 'SilentlyContinue'

$tools = @(
  'git',
  'node',
  'npm',
  'python',
  'code',
  'ctxvault',
  'repomix'
)

Write-Host "Checking local tool availability..." -ForegroundColor Cyan
Write-Host ""

$results = foreach ($tool in $tools) {
  $command = Get-Command $tool
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

$missing = $results | Where-Object { -not $_.Available }

Write-Host ""
if ($missing.Count -eq 0) {
  Write-Host "All listed tools are available." -ForegroundColor Green
}
else {
  Write-Host "Missing tools detected:" -ForegroundColor Yellow
  $missing | ForEach-Object { Write-Host "- $($_.Tool)" }
}
