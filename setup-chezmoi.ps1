#!/usr/bin/env pwsh
# Cross-platform setup script for chezmoi dotfiles
# Supports Windows, macOS, and Linux

# Stop on errors
$ErrorActionPreference = "Stop"

# Get the current directory as the source state for chezmoi
$DOTFILES_DIR = $PSScriptRoot
$CHEZMOI_DIR = Join-Path $DOTFILES_DIR ".chezmoi"
$CHEZMOI_BIN = Join-Path $DOTFILES_DIR "bin" "chezmoi"

if ($IsWindows) {
    $CHEZMOI_BIN += ".exe"
}

Write-Host "Setting up chezmoi in $DOTFILES_DIR"

# Create bin directory if it doesn't exist
if (-not (Test-Path (Join-Path $DOTFILES_DIR "bin"))) {
    New-Item -ItemType Directory -Path (Join-Path $DOTFILES_DIR "bin") | Out-Null
}

# Install chezmoi if not already installed
if (-not (Test-Path $CHEZMOI_BIN)) {
    Write-Host "Installing chezmoi..."
    try {
        if ($IsWindows) {
            $tempFile = Join-Path $env:TEMP "chezmoi.exe"
            Invoke-WebRequest -Uri "https://github.com/twpayne/chezmoi/releases/latest/download/chezmoi_windows_amd64.exe" -OutFile $tempFile
            Move-Item $tempFile $CHEZMOI_BIN
        } else {
            $installScript = if ($IsMacOS) {
                "https://raw.githubusercontent.com/twpayne/chezmoi/master/assets/scripts/install.sh"
            } else {
                "https://get.chezmoi.io/lb"
            }
            $tempDir = Join-Path ([System.IO.Path]::GetTempPath()) ([System.IO.Path]::GetRandomFileName())
            New-Item -ItemType Directory -Path $tempDir | Out-Null
            Push-Location $tempDir
            try {
                Invoke-WebRequest -Uri $installScript -OutFile "install.sh"
                chmod +x install.sh
                ./install.sh -b (Join-Path $DOTFILES_DIR "bin")
            } finally {
                Pop-Location
                Remove-Item -Recurse -Force $tempDir
            }
        }
    } catch {
        Write-Error "Failed to download chezmoi: $_"
        exit 1
    }
}

# Create chezmoi directories if they don't exist
if (-not (Test-Path $CHEZMOI_DIR)) {
    New-Item -ItemType Directory -Path $CHEZMOI_DIR | Out-Null
}

# Initialize chezmoi if not already initialized
if (-not (Test-Path (Join-Path $CHEZMOI_DIR "config"))) {
    & $CHEZMOI_BIN init --source=$DOTFILES_DIR
}

# Define config mappings based on OS
$configMappings = @{}

if ($IsWindows) {
    $configMappings = @{
        "config\windows-terminal" = "AppData\Local\Microsoft\Windows Terminal"
        "config\powershell" = "Documents\PowerShell"
        "config\vscode\settings.json" = "AppData\Roaming\Code\User\settings.json"
        "config\vscode\keybindings.json" = "AppData\Roaming\Code\User\keybindings.json"
        "config\git\gitconfig" = ".gitconfig"
        "config\git\gitignore_global" = ".gitignore_global"
        "config\wezterm" = ".config\wezterm"
        "config\alacritty" = "AppData\Roaming\alacritty"
        "config\lazygit" = "AppData\Local\lazygit"
        "config\starship\starship.toml" = ".config\starship.toml"
    }
} elseif ($IsMacOS) {
    $configMappings = @{
        "config\vscode\settings.json" = "Library/Application Support/Code/User/settings.json"
        "config\vscode\keybindings.json" = "Library/Application Support/Code/User/keybindings.json"
        "config\git\gitconfig" = ".gitconfig"
        "config\git\gitignore_global" = ".gitignore_global"
        "config\kitty" = ".config/kitty"
        "config\wezterm" = ".config/wezterm"
        "config\alacritty" = ".config/alacritty"
        "config\zsh" = ".config/zsh"
        "config\bash" = ".config/bash"
        "config\starship\starship.toml" = ".config/starship.toml"
        "config\lazygit" = ".config/lazygit"
    }
} else {
    $configMappings = @{
        "config\vscode\settings.json" = ".config/Code/User/settings.json"
        "config\vscode\keybindings.json" = ".config/Code/User/keybindings.json"
        "config\git\gitconfig" = ".gitconfig"
        "config\git\gitignore_global" = ".gitignore_global"
        "config\kitty" = ".config/kitty"
        "config\wezterm" = ".config/wezterm"
        "config\alacritty" = ".config/alacritty"
        "config\i3" = ".config/i3"
        "config\sway" = ".config/sway"
        "config\waybar" = ".config/waybar"
        "config\rofi" = ".config/rofi"
        "config\zsh" = ".config/zsh"
        "config\bash" = ".config/bash"
        "config\starship\starship.toml" = ".config/starship.toml"
        "config\lazygit" = ".config/lazygit"
    }
}

# Create source directory
Write-Host "Setting up chezmoi source directory..."

# Process each config mapping
foreach ($sourcePath in $configMappings.Keys) {
    $targetPath = $configMappings[$sourcePath]
    $fullSourcePath = Join-Path $DOTFILES_DIR $sourcePath
    $fullTargetPath = Join-Path $HOME $targetPath

    if (Test-Path $fullSourcePath) {
        Write-Host "Adding $sourcePath to chezmoi..."

        # Create target directory if needed
        $targetDir = Split-Path -Parent $fullTargetPath
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }

        # Copy files
        try {
            if (Test-Path -PathType Container $fullSourcePath) {
                Copy-Item -Path $fullSourcePath -Destination $fullTargetPath -Recurse -Force -ErrorAction SilentlyContinue
            } else {
                Copy-Item -Path $fullSourcePath -Destination $fullTargetPath -Force -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Warning "Could not copy $sourcePath : $_"
        }

        # Add to chezmoi
        & $CHEZMOI_BIN add $fullTargetPath
    } else {
        Write-Warning "Source path $fullSourcePath does not exist"
    }
}

# Add chezmoi to PATH
if ($IsWindows) {
    $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if (-not $userPath.Contains($DOTFILES_DIR)) {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$userPath;$DOTFILES_DIR\bin",
            "User"
        )
        $env:Path = "$env:Path;$DOTFILES_DIR\bin"
    }
} else {
    $shellConfigFile = if ($IsMacOS) {
        if (Test-Path "~/.zshrc") { "~/.zshrc" } else { "~/.bashrc" }
    } else {
        "~/.bashrc"
    }

    if (-not (Select-String -Path $shellConfigFile -Pattern "$DOTFILES_DIR/bin" -Quiet)) {
        Add-Content -Path $shellConfigFile -Value "`n# Add chezmoi to PATH`nexport PATH=`"`$PATH:$DOTFILES_DIR/bin`""
    }
}

# Install packages if requested
$installPackages = Read-Host "Would you like to install recommended packages? (y/N)"
if ($installPackages -eq "y") {
    & (Join-Path $DOTFILES_DIR "scripts" "install-packages.ps1")
}

Write-Host "`nChezmoi setup complete!"
Write-Host "You can now use chezmoi commands to manage your dotfiles:"
Write-Host "  chezmoi cd      - Navigate to the source directory"
Write-Host "  chezmoi edit    - Edit a file managed by chezmoi"
Write-Host "  chezmoi apply   - Apply changes to your home directory"
Write-Host "  chezmoi diff    - Show the differences between the source and destination files"
Write-Host "  chezmoi status  - Show the status of files in the working directory"

if (-not $IsWindows) {
    Write-Host "`nTo use chezmoi from a new terminal, run:"
    Write-Host "  source $shellConfigFile"
}