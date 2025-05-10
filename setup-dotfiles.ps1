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

# Install ty Python type checker
pip install --user ty

# Set up ty config if present
$tyConfigDir = "$env:APPDATA\ty"
$dotfilesConfigTy = "$env:DOTFILES\config\ty\ty.toml"
if (Test-Path $dotfilesConfigTy) {
    if (!(Test-Path $tyConfigDir)) { New-Item -ItemType Directory -Path $tyConfigDir | Out-Null }
    Copy-Item $dotfilesConfigTy "$tyConfigDir\ty.toml" -Force
}

# Ensure Yazi and ya are installed (ya is usually bundled with yazi)
if (-not (Get-Command yazi -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] Yazi is not installed. Please install yazi from https://yazi-rs.github.io/docs/installation/" -ForegroundColor Red
    exit 1
}
if (-not (Get-Command ya -ErrorAction SilentlyContinue)) {
    Write-Host "[ERROR] ya (Yazi assistant) is not installed. It should be bundled with yazi. Please check your installation." -ForegroundColor Red
    exit 1
}

# Set up Yazi config
$yaziConfigDir = "$env:USERPROFILE\.config\yazi"
if (!(Test-Path $yaziConfigDir)) { New-Item -ItemType Directory -Path $yaziConfigDir | Out-Null }
Copy-Item "$env:DOTFILES\config\yazi\yazi.toml" "$yaziConfigDir\yazi.toml" -Force

# Install Yazi plugins using ya pack
Push-Location $yaziConfigDir
ya pack -a eza-preview.yazi glow.yazi rich-preview.yazi hexyl.yazi lsar.yazi mediainfo.yazi `
  bunny.yazi easyjump.yazi projects.yazi compress.yazi diff.yazi system-clipboard.yazi `
  dual-pane.yazi starship.yazi lazygit.yazi DreamMaoMao/git.yazi fm-nvim mikavilpas/yazi.nvim
Pop-Location 