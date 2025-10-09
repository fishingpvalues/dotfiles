#!/bin/bash
# Complete setup script - runs all setup steps

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Complete Dotfiles Setup"
echo "=========================================="
echo ""

# Make scripts executable
chmod +x "$SCRIPT_DIR"/*.sh 2>/dev/null || true

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

echo "Detected OS: $OS"
echo ""

# Step 1: Install tools
echo "Step 1/4: Installing tools..."
echo "----------------------------"
if [ "$OS" = "macos" ]; then
    bash "$SCRIPT_DIR/install-macos.sh"
else
    bash "$SCRIPT_DIR/install-linux.sh"
fi

# Step 2: Create config symlink
echo ""
echo "Step 2/4: Setting up config directory..."
echo "----------------------------------------"
if [ ! -L "$HOME/.config" ] || [ "$(readlink "$HOME/.config")" != "$SCRIPT_DIR/.config" ]; then
    if [ -d "$HOME/.config" ] && [ ! -L "$HOME/.config" ]; then
        echo "Backing up existing .config directory..."
        mv "$HOME/.config" "$HOME/.config.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    echo "Creating symlink: ~/.config -> $SCRIPT_DIR/.config"
    ln -sf "$SCRIPT_DIR/.config" "$HOME/.config"
else
    echo ".config already linked correctly"
fi

# Step 3: Setup shell integration
echo ""
echo "Step 3/4: Setting up shell integration..."
echo "-----------------------------------------"
bash "$SCRIPT_DIR/setup-shell.sh"

# Step 4: Setup git
echo ""
echo "Step 4/4: Setting up git configuration..."
echo "-----------------------------------------"
bash "$SCRIPT_DIR/setup-git.sh"

# Setup Neovim
echo ""
echo "Setting up Neovim..."
echo "-------------------"
if command -v nvim &> /dev/null; then
    echo "Neovim will install plugins on first run."
    echo "Run 'nvim' to trigger plugin installation."
fi

# Setup Tmux
echo ""
echo "Setting up Tmux..."
echo "-----------------"
if command -v tmux &> /dev/null; then
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        echo "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
        echo "Tmux plugins will install when you start tmux and press Ctrl-a + I"
    else
        echo "TPM already installed"
    fi
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Restart your terminal"
echo "2. Run 'nvim' to install Neovim plugins"
echo "3. Run 'tmux' and press Ctrl-a + I to install tmux plugins"
echo "4. Configure your terminal to use a Nerd Font"
echo ""
echo "Useful commands:"
echo "  lg       - lazygit"
echo "  ld       - lazydocker"
echo "  fm       - yazi file manager"
echo "  btop     - system monitor"
echo "  z <path> - quick jump with zoxide"
echo "  Ctrl+R   - search history with atuin"
echo ""
