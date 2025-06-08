#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[0;32m'
RED='\033[1;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info()    { echo -e "${GREEN}ℹ️  $*${NC}"; }
warn()    { echo -e "${YELLOW}⚠️  $*${NC}"; }
error()   { echo -e "${RED}🛑 $*${NC}" >&2; exit 1; }

info "🔧 Starting MINIMAL Linux bootstrap script (Le Potato/Armbian/Termux)..."

# Detect Termux or standard Linux
detect_env() {
  if grep -qiE 'android|termux' /proc/version 2>/dev/null || [ -n "${PREFIX:-}" ] && [[ "$PREFIX" == *com.termux* ]]; then
    echo "termux"
  else
    echo "linux"
  fi
}

ENV_TYPE=$(detect_env)
info "Detected environment: $ENV_TYPE"

# Set package manager and sudo usage
if [ "$ENV_TYPE" = "termux" ]; then
  PKG="pkg"
  SUDO=""
else
  PKG="apt"
  SUDO="sudo"
fi

# Minimal essential packages
ESSENTIAL_PKGS=(curl wget git unzip zoxide ncdu bat fzf ripgrep neofetch zsh \
  eza lsd fd-find sd xh gitui rga onefetch vivid dust duf delta as-tree bottom broot dua just atuin bandwhich hyperfine miniserve dog choose yazi lazygit jq tldr htop tree lsof python3 ipython)
# fastfetch is not always available, try to install if possible

install_packages() {
  info "📦 Installing minimal essential packages..."
  if [ "$ENV_TYPE" = "termux" ]; then
    $PKG update -y
    $PKG upgrade -y
    $PKG install -y ${ESSENTIAL_PKGS[*]} || warn "Some packages may not be available in Termux. Skipping missing."
    $PKG install -y proot || true # for some Termux setups
    $PKG install -y fastfetch || warn "fastfetch not available in Termux. Skipping."
    $PKG install -y bat-extras || warn "bat-extras not available in Termux. Skipping."
  else
    $SUDO $PKG update
    $SUDO $PKG install -y ${ESSENTIAL_PKGS[*]} || warn "Some packages may not be available. Skipping missing."
    $SUDO $PKG install -y fastfetch || warn "fastfetch not available. Skipping."
    $SUDO $PKG install -y bat-extras || warn "bat-extras not available. Skipping."
  fi
}

install_ohmyzsh() {
  if command -v zsh &>/dev/null; then
    info "✨ Installing Oh My Zsh..."
    export RUNZSH=no
    export CHSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || warn "Oh My Zsh installation failed."
  else
    warn "Zsh not found. Skipping Oh My Zsh."
  fi
}

install_ohmyposh() {
  info "✨ Installing Oh My Posh for Bash..."
  curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin || warn "Oh My Posh installation failed."
}

install_chezmoi() {
  info "🏗️  Installing chezmoi..."
  if [ "$ENV_TYPE" = "termux" ]; then
    # chezmoi is available via pkg in Termux, but may be outdated
    $PKG install -y chezmoi || (
      sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" || warn "chezmoi installation failed."
    )
  else
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" || warn "chezmoi installation failed."
  fi
}

apply_dotfiles() {
  if command -v chezmoi &>/dev/null; then
    info "📝 Applying chezmoi configuration..."
    chezmoi init --source="$PWD" || warn "chezmoi init failed."
    chezmoi apply || warn "chezmoi apply failed."
  else
    warn "chezmoi not found. Skipping dotfiles application."
  fi
}

main() {
  install_packages
  if command -v zsh &>/dev/null; then
    install_ohmyzsh
    chsh -s $(command -v zsh) || warn "Failed to set zsh as default shell."
  else
    install_ohmyposh
  fi
  install_chezmoi
  apply_dotfiles
  info "🚀 Minimal bootstrap complete! Please restart your terminal or run 'zsh' to start using your new environment."
  info "✅ Installed tools: ${ESSENTIAL_PKGS[*]} fastfetch bat-extras"
}

main 