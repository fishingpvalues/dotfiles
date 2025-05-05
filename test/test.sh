#!/usr/bin/env bash
set -euo pipefail

echo "Testing dotfiles setup..."

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

echo "All tests passed!" 