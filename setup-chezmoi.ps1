#!/usr/bin/env/pwsh
# setup-chezmoi.ps1 - Script to configure chezmoi for the current dotfiles structure

# Set the current directory as the source state for chezmoi
$DOTFILES_DIR = $PSScriptRoot
$CHEZMOI_DIR = "$DOTFILES_DIR\.chezmoi"
$CHEZMOI_BIN = "$DOTFILES_DIR\bin\chezmoi.exe"

# Install chezmoi if not already installed
if (-not (Test-Path $CHEZMOI_BIN)) {
    Write-Host "Installing chezmoi..." -ForegroundColor Cyan
    # Create bin directory if it doesn't exist
    if (-not (Test-Path "$DOTFILES_DIR\bin")) {
        New-Item -ItemType Directory -Path "$DOTFILES_DIR\bin" -Force | Out-Null
    }
    # Download and install chezmoi
    & ([scriptblock]::Create((Invoke-RestMethod -Uri 'https://get.chezmoi.io/ps1'))) -BinDir "$DOTFILES_DIR\bin"
}

# Create chezmoi directories if they don't exist
if (-not (Test-Path $CHEZMOI_DIR)) {
    New-Item -ItemType Directory -Path $CHEZMOI_DIR -Force | Out-Null
}

# Check if chezmoi is already initialized
if (-not (Test-Path "$CHEZMOI_DIR\config")) {
    & $CHEZMOI_BIN init --source=$DOTFILES_DIR
}

# Map config directories to their destination paths
$configMappings = @{
    # Bash configuration
    "config\bash\bashrc"          = "dot_bashrc"
    
    # ZSH configuration
    "config\zsh\zshrc"            = "dot_zshrc"
    "config\zsh\p10k.zsh"         = "dot_p10k.zsh"
    
    # Neovim configuration
    "config\nvim"                 = "dot_config\nvim"
    
    # VS Code configuration
    "config\vscode\settings.json" = "AppData\Roaming\Code\User\settings.json"
    "config\vscode\keybindings.json" = "AppData\Roaming\Code\User\keybindings.json"
    
    # Terminal configurations
    "config\kitty"                = "dot_config\kitty"
    "config\wezterm"              = "dot_config\wezterm"
    "config\alacritty"            = "dot_config\alacritty"
    "config\windows-terminal\settings.json" = "AppData\Local\Microsoft\Windows Terminal\settings.json"
    
    # Shell configurations
    "config\nushell"              = "dot_config\nushell"
    "config\powershell\user_profile.ps1" = "Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
    "config\powershell\github-dark.omp.json" = "AppData\Local\Programs\oh-my-posh\themes\github-dark.omp.json"
    
    # Git configuration
    "config\git\gitconfig"        = "dot_gitconfig"
    "config\git\gitignore_global" = "dot_gitignore_global"
    
    # SSH configuration
    "config\ssh\config"           = ".ssh\config"
    
    # Starship configuration
    "config\starship\starship.toml" = "dot_config\starship.toml"
    
    # Lazygit configuration
    "config\lazygit"              = "dot_config\lazygit"
    
    # FZF configuration
    "config\fzf\fzf.config"       = "dot_config\fzf\config"
    
    # Other configurations
    "config\wget"                 = "dot_config\wget"
    "config\curl"                 = "dot_config\curl"
}

# Create chezmoi source directory
Write-Host "Setting up chezmoi source directory..." -ForegroundColor Cyan

# Create the .local/share/chezmoi directory where chezmoi expects data
$sourceDir = "$env:USERPROFILE\.local\share\chezmoi"
if (-not (Test-Path $sourceDir)) {
    New-Item -ItemType Directory -Path $sourceDir -Force | Out-Null
}

# Map files to their chezmoi locations
foreach ($mapping in $configMappings.GetEnumerator()) {
    $sourcePath = Join-Path $DOTFILES_DIR $mapping.Key
    $targetPath = Join-Path $env:USERPROFILE $mapping.Value
    
    if (Test-Path $sourcePath) {
        # Add the file/directory to chezmoi
        Write-Host "Adding $($mapping.Key) to chezmoi..." -ForegroundColor Green
        
        # For directories, we need to make sure the parent directory exists
        if ((Get-Item $sourcePath -ErrorAction SilentlyContinue).PSIsContainer) {
            $targetDir = Split-Path $targetPath -Parent
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            
            # Copy the directory to the target
            Copy-Item -Path $sourcePath -Destination $targetPath -Recurse -Force -ErrorAction SilentlyContinue
        } else {
            # For files, copy directly
            $targetDir = Split-Path $targetPath -Parent
            if (-not (Test-Path $targetDir)) {
                New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
            }
            
            # Copy the file to the target
            Copy-Item -Path $sourcePath -Destination $targetPath -Force -ErrorAction SilentlyContinue
        }
        
        # Add the file to chezmoi
        & $CHEZMOI_BIN add $targetPath
    } else {
        Write-Host "Warning: Source path $sourcePath does not exist" -ForegroundColor Yellow
    }
}

# Generate chezmoi config file if it doesn't exist
if (-not (Test-Path "$DOTFILES_DIR\.chezmoi.toml")) {
    Write-Host "Creating .chezmoi.toml configuration file..." -ForegroundColor Cyan
    @'
[data]
    email = "your.email@example.com"  # Replace with your actual email
    name = "Your Name"  # Replace with your actual name

[sourceVCS]
    autoCommit = true  # Automatically commit after modifications
    autoPush = false   # Don't automatically push (safer)

[diff]
    command = "code"
    args = ["--diff", "{{.Destination}}", "{{.Target}}"]

# Define OS-specific settings
[data.windows]
    homeDir = "C:\\Users\\{{- .chezmoi.username }}"

[data.linux]
    homeDir = "/home/{{- .chezmoi.username }}"

[data.darwin]
    homeDir = "/Users/{{- .chezmoi.username }}"
'@ | Out-File -FilePath "$DOTFILES_DIR\.chezmoi.toml" -Encoding utf8
}

# Add .chezmoi.toml to chezmoi management
if (Test-Path "$DOTFILES_DIR\.chezmoi.toml") {
    & $CHEZMOI_BIN add "$DOTFILES_DIR\.chezmoi.toml"
}

# Add chezmoi to PATH permanently for the current user
$persistentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if (-not ($persistentPath -like "*$DOTFILES_DIR\bin*")) {
    [Environment]::SetEnvironmentVariable("Path", "$persistentPath;$DOTFILES_DIR\bin", "User")
    Write-Host "Added chezmoi to your user PATH environment variable" -ForegroundColor Green
}

# Add chezmoi to PATH for current session
$env:Path = "$DOTFILES_DIR\bin;$env:Path"

# Install Oh My Posh if not already installed
if (-not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Oh My Posh..." -ForegroundColor Cyan
    if (Test-Path "$DOTFILES_DIR\scripts\windows\install-oh-my-posh.ps1") {
        & "$DOTFILES_DIR\scripts\windows\install-oh-my-posh.ps1"
    }
}

Write-Host "Chezmoi setup complete!" -ForegroundColor Green
Write-Host "You can now use chezmoi commands to manage your dotfiles:" -ForegroundColor Cyan
Write-Host "  chezmoi cd      - Navigate to the source directory" -ForegroundColor Yellow
Write-Host "  chezmoi edit    - Edit a file managed by chezmoi" -ForegroundColor Yellow
Write-Host "  chezmoi apply   - Apply changes to your home directory" -ForegroundColor Yellow
Write-Host "  chezmoi diff    - Show the differences between the source and destination files" -ForegroundColor Yellow
Write-Host "  chezmoi status  - Show the status of files in the working directory" -ForegroundColor Yellow

# Initialize Git repository for chezmoi properly
Write-Host "Setting up Git repository for chezmoi..." -ForegroundColor Cyan
$chezmoiSourceDir = & $CHEZMOI_BIN source-path
Push-Location $chezmoiSourceDir
try {
    # Initialize git repository if needed
    if (-not (Test-Path "$chezmoiSourceDir\.git")) {
        git init
    }
    
    # Configure git user if not already set
    $gitUserName = git config --get user.name 2>$null
    $gitUserEmail = git config --get user.email 2>$null
    
    if (-not $gitUserName) {
        git config --local user.name "Your Name"
    }
    
    if (-not $gitUserEmail) {
        git config --local user.email "your.email@example.com"
    }
    
    # Check if there are any commits
    $hasCommits = git rev-parse --verify HEAD 2>$null
    if ($LASTEXITCODE -ne 0) {
        # No commits yet, make initial commit
        git add .
        git commit -m "Initial commit for chezmoi"
        Write-Host "Created initial Git commit for chezmoi" -ForegroundColor Green
    }
    
    # Check if remote is correctly configured
    $correctRemoteUrl = "https://github.com/fishingpvalues/dotfiles.git"
    $currentRemoteUrl = git config --get remote.origin.url 2>$null
    
    # If remote exists but URL is wrong, update it
    if ($currentRemoteUrl -and $currentRemoteUrl -ne $correctRemoteUrl) {
        Write-Host "Updating remote URL from $currentRemoteUrl to $correctRemoteUrl" -ForegroundColor Yellow
        git remote set-url origin $correctRemoteUrl
    }
    # If remote doesn't exist, add it
    elseif (-not $currentRemoteUrl) {
        Write-Host "Adding remote origin: $correctRemoteUrl" -ForegroundColor Green
        git remote add origin $correctRemoteUrl
    }
    
    # Configure git pull to use fast-forward only
    git config pull.ff only
    
    # Set up branch tracking if needed
    $branchName = git rev-parse --abbrev-ref HEAD
    
    # Try to push to establish the remote branch if it doesn't exist
    Write-Host "Setting up tracking for branch $branchName..." -ForegroundColor Cyan
    git push -u origin $branchName 2>$null
    
    # Alternative approach if the above fails
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Remote push failed, configuring for local-only operation" -ForegroundColor Yellow
        # Configure chezmoi to work without remote updates
        git config branch.$branchName.remote no-remote
        git config branch.$branchName.merge refs/heads/$branchName
    }
} catch {
    Write-Host "Warning: Error setting up Git repository: $_" -ForegroundColor Yellow
} finally {
    Pop-Location
}

# Add a function for easily resetting the chezmoi repository
function Reset-ChezmoiRepository {
    param (
        [switch]$Force
    )
    
    Write-Host "Resetting chezmoi repository..." -ForegroundColor Cyan
    if (-not $Force -and -not (Read-Host "This will reset your chezmoi repository. Continue? (y/n)").ToLower().StartsWith("y")) {
        Write-Host "Operation canceled." -ForegroundColor Yellow
        return
    }
    
    $chezmoiSourceDir = & $CHEZMOI_BIN source-path
    Push-Location $chezmoiSourceDir
    try {
        # Reset the git repository
        git fetch origin
        git reset --hard origin/main
        git clean -fd
        Write-Host "Repository reset successfully." -ForegroundColor Green
    } catch {
        Write-Host "Error resetting repository: $_" -ForegroundColor Red
    } finally {
        Pop-Location
    }
}

# Export the function so it's available for users
Export-ModuleMember -Function Reset-ChezmoiRepository -ErrorAction SilentlyContinue