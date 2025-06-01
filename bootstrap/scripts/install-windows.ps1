# PowerShell install script for Windows

function Info($msg)    { Write-Host "ℹ️  $msg" -ForegroundColor Cyan }
function Success($msg) { Write-Host "✅ $msg" -ForegroundColor Green }
function Warn($msg)    { Write-Host "⚠️  $msg" -ForegroundColor Yellow }
function ErrorExit($msg) { Write-Host "🛑 $msg" -ForegroundColor Red; exit 1 }

Info "🪟 Starting Windows bootstrap script..."

if (-not $env:HOME) { $env:HOME = $env:USERPROFILE }

# Helper: Check chezmoi version
function Check-ChezmoiVersion {
    if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
        $version = chezmoi --version | Select-String -Pattern '\d+\.\d+\.\d+' | ForEach-Object { $_.Matches[0].Value }
        Info "Detected chezmoi version: $version"
    } else {
        Warn "chezmoi not found in PATH after install."
    }
}

# Install scoop if not present
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Info "Installing scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    irm get.scoop.sh | iex
    if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
        ErrorExit "Scoop installation failed. See https://scoop.sh for help."
    }
}

# Remove any system chezmoi first
if (Get-Command chezmoi -ErrorAction SilentlyContinue) {
    $sys_path = (Get-Command chezmoi).Source
    if ($sys_path -like '*scoop*') {
        Info "Removing system chezmoi ($sys_path)..."
        scoop uninstall chezmoi
    }
}
$env:PATH = "$HOME/.local/bin;" + $env:PATH

$CHEZMOI_VERSION = 'v2.37.0'
# Install chezmoi if not present or outdated
if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue) -or ((chezmoi --version | Select-String -Pattern '\d+\.\d+\.\d+' | ForEach-Object { $_.Matches[0].Value }).Split('.')[0] -ne 2)) {
    Info "Installing chezmoi $CHEZMOI_VERSION..."
    irm https://get.chezmoi.io | iex; chezmoi upgrade --version $CHEZMOI_VERSION
    if (-not (Get-Command chezmoi -ErrorAction SilentlyContinue)) {
        ErrorExit "chezmoi installation failed. See https://www.chezmoi.io for help."
    }
} else {
    $version = chezmoi --version | Select-String -Pattern '\d+\.\d+\.\d+' | ForEach-Object { $_.Matches[0].Value }
    Info "chezmoi v$version is already installed."
}
Check-ChezmoiVersion

# Init chezmoi if needed
$chezmoiData = Join-Path $env:HOME ".local\share\chezmoi"
if (-not (Test-Path $chezmoiData)) {
    Info "Initializing chezmoi with local source..."
    chezmoi init --source=.
    if ($LASTEXITCODE -ne 0) {
        ErrorExit "chezmoi init failed.`nHint: Check your .chezmoi.toml and repository structure. Try running 'chezmoi doctor' for diagnostics."
    }
}

Info "Applying chezmoi configuration..."
chezmoi apply
if ($LASTEXITCODE -ne 0) {
    ErrorExit "chezmoi apply failed.`nHint: Check your .chezmoi.toml for syntax errors, run 'chezmoi diff' and 'chezmoi doctor' for troubleshooting. See https://www.chezmoi.io/user-guide/ for help."
}

# Setup conda
$condaScript = Join-Path $PSScriptRoot 'setup-conda.ps1'
if (Test-Path $condaScript) {
    Info "Running conda setup script..."
    & $condaScript
    if ($LASTEXITCODE -ne 0) {
        Warn "Conda setup script failed."
    }
}

# Install 2025 SOTA CLI tools
scoop install ghostty mise jujutsu lsd trash-cli
pip install --user code2 bashbuddy

# Install Python security tools: bandit, safety
if (Get-Command pipx -ErrorAction SilentlyContinue) {
    Info "Installing bandit and safety with pipx..."
    pipx install bandit
    if ($LASTEXITCODE -ne 0) { Warn "Failed to install bandit with pipx." }
    pipx install safety
    if ($LASTEXITCODE -ne 0) { Warn "Failed to install safety with pipx." }
} else {
    Warn "pipx not found, falling back to pip --user. Consider installing pipx for isolated Python CLI tools."
    pip install --user bandit
    if ($LASTEXITCODE -ne 0) { Warn "Failed to install bandit with pip." }
    pip install --user safety
    if ($LASTEXITCODE -ne 0) { Warn "Failed to install safety with pip." }
}

# Ensure Rust is up to date for eza
$minRustVersion = [Version]'1.82.0'
function Get-RustVersion {
    if (Get-Command rustc -ErrorAction SilentlyContinue) {
        $ver = rustc --version | Select-String -Pattern '\d+\.\d+\.\d+' | ForEach-Object { $_.Matches[0].Value }
        if ($ver) { return [Version]$ver }
    }
    return $null
}

$rver = Get-RustVersion
if (-not $rver -or $rver -lt $minRustVersion) {
    Info "Installing or updating Rust (requires rustc >= 1.82.0 for eza)..."
    scoop install rustup
    rustup update stable
    $env:PATH += ";$env:USERPROFILE\.cargo\bin"
    $rver = Get-RustVersion
    if (-not $rver -or $rver -lt $minRustVersion) {
        ErrorExit "Rust install/update failed or version too old. rustc >= 1.82.0 required."
    }
} else {
    Info "Rust is up to date (rustc $rver)"
}

# Install eza using cargo with --locked
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    Info "Installing eza (with --locked)..."
    cargo install eza --locked
    if ($LASTEXITCODE -ne 0) {
        Warn "Failed to install eza. Ensure Rust is up to date (rustc >= 1.82.0)."
    }
} else {
    Warn "Cargo not found. Skipping eza install."
}

# Ensure pipx is installed
if (-not (Get-Command pipx -ErrorAction SilentlyContinue)) {
    Info "Installing pipx with scoop..."
    scoop install pipx
    if (-not (Get-Command pipx -ErrorAction SilentlyContinue)) {
        Warn "Failed to install pipx with scoop. Trying pip..."
        pip install --user pipx
        $env:PATH += ";$env:USERPROFILE\.local\bin"
    }
}
if (-not (Get-Command pipx -ErrorAction SilentlyContinue)) {
    ErrorExit "pipx installation failed."
}

# Remove ty installation (if present)
# (No explicit ty install found, so nothing to remove)

# Install uv and nushell (Rust-powered tools)
Info "Installing Rust-powered tools: uv, nushell..."
if (Get-Command cargo -ErrorAction SilentlyContinue) {
    cargo install uv --locked
    if ($LASTEXITCODE -ne 0) { Warn "Failed to install uv." }
    scoop install nushell
    if (-not (Get-Command nu -ErrorAction SilentlyContinue)) {
        cargo install nu --locked
        if ($LASTEXITCODE -ne 0) { Warn "Failed to install nushell." }
    }
} else {
    Warn "Cargo not found. Skipping uv and nushell install."
}

# Install SOTA Python linters/formatters
Info "Installing SOTA Python linters/formatters..."
$tools = @('ruff','black','isort','pyright','mypy','flake8','pylint','autoflake','bandit','safety','yapf','docformatter','pydocstyle','interrogate','pyupgrade','pre-commit')
foreach ($tool in $tools) {
    if (Get-Command pipx -ErrorAction SilentlyContinue) {
        pipx install $tool
        if ($LASTEXITCODE -ne 0) { Warn "Failed to install $tool with pipx." }
    } else {
        pip install --user $tool
        if ($LASTEXITCODE -ne 0) { Warn "Failed to install $tool with pip." }
    }
}

Success "🚀 Windows bootstrap complete!`nIf you encounter issues, try:`n  chezmoi doctor`n  chezmoi diff`n  chezmoi apply -v`nSee https://www.chezmoi.io/user-guide/ for more help."