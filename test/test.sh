#!/usr/bin/env bash
set -euo pipefail

info()    { echo -e "\033[1;34mℹ️  $*\033[0m"; }
success() { echo -e "\033[1;32m✅ $*\033[0m"; }
warn()    { echo -e "\033[1;33m⚠️  $*\033[0m"; }
error()   { echo -e "\033[1;31m🛑 $*\033[0m" >&2; exit 1; }

info "Testing dotfiles setup..."

export PATH="/usr/local/bin:$PATH"
export HOME="${HOME:-/root}"

# Check chezmoi version
if command -v chezmoi >/dev/null 2>&1; then
  version=$(chezmoi --version | awk '{print $3}')
  info "Detected chezmoi version: $version"
else
  warn "chezmoi not found in PATH."
fi

# Install chezmoi if missing
CHEZMOI_VERSION="v2.37.0"
if ! command -v chezmoi >/dev/null 2>&1; then
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin --version $CHEZMOI_VERSION || error "chezmoi installation failed. See https://www.chezmoi.io for help."
fi

# Init chezmoi if needed
if [ ! -d "$HOME/.local/share/chezmoi" ]; then
  chezmoi init --source=. || error "chezmoi init failed.\nHint: Check your .chezmoi.toml and repository structure. Try running 'chezmoi doctor' for diagnostics."
fi

chezmoi apply || error "chezmoi apply failed.\nHint: Check your .chezmoi.toml for syntax errors, run 'chezmoi diff' and 'chezmoi doctor' for troubleshooting. See https://www.chezmoi.io/user-guide/ for help."

# Run full bootstrap install script (simulate CI)
if [ -x /dotfiles/bootstrap/scripts/unix/install.sh ]; then
  info "Running full bootstrap install..."
  CI=1 /dotfiles/bootstrap/scripts/unix/install.sh
fi

# Run LSP install script directly
if [ -x /dotfiles/bootstrap/scripts/unix/install-lsp-servers.sh ]; then
  info "Running LSP install script..."
  /dotfiles/bootstrap/scripts/unix/install-lsp-servers.sh
fi

# Source bash/zsh profile and test functions
for shell in bash zsh; do
  info "Testing $shell profile..."
  if command -v $shell >/dev/null 2>&1; then
    $shell -c "source /dotfiles/config/$shell/${shell}rc; type ll; ll; type mkcd; mkcd testdir && cd .."
  else
    warn "$shell not installed, skipping."
  fi
done

# Test nvim, git, etc.
command -v nvim && nvim --version
command -v git && git --version

# Test conda if present
if command -v conda; then
  conda --version
  conda info
fi

# Test oh-my-posh if present
if command -v oh-my-posh; then
  oh-my-posh --version
fi

# Run Neovim Plenary tests (headless)
if command -v nvim; then
  info "Running Neovim Plenary tests..."
  nvim --headless -c "PlenaryBustedDirectory lua/custom/tests/ {minimal_init = 'lua/minimal_init.lua'}"
fi

success "All tests passed!" 