# test/run-all.ps1
$ErrorActionPreference = 'Stop'

Write-Host "=== Running all Windows dotfiles tests ===" -ForegroundColor Cyan

& "$PSScriptRoot/test.ps1"

Write-Host "=== All Windows tests passed ===" -ForegroundColor Green 