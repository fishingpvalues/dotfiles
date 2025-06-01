# test/test.ps1
$ErrorActionPreference = 'Stop'

function Info($msg)    { Write-Host "ℹ️  $msg" -ForegroundColor Cyan }
function Success($msg) { Write-Host "✅ $msg" -ForegroundColor Green }
function Warn($msg)    { Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function ErrorExit($msg) { Write-Host "🛑 $msg" -ForegroundColor Red; exit 1 }

Info "Testing PowerShell dotfiles setup..."

if (-not $env:HOME) { $env:HOME = $env:USERPROFILE }

# Check chezmoi version
if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
    $version = chezmoi --version | Select-String -Pattern '\d+\.\d+\.\d+' | ForEach-Object { $_.Matches[0].Value }
    Info "Detected chezmoi version: $version"
} else {
    Warn "chezmoi not found in PATH."
}

$CHEZMOI_VERSION = 'v2.37.0'

# Install chezmoi if not present
if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
    scoop install chezmoi@$CHEZMOI_VERSION
    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        ErrorExit "chezmoi installation failed. See https://www.chezmoi.io for help."
    }
}

# Init chezmoi if needed
$chezmoiData = Join-Path $env:HOME ".local\share\chezmoi"
if (-not (Test-Path $chezmoiData)) {
    chezmoi init --source=.
    if ($LASTEXITCODE -ne 0) {
        ErrorExit "chezmoi init failed.`nHint: Check your .chezmoi.toml and repository structure. Try running 'chezmoi doctor' for diagnostics."
    }
}

# Apply dotfiles
chezmoi apply
if ($LASTEXITCODE -ne 0) {
    ErrorExit "chezmoi apply failed.`nHint: Check your .chezmoi.toml for syntax errors, run 'chezmoi diff' and 'chezmoi doctor' for troubleshooting. See https://www.chezmoi.io/user-guide/ for help."
}

# Run full bootstrap install script (simulate CI)
if (Test-Path "$PSScriptRoot/../bootstrap/scripts/windows/install.ps1") {
    Warn "Running full bootstrap install..."
    & "$PSScriptRoot/../bootstrap/scripts/windows/install.ps1"
}

# Run LSP install script directly
if (Test-Path "$PSScriptRoot/../bootstrap/scripts/windows/install-lsp-servers.ps1") {
    Warn "Running LSP install script..."
    & "$PSScriptRoot/../bootstrap/scripts/windows/install-lsp-servers.ps1"
}

# Import the user profile
. $PSScriptRoot/../config/powershell/user_profile.ps1

# Test key functions and aliases
Warn "Testing aliases and functions..."

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
    Warn "Running Neovim Plenary tests..."
    nvim --headless -c "PlenaryBustedDirectory lua/custom/tests/ {minimal_init = 'lua/minimal_init.lua'}"
}

Success "All PowerShell tests passed!" 