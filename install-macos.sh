#!/bin/bash
# macOS installation script using Homebrew

set -e

echo "=================================="
echo "Dotfiles Installation for macOS"
echo "=================================="
echo ""

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Update Homebrew
echo "Updating Homebrew..."
brew update

# Install Nerd Fonts
echo "Installing JetBrainsMono Nerd Font..."
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font || echo "Font already installed"

# Core tools
echo "Installing core tools..."
brew install neovim tmux git

# Modern CLI replacements
echo "Installing modern CLI tools..."
brew install bat fd ripgrep fzf git-delta

# TUI applications
echo "Installing TUI applications..."
brew install lazygit lazydocker btop

# Shell enhancements
echo "Installing shell enhancements..."
brew install starship zoxide atuin

# File manager
echo "Installing yazi file manager..."
brew install yazi

# Alternative multiplexer
echo "Installing zellij..."
brew install zellij

# Helix editor
echo "Installing helix editor..."
brew install helix

echo ""
echo "=================================="
echo "Installation Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Run: ./setup-shell.sh"
echo "2. Configure your terminal to use JetBrainsMono Nerd Font"
echo ""
