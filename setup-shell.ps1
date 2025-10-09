# PowerShell profile setup for Windows

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "PowerShell Profile Setup" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# Get PowerShell profile path
$profilePath = $PROFILE.CurrentUserAllHosts

Write-Host "Profile path: $profilePath" -ForegroundColor Green
Write-Host ""

# Create profile directory if it doesn't exist
$profileDir = Split-Path -Parent $profilePath
if (!(Test-Path $profileDir)) {
    Write-Host "Creating profile directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Backup existing profile
if (Test-Path $profilePath) {
    $backupPath = "${profilePath}.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    Write-Host "Backing up existing profile to: $backupPath" -ForegroundColor Yellow
    Copy-Item $profilePath $backupPath
}

# Check if our config is already added
if ((Test-Path $profilePath) -and (Select-String -Path $profilePath -Pattern "Modern CLI Tools Integration" -Quiet)) {
    Write-Host "Profile already configured!" -ForegroundColor Green
    exit 0
}

# Add our configuration
Write-Host "Adding tool integrations to PowerShell profile..." -ForegroundColor Green

$profileContent = @'

# ============================================
# Modern CLI Tools Integration (SOTA 2025)
# ============================================

# Starship prompt
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (&starship init powershell)
}

# Zoxide (smart cd)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })

    # Zoxide environment variables
    $env:_ZOXIDE_ECHO = "1"
}

# Atuin (shell history)
if (Get-Command atuin -ErrorAction SilentlyContinue) {
    # Atuin config path
    $env:ATUIN_CONFIG_DIR = "$env:USERPROFILE\.config\atuin"
}

# Ripgrep configuration
$env:RIPGREP_CONFIG_PATH = "$env:USERPROFILE\.config\ripgrep\ripgreprc"

# Bat theme
$env:BAT_THEME = "GitHub"

# Editor
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    $env:EDITOR = "nvim"
    $env:VISUAL = "nvim"
}

# ============================================
# Aliases for modern tools
# ============================================

# Use modern alternatives (if installed)
if (Get-Command bat -ErrorAction SilentlyContinue) {
    Set-Alias -Name cat -Value bat -Option AllScope
}

if (Get-Command rg -ErrorAction SilentlyContinue) {
    Set-Alias -Name grep -Value rg -Option AllScope
}

if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Set-Alias -Name vim -Value nvim -Option AllScope
    Set-Alias -Name vi -Value nvim -Option AllScope
}

# Quick access aliases
if (Get-Command lazygit -ErrorAction SilentlyContinue) {
    Set-Alias -Name lg -Value lazygit
}

if (Get-Command lazydocker -ErrorAction SilentlyContinue) {
    Set-Alias -Name ld -Value lazydocker
}

if (Get-Command yazi -ErrorAction SilentlyContinue) {
    Set-Alias -Name fm -Value yazi
}

# ============================================
# Helper functions
# ============================================

# Quick file preview with fzf and bat
function preview {
    if ((Get-Command bat -ErrorAction SilentlyContinue) -and (Get-Command fzf -ErrorAction SilentlyContinue)) {
        Get-ChildItem -Recurse -File | ForEach-Object { $_.FullName } | fzf --preview 'bat --color=always --style=numbers {}'
    } else {
        Write-Host "Requires: bat and fzf" -ForegroundColor Red
    }
}

# PSReadLine settings for better command line experience
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Vi
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}

'@

Add-Content -Path $profilePath -Value $profileContent

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "To apply changes:" -ForegroundColor Yellow
Write-Host "  . `$PROFILE" -ForegroundColor White
Write-Host ""
Write-Host "Or restart PowerShell." -ForegroundColor White
Write-Host ""
