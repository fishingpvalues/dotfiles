# PowerShell root install script for Windows
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$target = Join-Path $scriptDir 'scripts\install-windows.ps1'
if (Test-Path $target) {
    & $target @args
} else {
    Write-Error "Error: bootstrap/scripts/install-windows.ps1 not found."
    exit 1
} 