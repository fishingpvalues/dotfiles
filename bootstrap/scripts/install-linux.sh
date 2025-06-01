#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()    { echo -e "${GREEN}ℹ️  $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
error()   { echo -e "${RED}🛑 $*${NC}" >&2; exit 1; }

info "🔧 Starting Linux bootstrap script..."

# Helper: Check chezmoi version
check_chezmoi_version() {
  if command -v chezmoi &>/dev/null; then
    local version
    version=$(chezmoi --version | awk '{print $3}')
    info "Detected chezmoi version: $version"
    # Optionally enforce minimum version here
  else
    warn "chezmoi not found in PATH after install."
  fi
}

install_packages() {
  info "📦 Installing packages via APT..."
  sudo apt update
  sudo apt install -y \
    curl wget git unzip \
    build-essential pkg-config libssl-dev \
    zoxide ncdu bat fzf ripgrep \
    hyperfine fd-find \
    atool || error "Failed to install required packages. Check your network connection and package sources."
  # atool: archive extraction tool (for extract alias)

  # Fix for fdfind vs fd
  if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
    sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd
  fi
}

install_pipx() {
  info "🔧 Ensuring pipx is installed..."
  if ! command -v pipx &>/dev/null; then
    if command -v apt &>/dev/null; then
      sudo apt install -y pipx || warn "Failed to install pipx via apt. Trying pip3."
      export PATH="$HOME/.local/bin:$PATH"
    fi
    if ! command -v pipx &>/dev/null; then
      pip3 install --user pipx || error "Failed to install pipx."
      export PATH="$HOME/.local/bin:$PATH"
    fi
  fi
  if ! command -v pipx &>/dev/null; then
    error "pipx installation failed."
  fi
}

install_rust() {
  # Require rustc 1.82.0 or newer for eza and modern crates
  min_version="1.82.0"
  if ! command -v rustc &> /dev/null; then
    info "🦀 Rust not found. Installing Rust via rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y || error "Rust installation failed. See https://rustup.rs for help."
    export PATH="$HOME/.cargo/bin:$PATH"
    source "$HOME/.cargo/env"
    rustup update stable
  else
    current_version=$(rustc --version | awk '{print $2}')
    if [ "$(printf '%s\n' "$min_version" "$current_version" | sort -V | head -n1)" != "$min_version" ]; then
      info "✅ Rust is up to date (rustc $current_version)"
    else
      info "🦀 Rust version $current_version is too old. Updating Rust via rustup..."
      rustup update stable || error "Rust update failed. See https://rustup.rs for help."
    fi
  fi
}

install_eza() {
  # Always use --locked and require rustc >= 1.82.0
  if ! command -v rustc &> /dev/null; then
    error "Rust is required to build eza. Please install Rust first."
  fi
  current_version=$(rustc --version | awk '{print $2}')
  min_version="1.82.0"
  if [ "$(printf '%s\n' "$min_version" "$current_version" | sort -V | head -n1)" != "$min_version" ]; then
    error "rustc $min_version or newer is required for eza. Current: $current_version. Please update Rust."
  fi
  info "📁 Building and installing eza (with --locked)..."
  cargo install eza --locked || warn "Failed to install eza. Ensure Rust is up to date (rustc >= $min_version)."
}

install_rust_tools() {
  info "🦀 Installing Rust-powered tools: uv, nushell..."
  cargo install uv --locked || warn "Failed to install uv."
  cargo install nu --locked || warn "Failed to install nushell."
}

install_python_linters() {
  info "🧹 Installing SOTA Python linters/formatters..."
  tools=(ruff black isort pyright mypy flake8 pylint autoflake bandit safety yapf docformatter pydocstyle interrogate pyupgrade pre-commit)
  for tool in "${tools[@]}"; do
    if command -v pipx &>/dev/null; then
      pipx install "$tool" || warn "Failed to install $tool with pipx."
    else
      pip3 install --user "$tool" || warn "Failed to install $tool with pip3."
    fi
  done
}

CHEZMOI_VERSION="v2.37.0"
install_chezmoi() {
  # Remove any system or snap chezmoi first
  if command -v chezmoi &>/dev/null; then
    sys_path=$(command -v chezmoi)
    if [[ "$sys_path" == /snap/* || "$sys_path" == /usr/* ]]; then
      info "Removing system/snap chezmoi ($sys_path)..."
      sudo snap remove chezmoi 2>/dev/null || true
      sudo apt remove -y chezmoi 2>/dev/null || true
    fi
  fi
  export PATH="$HOME/.local/bin:$PATH"
  if ! command -v chezmoi &> /dev/null || [[ $(chezmoi --version | awk '{print $3}' | cut -d. -f1) -ne 2 ]]; then
    info "🏗️  Installing chezmoi $CHEZMOI_VERSION..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" --force --version $CHEZMOI_VERSION || error "chezmoi installation failed. See https://www.chezmoi.io for help."
  else
    version=$(chezmoi --version | awk '{print $3}')
    info "✅ chezmoi v$version is already installed."
  fi
  export PATH="$HOME/.local/bin:$PATH"
  check_chezmoi_version
}

install_ohmyposh() {
  info "✨ Installing Oh My Posh..."
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin || warn "Oh My Posh installation failed."
}

main() {
  install_packages
  install_pipx
  install_rust
  install_eza
  install_rust_tools
  install_python_linters
  install_chezmoi
  install_ohmyposh

  # Move to the root of the dotfiles repo if running from a subdirectory
  SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"
  ROOT_DIR="$SCRIPT_DIR"
  while [ ! -f "$ROOT_DIR/.chezmoi.toml" ] && [ ! -d "$ROOT_DIR/.git" ] && [ "$ROOT_DIR" != "/" ]; do
    ROOT_DIR="$(dirname "$ROOT_DIR")"
  done
  if [ -f "$ROOT_DIR/.chezmoi.toml" ] || [ -d "$ROOT_DIR/.git" ]; then
    cd "$ROOT_DIR"
    info "🏠 Changed to dotfiles root directory: $ROOT_DIR"
  else
    warn "Could not find dotfiles root directory (.chezmoi.toml or .git). Continuing in current directory."
  fi

  # Initialize and apply chezmoi config
  if [ ! -d "$ROOT_DIR/.local/share/chezmoi" ]; then
    info "🔄 Initializing chezmoi with fishingpvalues/dotfiles.git..."
    chezmoi init fishingpvalues/dotfiles.git || error "chezmoi init failed.\nHint: Check your network connection and repository URL. Try running 'chezmoi doctor' for diagnostics."
  fi
  info "📝 Applying chezmoi configuration..."
  chezmoi apply || error "chezmoi apply failed.\nHint: Check your .chezmoi.toml for syntax errors, run 'chezmoi diff' and 'chezmoi doctor' for troubleshooting. See https://www.chezmoi.io/user-guide/ for help."

  success_msg="${GREEN}🚀 Bootstrap complete!${NC}\nIf you encounter issues, try:\n  chezmoi doctor\n  chezmoi diff\n  chezmoi apply -v\nSee https://www.chezmoi.io/user-guide/ for more help."
  echo -e "$success_msg"
}

main
