#!/bin/bash
# Linux installation script

set -e

echo "=================================="
echo "Dotfiles Installation for Linux"
echo "=================================="
echo ""

# Detect package manager
if command -v apt-get &> /dev/null; then
    PKG_MANAGER="apt"
    INSTALL_CMD="sudo apt-get install -y"
    UPDATE_CMD="sudo apt-get update"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    INSTALL_CMD="sudo pacman -S --noconfirm"
    UPDATE_CMD="sudo pacman -Sy"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    INSTALL_CMD="sudo dnf install -y"
    UPDATE_CMD="sudo dnf check-update"
else
    echo "Unsupported package manager. Please install tools manually."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"
echo ""

# Update system
echo "Updating package database..."
$UPDATE_CMD

# Core tools
echo "Installing core tools..."
$INSTALL_CMD neovim tmux git build-essential curl wget

# Install tools that may need manual download
echo ""
echo "Some tools need to be installed from GitHub releases or other sources:"
echo ""
echo "Please install the following manually or via your package manager:"
echo "  - bat: https://github.com/sharkdp/bat/releases"
echo "  - fd: https://github.com/sharkdp/fd/releases"
echo "  - ripgrep: https://github.com/BurntSushi/ripgrep/releases"
echo "  - lazygit: https://github.com/jesseduffield/lazygit/releases"
echo "  - lazydocker: https://github.com/jesseduffield/lazydocker/releases"
echo "  - delta: https://github.com/dandavison/delta/releases"
echo "  - yazi: https://github.com/sxyazi/yazi/releases"
echo "  - zellij: https://github.com/zellij-org/zellij/releases"
echo "  - helix: https://github.com/helix-editor/helix/releases"
echo ""

# Starship
echo "Installing Starship..."
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Atuin
echo "Installing Atuin..."
if ! command -v atuin &> /dev/null; then
    bash <(curl https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh)
fi

# Zoxide
echo "Installing Zoxide..."
if ! command -v zoxide &> /dev/null; then
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

# btop (if available in repos)
if [ "$PKG_MANAGER" = "apt" ]; then
    $INSTALL_CMD btop || echo "btop not available, install from: https://github.com/aristocratos/btop"
elif [ "$PKG_MANAGER" = "pacman" ]; then
    $INSTALL_CMD btop
fi

echo ""
echo "=================================="
echo "Installation Complete!"
echo "=================================="
echo ""
echo "Next steps:"
echo "1. Install remaining tools from GitHub releases"
echo "2. Run: ./setup-shell.sh"
echo "3. Install a Nerd Font from https://www.nerdfonts.com/"
echo ""
