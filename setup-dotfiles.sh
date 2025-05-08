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