#!/usr/bin/env pwsh
# Thin entry point for dotfiles setup (Windows/Unix)

$ErrorActionPreference = "Stop"

$DOTFILES_DIR = $PSScriptRoot

# Check for submodules
if (-not (Test-Path (Join-Path $DOTFILES_DIR 'bootstrap/scripts'))) {
    Write-Host "[ERROR] The bootstrap submodule is missing. Run:`n  git submodule update --init --recursive" -ForegroundColor Red
    exit 1
}

# Detect platform and delegate
if ($IsWindows) {
    & (Join-Path $DOTFILES_DIR 'bootstrap/scripts/windows/install.ps1')
} else {
    & (Join-Path $DOTFILES_DIR 'bootstrap/scripts/unix/install.sh')
} 