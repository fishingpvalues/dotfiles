# test/test.ps1
$ErrorActionPreference = 'Stop'

Write-Host "Testing PowerShell dotfiles setup..." -ForegroundColor Cyan

# Import the user profile
. $PSScriptRoot/../config/powershell/user_profile.ps1

# Test key functions and aliases
Write-Host "Testing aliases and functions..." -ForegroundColor Yellow

# Test aliases
ll
vim --version
Get-SystemInfo

# Test mkcd and up
mkcd testdir
up 1

# Test conda if present
if (Get-Command conda -ErrorAction SilentlyContinue) {
    conda --version
    conda info
}

# Test oh-my-posh if present
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh --version
}

Write-Host "All PowerShell tests passed!" -ForegroundColor Green 