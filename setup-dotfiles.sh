#!/usr/bin/env bash
# 🚀 Dotfiles Setup Entry Point (Unix/Linux/macOS)
set -euo pipefail

# --- Emoji helpers ---
info()    { echo -e "\033[1;34mℹ️  $*\033[0m"; }
success() { echo -e "\033[1;32m✅ $*\033[0m"; }
warn()    { echo -e "\033[1;33m⚠️  $*\033[0m"; }
error()   { echo -e "\033[1;31m🛑 $*\033[0m" >&2; exit 1; }

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

# --- Check for submodules ---
if [ ! -d "$DOTFILES_DIR/bootstrap/scripts" ]; then
  error "The bootstrap submodule is missing.\n  Run: git submodule update --init --recursive"
fi

# --- Install ty Python type checker if available ---
if command -v pip >/dev/null 2>&1; then
  info "Installing ty Python type checker..."
  pip install --user ty || warn "Failed to install ty."
else
  warn "pip not found, skipping ty installation."
fi

# --- Set up ty config if present ---
if [ -f "$DOTFILES_DIR/config/ty/ty.toml" ]; then
  mkdir -p "$HOME/.config/ty"
  cp "$DOTFILES_DIR/config/ty/ty.toml" "$HOME/.config/ty/ty.toml"
  success "ty config installed."
fi

# --- OS Detection and Delegation ---
info "Detecting operating system..."
case "${OSTYPE:-}" in
  darwin*)
    info "Detected macOS. Running macOS installer..."
    bash "$DOTFILES_DIR/bootstrap/scripts/install-macos.sh" "$@"
    ;;
  linux*)
    if [ -f /etc/os-release ]; then
      . /etc/os-release
      info "Detected Linux: $NAME ($ID)"
    else
      warn "Could not detect Linux distribution. Proceeding with generic Linux install."
    fi
    bash "$DOTFILES_DIR/bootstrap/scripts/install-linux.sh" "$@"
    ;;
  *)
    error "Unsupported OS: ${OSTYPE:-unknown}. This script supports macOS and Linux only."
    ;;
esac

# --- Ensure Yazi and ya are installed (AFTER OS install script) ---
if ! command -v yazi >/dev/null 2>&1; then
  warn "Yazi is not installed. Skipping Yazi config and plugin setup. Please install yazi from https://yazi-rs.github.io/docs/installation/ if you want full functionality."
else
  if ! command -v ya >/dev/null 2>&1; then
    warn "ya (Yazi assistant) is not installed. Skipping Yazi plugin setup. It should be bundled with yazi. Please check your installation."
  else
    # --- Set up Yazi config if present ---
    if [ -f "$DOTFILES_DIR/config/yazi/yazi.toml" ]; then
      yazi_config_dir="$HOME/.config/yazi"
      mkdir -p "$yazi_config_dir"
      cp -f "$DOTFILES_DIR/config/yazi/yazi.toml" "$yazi_config_dir/yazi.toml"
      success "Yazi config installed."
    fi
    # --- Install Yazi plugins using ya pack ---
    yazi_config_dir="$HOME/.config/yazi"
    cd "$yazi_config_dir"
    info "Installing Yazi plugins..."
    ya pack -a eza-preview.yazi glow.yazi rich-preview.yazi hexyl.yazi lsar.yazi mediainfo.yazi \
      bunny.yazi easyjump.yazi projects.yazi compress.yazi diff.yazi system-clipboard.yazi \
      dual-pane.yazi starship.yazi lazygit.yazi DreamMaoMao/git.yazi fm-nvim mikavilpas/yazi.nvim || \
      warn "Some Yazi plugins may not have installed correctly."
    cd - >/dev/null
    # --- Install ya-pack for Yazi plugin management if not present ---
    if ! command -v ya-pack >/dev/null 2>&1; then
      if command -v cargo >/dev/null 2>&1; then
        info "Installing ya-pack for Yazi plugin management..."
        cargo install --git https://github.com/sxyazi/ya-pack || warn "Failed to install ya-pack."
      else
        warn "cargo not found, skipping ya-pack installation."
      fi
    fi
  fi
fi

success "Dotfiles setup complete! 🎉" 