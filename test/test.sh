#!/usr/bin/env bash
set -euo pipefail

echo "Testing dotfiles setup..."

# Run full bootstrap install script (simulate CI)
if [ -x /dotfiles/bootstrap/scripts/unix/install.sh ]; then
  echo "Running full bootstrap install..."
  CI=1 /dotfiles/bootstrap/scripts/unix/install.sh
fi

# Run LSP install script directly
if [ -x /dotfiles/bootstrap/scripts/unix/install-lsp-servers.sh ]; then
  echo "Running LSP install script..."
  /dotfiles/bootstrap/scripts/unix/install-lsp-servers.sh
fi

# Source bash/zsh profile and test functions
for shell in bash zsh; do
  echo "Testing $shell profile..."
  if command -v $shell >/dev/null 2>&1; then
    $shell -c "source /dotfiles/config/$shell/${shell}rc; type ll; ll; type mkcd; mkcd testdir && cd .."
  else
    echo "$shell not installed, skipping."
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
  echo "Running Neovim Plenary tests..."
  nvim --headless -c "PlenaryBustedDirectory lua/custom/tests/ {minimal_init = 'lua/minimal_init.lua'}"
fi

echo "All tests passed!" 