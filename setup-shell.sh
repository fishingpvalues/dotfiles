#!/bin/bash
# Shell integration setup for bash/zsh

set -e

echo "=================================="
echo "Shell Integration Setup"
echo "=================================="
echo ""

# Detect shell
SHELL_NAME=$(basename "$SHELL")
if [ "$SHELL_NAME" = "zsh" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL_NAME" = "bash" ]; then
    SHELL_RC="$HOME/.bashrc"
else
    echo "Unsupported shell: $SHELL_NAME"
    echo "Please manually add integrations to your shell config"
    exit 1
fi

echo "Detected shell: $SHELL_NAME"
echo "Config file: $SHELL_RC"
echo ""

# Backup existing config
if [ -f "$SHELL_RC" ]; then
    echo "Backing up existing shell config..."
    cp "$SHELL_RC" "${SHELL_RC}.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create config if it doesn't exist
touch "$SHELL_RC"

# Check if our config is already added
if grep -q "# Modern CLI Tools Integration" "$SHELL_RC" 2>/dev/null; then
    echo "Shell integration already configured!"
    exit 0
fi

# Add our configuration
echo "Adding tool integrations to $SHELL_RC..."

cat >> "$SHELL_RC" << 'EOF'

# ============================================
# Modern CLI Tools Integration (SOTA 2025)
# ============================================

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init SHELL_TYPE)"
fi

# Atuin (shell history)
if command -v atuin &> /dev/null; then
    eval "$(atuin init SHELL_TYPE)"
fi

# Zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init SHELL_TYPE)"

    # Source zoxide environment variables
    [ -f "$HOME/.config/zoxide/zoxide.env" ] && source "$HOME/.config/zoxide/zoxide.env"
fi

# Ripgrep configuration
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# Bat theme
export BAT_THEME="GitHub"

# ============================================
# Aliases for modern tools
# ============================================

# Use modern alternatives (if installed)
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# Quick access to common tools
if command -v lazygit &> /dev/null; then
    alias lg='lazygit'
fi

if command -v lazydocker &> /dev/null; then
    alias ld='lazydocker'
fi

if command -v yazi &> /dev/null; then
    alias fm='yazi'
fi

if command -v nvim &> /dev/null; then
    alias vim='nvim'
    alias vi='nvim'
    export EDITOR='nvim'
    export VISUAL='nvim'
fi

# ============================================
# Helper functions
# ============================================

# Quickly edit a file with syntax highlighting preview
preview() {
    if command -v bat &> /dev/null && command -v fzf &> /dev/null; then
        fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'
    else
        echo "Requires: bat and fzf"
    fi
}

# Search and edit with ripgrep and bat
rge() {
    if command -v rg &> /dev/null && command -v fzf &> /dev/null && command -v nvim &> /dev/null; then
        local file=$(rg --files-with-matches "$1" | fzf --preview "bat --color=always {}")
        [ -n "$file" ] && nvim "$file"
    else
        echo "Requires: ripgrep, fzf, and neovim"
    fi
}

EOF

# Replace SHELL_TYPE with actual shell
if [ "$SHELL_NAME" = "zsh" ]; then
    sed -i 's/SHELL_TYPE/zsh/g' "$SHELL_RC" 2>/dev/null || sed -i '' 's/SHELL_TYPE/zsh/g' "$SHELL_RC"
else
    sed -i 's/SHELL_TYPE/bash/g' "$SHELL_RC" 2>/dev/null || sed -i '' 's/SHELL_TYPE/bash/g' "$SHELL_RC"
fi

echo ""
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo ""
echo "To apply changes, run:"
echo "  source $SHELL_RC"
echo ""
echo "Or restart your terminal."
echo ""
