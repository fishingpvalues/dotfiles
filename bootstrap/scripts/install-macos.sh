#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()    { echo -e "${GREEN}ℹ️  $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
error()   { echo -e "${RED}🛑 $*${NC}" >&2; exit 1; }

info "🍏 Starting macOS bootstrap script..."

check_chezmoi_version() {
  if command -v chezmoi &>/dev/null; then
    local version
    version=$(chezmoi --version | awk '{print $3}')
    info "Detected chezmoi version: $version"
  else
    warn "chezmoi not found in PATH after install."
  fi
}

# Install Homebrew if not present
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Homebrew installation failed. See https://brew.sh for help."
fi

export PATH="/usr/local/bin:$PATH"
export HOME="${HOME:-/Users/runner}"

# Install chezmoi if missing
if ! command -v chezmoi >/dev/null 2>&1; then
  info "Installing chezmoi..."
  brew install chezmoi || error "chezmoi installation failed. See https://www.chezmoi.io for help."
else
  info "chezmoi is already installed."
fi
check_chezmoi_version

# Install atool if missing
if ! command -v atool >/dev/null 2>&1; then
  info "Installing atool (archive extraction tool for extract alias)..."
  brew install atool || warn "atool installation failed. You may not be able to use the extract alias."
else
  info "atool is already installed."
fi
# atool: archive extraction tool (for extract alias)

# Init chezmoi if needed
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  info "Initializing chezmoi with local source..."
  chezmoi init --source=. || error "chezmoi init failed.\nHint: Check your .chezmoi.toml and repository structure. Try running 'chezmoi doctor' for diagnostics."
fi

info "Applying chezmoi configuration..."
chezmoi apply || error "chezmoi apply failed.\nHint: Check your .chezmoi.toml for syntax errors, run 'chezmoi diff' and 'chezmoi doctor' for troubleshooting. See https://www.chezmoi.io/user-guide/ for help."

# Install all packages from Brewfile
info "Installing packages from Brewfile..."
brew bundle --file="$(dirname "$0")/../../dot_Brewfile" || warn "Some packages may not have installed correctly."

# Install Python security tools: bandit, safety
info "🔒 Installing Python security tools: bandit, safety..."
if command -v pipx >/dev/null 2>&1; then
  pipx install bandit || warn "Failed to install bandit with pipx."
  pipx install safety || warn "Failed to install safety with pipx."
else
  warn "pipx not found, falling back to pip3 --user. Consider installing pipx for isolated Python CLI tools."
  pip3 install --user bandit || warn "Failed to install bandit with pip3."
  pip3 install --user safety || warn "Failed to install safety with pip3."
fi

# Install 2025 SOTA CLI tools
# Ensure Rust is up to date for eza
min_rust_version="1.82.0"
if ! command -v rustc >/dev/null 2>&1; then
  info "Rust not found. Installing Rust via rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || warn "Rust installation failed. See https://rustup.rs for help."
  export PATH="$HOME/.cargo/bin:$PATH"
  source "$HOME/.cargo/env"
  rustup update stable
else
  current_version=$(rustc --version | awk '{print $2}')
  if [ "$(printf '%s\n' "$min_rust_version" "$current_version" | sort -V | head -n1)" != "$min_rust_version" ]; then
    info "Rust is up to date (rustc $current_version)"
  else
    info "Rust version $current_version is too old. Updating Rust via rustup..."
    rustup update stable || warn "Rust update failed. See https://rustup.rs for help."
  fi
fi

info "Installing 2025 SOTA CLI tools..."
brew install ghostty mise jujutsu lsd trash-cli || true
# eza: always use cargo with --locked and require rustc >= 1.82.0
if command -v cargo >/dev/null 2>&1; then
  current_version=$(rustc --version | awk '{print $2}')
  if [ "$(printf '%s\n' "$min_rust_version" "$current_version" | sort -V | head -n1)" != "$min_rust_version" ]; then
    info "Building and installing eza (with --locked)..."
    cargo install eza --locked || warn "Failed to install eza. Ensure Rust is up to date (rustc >= $min_rust_version)."
  else
    warn "rustc $min_rust_version or newer is required for eza. Current: $current_version. Please update Rust."
  fi
else
  warn "Cargo not found. Skipping eza install."
fi
pip3 install --user code2 bashbuddy || true

# Setup conda
if [ -f "$(dirname "$0")/setup-conda.sh" ]; then
  info "Running conda setup script..."
  bash "$(dirname "$0")/setup-conda.sh" || warn "Conda setup script failed."
fi

# Ensure pipx is installed
info "🔧 Ensuring pipx is installed..."
if ! command -v pipx >/dev/null 2>&1; then
  brew install pipx || warn "Failed to install pipx with brew. Trying pip3."
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v pipx >/dev/null 2>&1; then
    pip3 install --user pipx || error "Failed to install pipx."
    export PATH="$HOME/.local/bin:$PATH"
  fi
fi
if ! command -v pipx >/dev/null 2>&1; then
  error "pipx installation failed."
fi

# Remove ty installation (if present)
# (No explicit ty install found, so nothing to remove)

# Install uv and nushell (Rust-powered tools)
info "🦀 Installing Rust-powered tools: uv, nushell..."
cargo install uv --locked || warn "Failed to install uv."
brew install nushell || cargo install nu --locked || warn "Failed to install nushell."

# Install SOTA Python linters/formatters
info "🧹 Installing SOTA Python linters/formatters..."
tools=(ruff black isort pyright mypy flake8 pylint autoflake bandit safety yapf docformatter pydocstyle interrogate pyupgrade pre-commit)
for tool in "${tools[@]}"; do
  if command -v pipx >/dev/null 2>&1; then
    pipx install "$tool" || warn "Failed to install $tool with pipx."
  else
    pip3 install --user "$tool" || warn "Failed to install $tool with pip3."
  fi
fi

success_msg="${GREEN}🚀 macOS bootstrap complete!${NC}\nIf you encounter issues, try:\n  chezmoi doctor\n  chezmoi diff\n  chezmoi apply -v\nSee https://www.chezmoi.io/user-guide/ for more help."
echo -e "$success_msg" 