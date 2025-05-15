# Set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

#region Conda initialize
# !! Contents within this block are managed by 'conda init' !!
Write-Host "Attempting to generate Conda hook script..." -ForegroundColor Cyan # Diagnostic message

# --- Conda Initialization (Robust hook handling) ---
# Ensure this path matches your Miniforge3 installation
$CondaExePath = Join-Path $HOME "miniforge3\Scripts\conda.exe"
if (Test-Path $CondaExePath) {
    $condaHookOutput = (& $CondaExePath "shell.powershell" "hook")
    if ($null -ne $condaHookOutput -and $condaHookOutput.Length -gt 0) {
        Write-Host "Executing Conda hook script via Invoke-Expression..." -ForegroundColor Cyan # Diagnostic message
        Invoke-Expression ($condaHookOutput -join [Environment]::NewLine)
    } else {
        Write-Warning "Conda hook script produced no output or was null during profile load."
    }
} else {
    Write-Warning "Conda executable not found at $CondaExePath. Conda initialization skipped."
}
# --- End Conda Initialization ---

# --- Workaround for Conda _CE_M/_CE_CONDA bug in PS 7.5+ ---
Remove-Item Env:_CE_M, Env:_CE_CONDA -ErrorAction SilentlyContinue
# --- End Workaround ---

# --- Auto-activate Conda Base Environment (Optional) ---
conda activate base
# --- End Auto-activate ---
#endregion

# Import modules
Import-Module -Name Terminal-Icons -ErrorAction SilentlyContinue
Import-Module -Name posh-git -ErrorAction SilentlyContinue
Import-Module -Name PSReadLine -ErrorAction SilentlyContinue

# PSReadLine Configuration
if (Get-Module -Name PSReadLine) {
    # Use Vi mode for editing
    Set-PSReadLineOption -EditMode Emacs
    # Command history search with Up/Down arrows
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    # Predictive IntelliSense
    Set-PSReadLineOption -PredictionSource History
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -Colors @{
        Command            = "#8BE9FD"
        Number             = "#FF79C6"
        Member             = "#50FA7B"
        Operator           = "#FF79C6"
        Type               = "#8BE9FD"
        Variable           = "#BD93F9"
        Parameter          = "#FFB86C"
        ContinuationPrompt = "#50FA7B"
        Default            = "#F8F8F2"
    }
    # Tab completion
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

# Configure Oh My Posh with GitHub Dark theme
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    $themeFile = "$env:USERPROFILE\.config\powershell\github-dark.omp.json"
    if (Test-Path $themeFile) {
        oh-my-posh init pwsh --config $themeFile | Invoke-Expression
    } else {
        oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin.omp.json" | Invoke-Expression
    }
}

# Show fastfetch/neofetch with custom OS logo and conda env
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    if ($env:CONDA_DEFAULT_ENV) {
        fastfetch --logo $env:OS --custom "Conda Env: $env:CONDA_DEFAULT_ENV"
    } else {
        fastfetch --logo $env:OS
    }
} elseif (Get-Command neofetch -ErrorAction SilentlyContinue) {
    if ($env:CONDA_DEFAULT_ENV) {
        neofetch --ascii_distro $env:OS --print_info Conda
    } else {
        neofetch --ascii_distro $env:OS
    }
}

# Modern CLI tool aliases with graceful fallback
if (Get-Command eza -ErrorAction SilentlyContinue) {
    Set-Alias ls eza
} elseif (Get-Command exa -ErrorAction SilentlyContinue) {
    Set-Alias ls exa
} elseif (Get-Command lsd -ErrorAction SilentlyContinue) {
    Set-Alias ls lsd
} else {
    Set-Alias ls ls
}
if (Get-Command sd -ErrorAction SilentlyContinue) {
    Set-Alias sed sd
} else {
    Set-Alias sed sed
}
if (Get-Command xh -ErrorAction SilentlyContinue) {
    Set-Alias http xh
} elseif (Get-Command http -ErrorAction SilentlyContinue) {
    Set-Alias http http
} else {
    Set-Alias http curl
}
if (Get-Command gitui -ErrorAction SilentlyContinue) {
    Set-Alias gui gitui
}
if (Get-Command rga -ErrorAction SilentlyContinue) {
    Set-Alias rga rga
}
if (Get-Command batman -ErrorAction SilentlyContinue) {
    Set-Alias batman batman
}
if (Get-Command batgrep -ErrorAction SilentlyContinue) {
    Set-Alias batgrep batgrep
}
if (Get-Command batdiff -ErrorAction SilentlyContinue) {
    Set-Alias batdiff batdiff
}
if (Get-Command onefetch -ErrorAction SilentlyContinue) {
    Set-Alias onefetch onefetch
}
# vivid LS_COLORS (https://github.com/sharkdp/vivid)
if (Get-Command vivid -ErrorAction SilentlyContinue) {
    $env:LS_COLORS = & vivid generate catppuccin-mocha
}
# Tool docs:
# eza: https://github.com/eza-community/eza
# vivid: https://github.com/sharkdp/vivid
# sd: https://github.com/chmln/sd
# xh: https://github.com/ducaale/xh
# gitui: https://github.com/extrawurst/gitui
# rga: https://github.com/phiresky/ripgrep-all
# bat-extras: https://github.com/eth-p/bat-extras
# onefetch: https://github.com/o2sh/onefetch

# Other useful aliases
Set-Alias vim nvim -ErrorAction SilentlyContinue
Set-Alias g git
Set-Alias less Out-Host
Set-Alias touch New-Item
Set-Alias ll Get-ChildItemColor

# Function to emulate Unix ls command with color
function Get-ChildItemColor {
    Get-ChildItem -Force @args | Format-Table -AutoSize
}

# Function to find files (like find in Unix)
function Find-File {
    param(
        [Parameter(Position = 0)]
        [string]$Pattern = "*",
        [Parameter(Position = 1)]
        [string]$Path = "."
    )
    Get-ChildItem -Path $Path -Recurse -Filter $Pattern
}

# Function to quickly edit this profile
function Edit-Profile {
    if (Test-Path -Path $PROFILE) {
        nvim $PROFILE
    } else {
        nvim $PSCommandPath
    }
}

# Function to update PowerShell modules
function Update-Modules {
    Write-Host "Updating PowerShell modules..." -ForegroundColor Cyan
    $psgModule = Get-Module PowerShellGet -ListAvailable | Sort-Object Version -Descending | Select-Object -First 1
    $psgLatest = Find-Module PowerShellGet
    if ($psgModule.Version -lt $psgLatest.Version) {
        Write-Host "Updating PowerShellGet from $($psgModule.Version) to $($psgLatest.Version)" -ForegroundColor Yellow
        Install-Module -Name PowerShellGet -Force -AllowClobber
    }
    Get-InstalledModule | ForEach-Object {
        $currentVersion = $_.Version
        $name = $_.Name
        $latest = Find-Module -Name $name
        if ($currentVersion -lt $latest.Version) {
            Write-Host "Updating $name from $currentVersion to $($latest.Version)" -ForegroundColor Yellow
            Update-Module -Name $name -Force
        }
    }
    Write-Host "All modules up to date!" -ForegroundColor Green
}

# Function to update system and packages
function Update-System {
    Write-Host "Updating system packages..." -ForegroundColor Cyan
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "Updating winget packages..." -ForegroundColor Yellow
        winget upgrade --all
    }
    if (Get-Command scoop -ErrorAction SilentlyContinue) {
        Write-Host "Updating scoop packages..." -ForegroundColor Yellow
        scoop update
        scoop update *
    }
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Updating Chocolatey packages..." -ForegroundColor Yellow
        choco upgrade all -y
    }
    Update-Modules
    Write-Host "System update completed!" -ForegroundColor Green
}

# Function to create new directory and enter it
function mkcd {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Path
    )
    New-Item -ItemType Directory -Path $Path -Force
    Set-Location -Path $Path
}

# Function to go up a specified number of directories
function up {
    param(
        [Parameter(Position = 0)]
        [int]$Levels = 1
    )
    $path = (Get-Location).Path
    for ($i = 0; $i -lt $Levels; $i++) {
        $path = Split-Path -Path $path -Parent
    }
    Set-Location -Path $path
}

# Create a simple HTTP server in the current directory
function Start-HttpServer {
    param(
        [Parameter(Position = 0)]
        [int]$Port = 8000
    )
    $Hso = New-Object Net.HttpListener
    $Hso.Prefixes.Add("http://localhost:$Port/")
    $Hso.Start()
    Write-Host "HTTP Server started at http://localhost:$Port/" -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    try {
        while ($Hso.IsListening) {
            $Context = $Hso.GetContext()
            $Req = $Context.Request
            $Res = $Context.Response
            $Path = $Req.Url.LocalPath.Substring(1)
            if ([string]::IsNullOrEmpty($Path) -or $Path -eq "/") {
                $Path = "index.html"
            }
            $FilePath = Join-Path (Get-Location) $Path
            if (Test-Path $FilePath -PathType Leaf) {
                $Content = Get-Content $FilePath -Raw -Encoding Byte
                $Res.ContentType = Get-MimeType $Path
                $Res.ContentLength64 = $Content.Length
                $Res.OutputStream.Write($Content, 0, $Content.Length)
            } else {
                $Res.StatusCode = 404
            }
            $Res.Close()
        }
    } finally {
        $Hso.Stop()
        Write-Host "HTTP Server stopped" -ForegroundColor Red
    }
}

# Helper function to get MIME type
function Get-MimeType {
    param(
        [Parameter(Position = 0)]
        [string]$Path
    )
    $Extension = [System.IO.Path]::GetExtension($Path).ToLower()
    switch ($Extension) {
        ".html" { return "text/html" }
        ".css" { return "text/css" }
        ".js" { return "application/javascript" }
        ".json" { return "application/json" }
        ".png" { return "image/png" }
        ".jpg" { return "image/jpeg" }
        ".jpeg" { return "image/jpeg" }
        ".gif" { return "image/gif" }
        ".svg" { return "image/svg+xml" }
        ".txt" { return "text/plain" }
        default { return "application/octet-stream" }
    }
}

# Function to get the IP address
function Get-IPAddress {
    $interfaces = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" }
    $interfaces | Format-Table InterfaceAlias, IPAddress, PrefixLength
}

# Function to quickly search in files
function Find-InFiles {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Pattern,
        [Parameter(Position = 1)]
        [string]$Path = ".",
        [Parameter()]
        [string]$Filter = "*"
    )
    Get-ChildItem -Path $Path -Recurse -File -Filter $Filter | Select-String -Pattern $Pattern
}

# Function to show disk usage
function Get-DiskUsage {
    Get-CimInstance -Class Win32_LogicalDisk |
    Where-Object { $_.DriveType -eq 3 } |
    Format-Table DeviceID, 
    @{Name="Size (GB)"; Expression={[math]::Round($_.Size / 1GB, 2)}}, 
    @{Name="Free (GB)"; Expression={[math]::Round($_.FreeSpace / 1GB, 2)}}, 
    @{Name="Free (%)"; Expression={[math]::Round(($_.FreeSpace / $_.Size) * 100, 2)}}
}

# Function to create a new PowerShell script
function New-Script {
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]$Name
    )
    if (-not $Name.EndsWith('.ps1')) {
        $Name = "$Name.ps1"
    }
    $scriptContent = @"
#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Brief description of what this script does.
    
.DESCRIPTION
    Detailed description of what this script does.
    
.PARAMETER Param1
    Description of parameter 1
    
.EXAMPLE
    Example usage of the script
    
.NOTES
    Author: $env:USERNAME
    Date: $(Get-Date -Format "yyyy-MM-dd")
#>

param(
    [Parameter()]
    [string]`$Param1 = "DefaultValue"
)

# Script logic here

"@
    $scriptContent | Out-File -FilePath $Name -Encoding utf8
    Write-Host "Created $Name" -ForegroundColor Green
    nvim $Name
}

# Function to show system information
function Get-SystemInfo {
    $os = Get-CimInstance -Class Win32_OperatingSystem
    $cpu = Get-CimInstance -Class Win32_Processor
    $memory = Get-CimInstance -Class Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum
    Write-Host "SYSTEM INFORMATION" -ForegroundColor Cyan
    Write-Host "===============================================" -ForegroundColor Cyan
    Write-Host "OS: $($os.Caption) $($os.Version)" -ForegroundColor White
    Write-Host "CPU: $($cpu.Name)" -ForegroundColor White
    Write-Host "Memory: $([math]::Round($memory.Sum / 1GB, 2)) GB" -ForegroundColor White
    Write-Host "Computer: $($env:COMPUTERNAME)" -ForegroundColor White
    Write-Host "User: $($env:USERNAME)" -ForegroundColor White
    Write-Host "PowerShell: $($PSVersionTable.PSVersion)" -ForegroundColor White
    Write-Host "===============================================" -ForegroundColor Cyan
}

# Set environment variables
$env:EDITOR = "nvim"

# Welcome message
Write-Host "Welcome to PowerShell $($PSVersionTable.PSVersion)" -ForegroundColor Cyan
Write-Host "Type 'Get-SystemInfo' to see system information" -ForegroundColor Yellow

# Load custom configurations if they exist
$localProfile = Join-Path $PSScriptRoot "local_profile.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}

# Initialize Starship prompt if available and not using Oh My Posh
if ((Get-Command starship -ErrorAction SilentlyContinue) -and -not (Get-Command oh-my-posh -ErrorAction SilentlyContinue)) {
    Invoke-Expression (&starship init powershell)
} 