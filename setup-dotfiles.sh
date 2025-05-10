#!/usr/bin/env bash
# Thin entry point for dotfiles setup (Unix)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check for submodules
if [ ! -d "$DOTFILES_DIR/bootstrap/scripts" ]; then
  echo "[ERROR] The bootstrap submodule is missing. Run:\n  git submodule update --init --recursive" >&2
  exit 1
fi

# Delegate to the main Unix install script
exec "$DOTFILES_DIR/bootstrap/scripts/unix/install.sh" "$@"

# Install ty Python type checker
pip install --user ty

# Set up ty config if present
if [ -f "$DOTFILES_DIR/config/ty/ty.toml" ]; then
  mkdir -p "$HOME/.config/ty"
  cp "$DOTFILES_DIR/config/ty/ty.toml" "$HOME/.config/ty/ty.toml"
fi

# Ensure Yazi and ya are installed (ya is usually bundled with yazi)
if ! command -v yazi >/dev/null 2>&1; then
  echo "[ERROR] Yazi is not installed. Please install yazi from https://yazi-rs.github.io/docs/installation/"
  exit 1
fi
if ! command -v ya >/dev/null 2>&1; then
  echo "[ERROR] ya (Yazi assistant) is not installed. It should be bundled with yazi. Please check your installation."
  exit 1
fi

# Set up Yazi config
yazi_config_dir="$HOME/.config/yazi"
mkdir -p "$yazi_config_dir"
cp -f "$DOTFILES_DIR/config/yazi/yazi.toml" "$yazi_config_dir/yazi.toml"

# Install Yazi plugins using ya pack
cd "$yazi_config_dir"
ya pack -a eza-preview.yazi glow.yazi rich-preview.yazi hexyl.yazi lsar.yazi mediainfo.yazi \
  bunny.yazi easyjump.yazi projects.yazi compress.yazi diff.yazi system-clipboard.yazi \
  dual-pane.yazi starship.yazi lazygit.yazi DreamMaoMao/git.yazi fm-nvim mikavilpas/yazi.nvim
cd -

# Install ya-pack for Yazi plugin management
if ! command -v ya-pack >/dev/null 2>&1; then
  cargo install --git https://github.com/sxyazi/ya-pack
fi 