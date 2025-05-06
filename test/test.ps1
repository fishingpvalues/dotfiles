# test/test.ps1
$ErrorActionPreference = 'Stop'

Write-Host "Testing PowerShell dotfiles setup..." -ForegroundColor Cyan

# Run full bootstrap install script (simulate CI)
if (Test-Path "$PSScriptRoot/../bootstrap/scripts/windows/install.ps1") {
    Write-Host "Running full bootstrap install..." -ForegroundColor Yellow
    & "$PSScriptRoot/../bootstrap/scripts/windows/install.ps1"
}

# Run LSP install script directly
if (Test-Path "$PSScriptRoot/../bootstrap/scripts/windows/install-lsp-servers.ps1") {
    Write-Host "Running LSP install script..." -ForegroundColor Yellow
    & "$PSScriptRoot/../bootstrap/scripts/windows/install-lsp-servers.ps1"
}

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

# Run Neovim Plenary tests (headless)
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Write-Host "Running Neovim Plenary tests..." -ForegroundColor Yellow
    nvim --headless -c "PlenaryBustedDirectory lua/custom/tests/ {minimal_init = 'lua/minimal_init.lua'}"
}

Write-Host "All PowerShell tests passed!" -ForegroundColor Green 