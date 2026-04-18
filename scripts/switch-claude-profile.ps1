<#
.SYNOPSIS
Switches Claude Desktop between versioned MCP profile files.

.DESCRIPTION
Claude Desktop often needs different MCP configurations for different
repositories or operating modes.

This script provides a safe, reviewable way to switch the active
claude_desktop_config.json file by copying a named profile into place.

Expected profile files:
  %APPDATA%\Claude\claude_desktop_config.<profile>.json

The active file:
  %APPDATA%\Claude\claude_desktop_config.json

.PARAMETER Profile
The profile name to activate.

.PARAMETER RestoreOriginal
Restores the original backup if one was captured earlier.

.NOTES
Examples:
  pwsh ./scripts/switch-claude-profile.ps1 -Profile safe
  pwsh ./scripts/switch-claude-profile.ps1 -RestoreOriginal
#>

[CmdletBinding(DefaultParameterSetName = 'Switch')]
param(
  [Parameter(Mandatory = $true, ParameterSetName = 'Switch')]
  [string]$Profile,

  [Parameter(Mandatory = $true, ParameterSetName = 'Restore')]
  [switch]$RestoreOriginal
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$claudeDir = Join-Path $env:APPDATA 'Claude'
$activeConfig = Join-Path $claudeDir 'claude_desktop_config.json'
$backupConfig = Join-Path $claudeDir 'claude_desktop_config.original.backup.json'

if (-not (Test-Path $claudeDir)) {
  throw "Claude configuration directory not found: $claudeDir"
}

function Test-JsonFile {
  param([Parameter(Mandatory = $true)][string]$Path)

  if (-not (Test-Path $Path)) {
    throw "JSON file not found: $Path"
  }

  $raw = Get-Content -Path $Path -Raw -Encoding UTF8
  $null = $raw | ConvertFrom-Json -ErrorAction Stop
}

if ($PSCmdlet.ParameterSetName -eq 'Restore') {
  if (-not (Test-Path $backupConfig)) {
    throw "Original backup not found: $backupConfig"
  }

  Test-JsonFile -Path $backupConfig
  Copy-Item -Path $backupConfig -Destination $activeConfig -Force
  Test-JsonFile -Path $activeConfig
  Write-Host "Restored original Claude Desktop config." -ForegroundColor Green
  exit 0
}

$profileConfig = Join-Path $claudeDir ("claude_desktop_config.{0}.json" -f $Profile)
if (-not (Test-Path $profileConfig)) {
  throw "Profile config not found: $profileConfig"
}

Test-JsonFile -Path $profileConfig

# Save the original only once so the user has a clean restore path.
if ((Test-Path $activeConfig) -and -not (Test-Path $backupConfig)) {
  Copy-Item -Path $activeConfig -Destination $backupConfig -Force
}

Copy-Item -Path $profileConfig -Destination $activeConfig -Force
Test-JsonFile -Path $activeConfig

Write-Host "Activated Claude Desktop profile: $Profile" -ForegroundColor Green
