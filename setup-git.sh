#!/bin/bash
# Git configuration with delta integration

set -e

echo "=================================="
echo "Git Configuration Setup"
echo "=================================="
echo ""

# Backup existing gitconfig
if [ -f "$HOME/.gitconfig" ]; then
    echo "Backing up existing .gitconfig..."
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Check if delta is installed
if ! command -v delta &> /dev/null; then
    echo "Warning: delta is not installed. Install it for better git diffs."
    echo "See: https://github.com/dandavison/delta"
    echo ""
fi

# Add delta configuration to gitconfig
echo "Configuring git with delta integration..."

git config --global include.path "$HOME/.config/delta/themes.gitconfig"
git config --global core.pager "delta"
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.features "github-dark"

# Set editor to neovim if available
if command -v nvim &> /dev/null; then
    git config --global core.editor "nvim"
fi

# Other recommended git settings
echo "Setting additional git configurations..."

# Default branch name
git config --global init.defaultBranch "main"

# Pull rebase by default
git config --global pull.rebase true

# Auto-setup remote tracking
git config --global push.autoSetupRemote true

# Better conflict markers
git config --global merge.conflictStyle "diff3"

# Prune on fetch
git config --global fetch.prune true

# Show more context in diffs
git config --global diff.context 3

echo ""
echo "=================================="
echo "Git Configuration Complete!"
echo "=================================="
echo ""
echo "Configured settings:"
git config --global --get-regexp "(core.pager|delta|core.editor|init.defaultBranch)"
echo ""
