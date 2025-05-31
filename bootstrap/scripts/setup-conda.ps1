# PowerShell script to configure conda environments and write .condarc for Windows
# Usage: .\setup-conda.ps1

$condaEnvDir = "$env:USERPROFILE\.conda\envs"
$miniforgeEnvDir = "$env:USERPROFILE\miniforge3\envs"
$condarcPath = "$env:USERPROFILE\.condarc"

# Ensure directories exist
New-Item -ItemType Directory -Force -Path $condaEnvDir | Out-Null

# Write .condarc
@"
envs_dirs:
  - $condaEnvDir
  - $miniforgeEnvDir
"@ | Set-Content -Path $condarcPath -Encoding UTF8

Write-Host "Configured conda to store environments in $condaEnvDir and $miniforgeEnvDir."

# Optionally, ensure conda initialization in PowerShell profile
$profilePath = $PROFILE
if (Test-Path $profilePath) {
    $profileContent = Get-Content $profilePath -Raw
    if ($profileContent -notmatch 'conda initialize') {
        Write-Host "Adding conda initialization to $profilePath"
        $condaInit = & "$env:USERPROFILE\miniforge3\Scripts\conda.exe" init powershell | Out-String
        Write-Host $condaInit
    }
}
Write-Host "Conda initialization ensured in PowerShell profile." 