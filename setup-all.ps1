# Complete setup script for Windows

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Complete Dotfiles Setup (Windows)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Step 1: Install tools
Write-Host "Step 1/4: Installing tools..." -ForegroundColor Yellow
Write-Host "----------------------------" -ForegroundColor Yellow
& "$scriptDir\install-windows.ps1"

# Step 2: Create config directory link
Write-Host ""
Write-Host "Step 2/4: Setting up config directory..." -ForegroundColor Yellow
Write-Host "----------------------------------------" -ForegroundColor Yellow

$configSource = Join-Path $scriptDir ".config"
$configTarget = Join-Path $env:USERPROFILE ".config"

if (Test-Path $configTarget) {
    if ((Get-Item $configTarget).LinkType -ne "SymbolicLink") {
        $backupPath = "${configTarget}.backup.$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Write-Host "Backing up existing .config to: $backupPath" -ForegroundColor Yellow
        Move-Item $configTarget $backupPath
    }
}

if (!(Test-Path $configTarget)) {
    Write-Host "Creating symlink: $configTarget -> $configSource" -ForegroundColor Green
    New-Item -ItemType SymbolicLink -Path $configTarget -Target $configSource -Force | Out-Null
} else {
    Write-Host ".config already exists" -ForegroundColor Gray
}

# Step 3: Setup PowerShell profile
Write-Host ""
Write-Host "Step 3/4: Setting up PowerShell profile..." -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow
& "$scriptDir\setup-shell.ps1"

# Step 4: Setup git (requires Git Bash or WSL for the bash script)
Write-Host ""
Write-Host "Step 4/4: Setting up git configuration..." -ForegroundColor Yellow
Write-Host "-----------------------------------------" -ForegroundColor Yellow

# Configure git directly in PowerShell
if (Get-Command git -ErrorAction SilentlyContinue) {
    $configPath = Join-Path $env:USERPROFILE ".config\delta\themes.gitconfig"

    Write-Host "Configuring git with delta integration..." -ForegroundColor Green

    git config --global include.path $configPath
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate "true"
    git config --global delta.features "github-dark"

    if (Get-Command nvim -ErrorAction SilentlyContinue) {
        git config --global core.editor "nvim"
    }

    git config --global init.defaultBranch "main"
    git config --global pull.rebase "true"
    git config --global push.autoSetupRemote "true"
    git config --global merge.conflictStyle "diff3"
    git config --global fetch.prune "true"

    Write-Host "Git configuration complete!" -ForegroundColor Green
}

# Setup Neovim
Write-Host ""
Write-Host "Setting up Neovim..." -ForegroundColor Yellow
Write-Host "-------------------" -ForegroundColor Yellow
if (Get-Command nvim -ErrorAction SilentlyContinue) {
    Write-Host "Neovim will install plugins on first run." -ForegroundColor Gray
    Write-Host "Run 'nvim' to trigger plugin installation." -ForegroundColor Gray
}

# Setup Tmux (if in WSL/Git Bash context)
Write-Host ""
Write-Host "Setting up Tmux..." -ForegroundColor Yellow
Write-Host "-----------------" -ForegroundColor Yellow
$tpmPath = Join-Path $env:USERPROFILE ".tmux\plugins\tpm"
if (Get-Command tmux -ErrorAction SilentlyContinue) {
    if (!(Test-Path $tpmPath)) {
        Write-Host "Installing TPM (Tmux Plugin Manager)..." -ForegroundColor Green
        git clone https://github.com/tmux-plugins/tpm $tpmPath
        Write-Host "Tmux plugins will install when you start tmux and press Ctrl-a + I" -ForegroundColor Gray
    } else {
        Write-Host "TPM already installed" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Restart PowerShell: . `$PROFILE" -ForegroundColor White
Write-Host "2. Run 'nvim' to install Neovim plugins" -ForegroundColor White
Write-Host "3. Configure Windows Terminal to use JetBrainsMono Nerd Font" -ForegroundColor White
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Yellow
Write-Host "  lg       - lazygit" -ForegroundColor White
Write-Host "  ld       - lazydocker" -ForegroundColor White
Write-Host "  fm       - yazi file manager" -ForegroundColor White
Write-Host "  btop     - system monitor" -ForegroundColor White
Write-Host "  z <path> - quick jump with zoxide" -ForegroundColor White
Write-Host "  Ctrl+R   - search history with atuin" -ForegroundColor White
Write-Host ""
