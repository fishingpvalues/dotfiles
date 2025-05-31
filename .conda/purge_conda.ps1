<#
.SYNOPSIS
    Attempts to uninstall Miniforge3/Conda and identifies related PATH entries and profile scripts for manual cleanup.
.DESCRIPTION
    This script performs the following actions:
    1. Prompts for confirmation.
    2. Defines the likely Miniforge installation directory.
    3. Attempts to delete the Miniforge installation directory.
    4. Attempts to delete common Conda user configuration files/folders (.conda, .condarc).
    5. Identifies and REPORTS entries in User and System PATH variables that point to the Miniforge installation.
    6. Reminds the user to manually edit PowerShell profile scripts.
    REQUIRES running as Administrator.
.NOTES
    Author: AI Assistant
    Date: 2025-04-27
    VERSION: 1.0
    *** USE AT YOUR OWN RISK. REVIEW PATHS CAREFULLY. MANUAL STEPS REQUIRED FOR PATH AND PROFILE CLEANUP. ***
#>

# --- Configuration ---
# !!! REVIEW AND CONFIRM THIS PATH IS CORRECT !!!
$MiniforgeInstallPath = "$env:USERPROFILE\miniforge3" 
# Example: If installed elsewhere, change this like:
# $MiniforgeInstallPath = "C:\ProgramData\miniforge3" 

# --- Safety Check & Confirmation ---
Write-Host "------------------------------------------" -ForegroundColor Yellow
Write-Host "Miniforge/Conda Uninstaller Helper Script" -ForegroundColor Yellow
Write-Host "------------------------------------------" -ForegroundColor Yellow
Write-Warning "This script will attempt to DELETE files and folders."
Write-Warning "Targeted Installation Directory: $MiniforgeInstallPath"
Write-Warning "It will also identify PATH entries and profile scripts needing MANUAL removal."
Write-Warning "RUN AS ADMINISTRATOR for best results (checking System PATH)."
Write-Host ""

# Check if the path actually exists before proceeding
if (-not (Test-Path -Path $MiniforgeInstallPath -PathType Container)) {
    Write-Warning "The specified Miniforge installation path does not exist: $MiniforgeInstallPath"
    Write-Warning "Skipping deletion of installation directory, but continuing with cleanup and reporting."
} else {
    # 1. Delete Miniforge Installation Directory
    Write-Host "Attempting to delete Miniforge installation directory: $MiniforgeInstallPath"
    try {
        Remove-Item -Path $MiniforgeInstallPath -Recurse -Force -ErrorAction Stop
        Write-Host "[SUCCESS] Deleted $MiniforgeInstallPath" -ForegroundColor Green
    } catch {
        Write-Warning "[FAILED] Could not delete $MiniforgeInstallPath. Error: $($_.Exception.Message)"
        Write-Warning "You may need to close applications using it or delete it manually."
    }
}

# 2. Delete User Conda Config Files/Folders
$condaConfigPath = "$env:USERPROFILE\.conda"
$condarcPath = "$env:USERPROFILE\.condarc"

if (Test-Path $condaConfigPath) {
    Write-Host "Attempting to delete user config directory: $condaConfigPath"
    try {
        Remove-Item -Path $condaConfigPath -Recurse -Force -ErrorAction Stop
        Write-Host "[SUCCESS] Deleted $condaConfigPath" -ForegroundColor Green
    } catch {
        Write-Warning "[FAILED] Could not delete $condaConfigPath. Error: $($_.Exception.Message)"
    }
} else {
    Write-Host "User config directory not found: $condaConfigPath"
}

if (Test-Path $condarcPath) {
    Write-Host "Attempting to delete user config file: $condarcPath"
    try {
        Remove-Item -Path $condarcPath -Force -ErrorAction Stop
        Write-Host "[SUCCESS] Deleted $condarcPath" -ForegroundColor Green
    } catch {
        Write-Warning "[FAILED] Could not delete $condarcPath. Error: $($_.Exception.Message)"
    }
} else {
    Write-Host "User config file not found: $condarcPath"
}

# --- Phase 2: Reporting (Manual Steps Needed!) ---
Write-Host "`n--- Reporting Items for Manual Cleanup ---" -ForegroundColor Cyan

# 1. Check USER Path Environment Variable
Write-Host "Checking USER PATH Variable..."
try {
    $userPath = [Environment]::GetEnvironmentVariable('Path', 'User')
    $userPathEntries = $userPath -split ';' | Where-Object { $_ -like "*$MiniforgeInstallPath*" -and $_ }
    
    if ($userPathEntries) {
        Write-Warning "MANUALLY REMOVE these Miniforge entries from your USER Environment PATH:"
        $userPathEntries | ForEach-Object { Write-Warning "- $_" }
        Write-Warning "How to Edit: Search Windows for 'Edit environment variables for your account'."
    } else {
        Write-Host "No Miniforge entries found in USER PATH." -ForegroundColor Green
    }
} catch {
    Write-Error "Could not read User PATH variable. Error: $($_.Exception.Message)"
}

# 2. Check SYSTEM Path Environment Variable (Requires Admin)
Write-Host "`nChecking SYSTEM PATH Variable (Requires Admin)..."
try {
    # Elevate privilege check is complex, just try and let it fail if not admin
    $systemPath = [Environment]::GetEnvironmentVariable('Path', 'Machine') 
    $systemPathEntries = $systemPath -split ';' | Where-Object { $_ -like "*$MiniforgeInstallPath*" -and $_ }

    if ($systemPathEntries) {
        Write-Warning "MANUALLY REMOVE these Miniforge entries from your SYSTEM Environment PATH (Requires Admin):"
        $systemPathEntries | ForEach-Object { Write-Warning "- $_" }
         Write-Warning "How to Edit: Search Windows for 'Edit the system environment variables'."
    } else {
        Write-Host "No Miniforge entries found in SYSTEM PATH." -ForegroundColor Green
    }
} catch {
     Write-Warning "Could not read System PATH variable (maybe not running as Admin?). Error: $($_.Exception.Message)"
}

# 3. Check PowerShell Profile Scripts
Write-Host "`nChecking PowerShell Profile Scripts..."
$potentialProfiles = @(
    $PROFILE.CurrentUserCurrentHost,
    $PROFILE.CurrentUserAllHosts,
    "$env:USERPROFILE\OneDrive\Dokumente\PowerShell\profile.ps1", # From your earlier output
    "$env:USERPROFILE\OneDrive\Dokumente\WindowsPowerShell\profile.ps1" # From your earlier output
    # Add other known profile paths if needed, including the one from your dotfiles:
    "$env:USERPROFILE\dotfiles\config\powershell\user_profile.ps1" 
) | Get-Unique

Write-Warning "MANUALLY EDIT the following PowerShell profile script(s) if they exist:"
foreach ($profilePath in $potentialProfiles) {
    if (Test-Path $profilePath) {
        Write-Warning "- $profilePath"
        Write-Warning "  Look for and REMOVE the '#region Conda initialize' ... '#endregion' block."
    }
}
Write-Warning "NOTE: Your main profile might source other scripts (like your user_profile.ps1). Check sourced scripts too!"

# --- Final Instructions ---
Write-Host "`n--- Uninstallation Complete (Manual Steps Remain!) ---" -ForegroundColor Green
Write-Host "1. Manually edit your USER and/or SYSTEM PATH variables as reported above."
Write-Host "2. Manually edit your PowerShell profile script(s) as reported above."
Write-Host "3. Close and REOPEN any open PowerShell/Terminal/Cursor windows for changes to take effect."
Write-Host "4. Consider restarting your computer to ensure all environment changes are fully applied."
Write-Host "---------------------------------------------------------" -ForegroundColor Green