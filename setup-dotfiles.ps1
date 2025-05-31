#!/usr/bin/env pwsh
# 🚀 Dotfiles Setup Entry Point (Windows/PowerShell)

$ErrorActionPreference = "Stop"

function Info($msg)    { Write-Host "ℹ️  $msg" -ForegroundColor Cyan }
function Success($msg) { Write-Host "✅ $msg" -ForegroundColor Green }
function Warn($msg)    { Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function ErrorExit($msg) { Write-Host "🛑 $msg" -ForegroundColor Red; exit 1 }

$DOTFILES_DIR = $PSScriptRoot

# --- Check for submodules ---
if (-not (Test-Path (Join-Path $DOTFILES_DIR 'bootstrap/scripts'))) {
    ErrorExit "The bootstrap submodule is missing.`n  Run: git submodule update --init --recursive"
}

# --- OS Detection and Delegation ---
Info "Detecting operating system..."
if ($IsWindows) {
    Info "Detected Windows. Running Windows installer..."
    & (Join-Path $DOTFILES_DIR 'bootstrap/scripts/install-windows.ps1')
    if ($LASTEXITCODE -ne 0) { ErrorExit "Windows install script failed." }
} else {
    ErrorExit "Unsupported OS. This script supports Windows only."
}

# --- Install ty Python type checker ---
if (Get-Command pip -ErrorAction SilentlyContinue) {
    Info "Installing ty Python type checker..."
    pip install --user ty
    if ($LASTEXITCODE -eq 0) { Success "ty installed." } else { Warn "Failed to install ty." }
} else {
    Warn "pip not found, skipping ty installation."
}

# --- Set up ty config if present ---
$tyConfigDir = "$env:APPDATA\ty"
$dotfilesConfigTy = "$DOTFILES_DIR\config\ty\ty.toml"
if (Test-Path $dotfilesConfigTy) {
    if (!(Test-Path $tyConfigDir)) { New-Item -ItemType Directory -Path $tyConfigDir | Out-Null }
    Copy-Item $dotfilesConfigTy "$tyConfigDir\ty.toml" -Force
    Success "ty config installed."
}

# --- Ensure Yazi and ya are installed (AFTER Windows install script) ---
if (-not (Get-Command yazi -ErrorAction SilentlyContinue)) {
    Warn "Yazi is not installed. Skipping Yazi config and plugin setup. Please install yazi from https://yazi-rs.github.io/docs/installation/ if you want full functionality."
} elseif (-not (Get-Command ya -ErrorAction SilentlyContinue)) {
    Warn "ya (Yazi assistant) is not installed. Skipping Yazi plugin setup. It should be bundled with yazi. Please check your installation."
} else {
    # --- Set up Yazi config ---
    $yaziConfigDir = "$env:USERPROFILE\.config\yazi"
    if (!(Test-Path $yaziConfigDir)) { New-Item -ItemType Directory -Path $yaziConfigDir | Out-Null }
    Copy-Item "$DOTFILES_DIR\config\yazi\yazi.toml" "$yaziConfigDir\yazi.toml" -Force
    Success "Yazi config installed."
    # --- Install Yazi plugins using ya pack ---
    Push-Location $yaziConfigDir
    Info "Installing Yazi plugins..."
    ya pack -a eza-preview.yazi glow.yazi rich-preview.yazi hexyl.yazi lsar.yazi mediainfo.yazi `
      bunny.yazi easyjump.yazi projects.yazi compress.yazi diff.yazi system-clipboard.yazi `
      dual-pane.yazi starship.yazi lazygit.yazi DreamMaoMao/git.yazi fm-nvim mikavilpas/yazi.nvim
    if ($LASTEXITCODE -eq 0) { Success "Yazi plugins installed." } else { Warn "Some Yazi plugins may not have installed correctly." }
    Pop-Location
}

Success "Dotfiles setup complete! 🎉" 