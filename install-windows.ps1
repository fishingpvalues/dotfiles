# Windows installation script using Scoop
# Run with: powershell -ExecutionPolicy Bypass -File install-windows.ps1

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Dotfiles Installation for Windows" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Check if Scoop is installed
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Scoop package manager..." -ForegroundColor Yellow
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

# Add extras bucket for more tools
Write-Host "Adding Scoop buckets..." -ForegroundColor Green
scoop bucket add extras
scoop bucket add nerd-fonts

# Install Nerd Fonts
Write-Host "Installing JetBrainsMono Nerd Font..." -ForegroundColor Green
scoop install JetBrainsMono-NF-Mono

# Core tools
Write-Host "Installing core tools..." -ForegroundColor Green
$coreTools = @('git', 'neovim', 'tmux')
foreach ($tool in $coreTools) {
    if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
        scoop install $tool
    } else {
        Write-Host "  $tool already installed" -ForegroundColor Gray
    }
}

# Modern CLI replacements
Write-Host "Installing modern CLI tools..." -ForegroundColor Green
$cliTools = @('bat', 'fd', 'ripgrep', 'fzf', 'delta')
foreach ($tool in $cliTools) {
    if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
        scoop install $tool
    } else {
        Write-Host "  $tool already installed" -ForegroundColor Gray
    }
}

# TUI applications
Write-Host "Installing TUI applications..." -ForegroundColor Green
$tuiTools = @('lazygit', 'lazydocker', 'btop')
foreach ($tool in $tuiTools) {
    if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
        scoop install $tool
    } else {
        Write-Host "  $tool already installed" -ForegroundColor Gray
    }
}

# Shell enhancements
Write-Host "Installing shell enhancements..." -ForegroundColor Green
$shellTools = @('starship', 'zoxide', 'atuin')
foreach ($tool in $shellTools) {
    if (!(Get-Command $tool -ErrorAction SilentlyContinue)) {
        scoop install $tool
    } else {
        Write-Host "  $tool already installed" -ForegroundColor Gray
    }
}

# File manager
Write-Host "Installing file manager..." -ForegroundColor Green
if (!(Get-Command yazi -ErrorAction SilentlyContinue)) {
    scoop install yazi
} else {
    Write-Host "  yazi already installed" -ForegroundColor Gray
}

# Alternative multiplexer
Write-Host "Installing zellij..." -ForegroundColor Green
if (!(Get-Command zellij -ErrorAction SilentlyContinue)) {
    scoop install zellij
} else {
    Write-Host "  zellij already installed" -ForegroundColor Gray
}

# Helix editor
Write-Host "Installing helix..." -ForegroundColor Green
if (!(Get-Command helix -ErrorAction SilentlyContinue)) {
    scoop install helix
} else {
    Write-Host "  helix already installed" -ForegroundColor Gray
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart your terminal" -ForegroundColor White
Write-Host "2. Run: ./setup-shell.ps1" -ForegroundColor White
Write-Host "3. Configure your terminal to use JetBrainsMono Nerd Font" -ForegroundColor White
Write-Host ""
