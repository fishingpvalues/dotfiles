#!/usr/bin/env bash
# setup-chezmoi.sh - Script to configure chezmoi for the current dotfiles structure on Unix systems

set -e # Exit on error

# Set the current directory as the source state for chezmoi
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_DIR="${DOTFILES_DIR}/.chezmoi"
CHEZMOI_BIN="${DOTFILES_DIR}/bin/chezmoi"

# Detect OS type
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=linux;;
    Darwin*)    MACHINE=darwin;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo "Detected OS: ${MACHINE}"

# Install chezmoi if not already installed
if [ ! -f "${CHEZMOI_BIN}" ]; then
    echo "Installing chezmoi..."
    mkdir -p "${DOTFILES_DIR}/bin"
    
    # Download and install chezmoi
    if command -v curl &> /dev/null; then
        sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${DOTFILES_DIR}/bin"
    elif command -v wget &> /dev/null; then
        sh -c "$(wget -qO- get.chezmoi.io)" -- -b "${DOTFILES_DIR}/bin"
    else
        echo "Error: Neither curl nor wget found. Please install one of them and try again."
        exit 1
    fi
fi

# Create chezmoi directories if they don't exist
if [ ! -d "${CHEZMOI_DIR}" ]; then
    mkdir -p "${CHEZMOI_DIR}"
fi

# Check if chezmoi is already initialized
if [ ! -f "${CHEZMOI_DIR}/config" ]; then
    "${CHEZMOI_BIN}" init --source="${DOTFILES_DIR}"
fi

# Map config directories to their destination paths
declare -A config_mappings
# Bash configuration
config_mappings["config/bash/bashrc"]=".bashrc"

# ZSH configuration
config_mappings["config/zsh/zshrc"]=".zshrc"
config_mappings["config/zsh/p10k.zsh"]=".p10k.zsh"

# Neovim configuration
config_mappings["config/nvim"]=".config/nvim"

# VS Code configuration
if [ "${MACHINE}" = "darwin" ]; then
    config_mappings["config/vscode/settings.json"]="Library/Application Support/Code/User/settings.json"
    config_mappings["config/vscode/keybindings.json"]="Library/Application Support/Code/User/keybindings.json"
elif [ "${MACHINE}" = "linux" ]; then
    config_mappings["config/vscode/settings.json"]=".config/Code/User/settings.json"
    config_mappings["config/vscode/keybindings.json"]=".config/Code/User/keybindings.json"
fi

# Terminal configurations
config_mappings["config/kitty"]=".config/kitty"
config_mappings["config/wezterm"]=".config/wezterm"
config_mappings["config/alacritty"]=".config/alacritty"

# Shell configurations
config_mappings["config/nushell"]=".config/nushell"

# Git configuration
config_mappings["config/git/gitconfig"]=".gitconfig"
config_mappings["config/git/gitignore_global"]=".gitignore_global"

# SSH configuration
config_mappings["config/ssh/config"]=".ssh/config"

# Tmux configuration
config_mappings["config/tmux/tmux.conf"]=".tmux.conf"

# Starship configuration
config_mappings["config/starship/starship.toml"]=".config/starship.toml"

# Lazygit configuration
config_mappings["config/lazygit"]=".config/lazygit"

# FZF configuration
config_mappings["config/fzf/fzf.config"]=".config/fzf/config"

# Other configurations
config_mappings["config/wget"]=".config/wget"
config_mappings["config/curl"]=".config/curl"

# Create chezmoi source directory
echo "Setting up chezmoi source directory..."

# Create the .local/share/chezmoi directory where chezmoi expects data
SOURCE_DIR="${HOME}/.local/share/chezmoi"
if [ ! -d "${SOURCE_DIR}" ]; then
    mkdir -p "${SOURCE_DIR}"
fi

# Map files to their chezmoi locations
for source_path in "${!config_mappings[@]}"; do
    target_path="${config_mappings[${source_path}]}"
    full_source_path="${DOTFILES_DIR}/${source_path}"
    full_target_path="${HOME}/${target_path}"
    
    if [ -e "${full_source_path}" ]; then
        # Add the file/directory to chezmoi
        echo "Adding ${source_path} to chezmoi..."
        
        # For directories, we need to make sure the parent directory exists
        if [ -d "${full_source_path}" ]; then
            target_dir="$(dirname "${full_target_path}")"
            if [ ! -d "${target_dir}" ]; then
                mkdir -p "${target_dir}"
            fi
            
            # Copy the directory to the target
            cp -R "${full_source_path}" "${full_target_path}" 2>/dev/null || true
        else
            # For files, copy directly
            target_dir="$(dirname "${full_target_path}")"
            if [ ! -d "${target_dir}" ]; then
                mkdir -p "${target_dir}"
            fi
            
            # Copy the file to the target
            cp "${full_source_path}" "${full_target_path}" 2>/dev/null || true
        fi
        
        # Add the file to chezmoi
        "${CHEZMOI_BIN}" add "${full_target_path}" || true
    else
        echo "Warning: Source path ${full_source_path} does not exist"
    fi
done

# Generate chezmoi config file if it doesn't exist
if [ ! -f "${DOTFILES_DIR}/.chezmoi.toml" ]; then
    echo "Creating .chezmoi.toml configuration file..."
    cat > "${DOTFILES_DIR}/.chezmoi.toml" << 'EOF'
[data]
    email = "your.email@example.com"  # Replace with your actual email
    name = "Your Name"  # Replace with your actual name

[sourceVCS]
    autoCommit = true  # Automatically commit after modifications
    autoPush = false   # Don't automatically push (safer)

[diff]
    command = "code"
    args = ["--diff", "{{.Destination}}", "{{.Target}}"]

# Define OS-specific settings
[data.windows]
    homeDir = "C:\\Users\\{{- .chezmoi.username }}"

[data.linux]
    homeDir = "/home/{{- .chezmoi.username }}"

[data.darwin]
    homeDir = "/Users/{{- .chezmoi.username }}"
EOF
fi

# Add .chezmoi.toml to chezmoi management
if [ -f "${DOTFILES_DIR}/.chezmoi.toml" ]; then
    "${CHEZMOI_BIN}" add "${DOTFILES_DIR}/.chezmoi.toml" || true
fi

# Add chezmoi to PATH by adding it to shell config files
if [ "${MACHINE}" = "darwin" ] || [ "${MACHINE}" = "linux" ]; then
    # Add to .bashrc if it exists
    if [ -f "${HOME}/.bashrc" ]; then
        if ! grep -q "# chezmoi PATH" "${HOME}/.bashrc"; then
            echo "" >> "${HOME}/.bashrc"
            echo "# chezmoi PATH" >> "${HOME}/.bashrc"
            echo "export PATH=\"\${PATH}:${DOTFILES_DIR}/bin\"" >> "${HOME}/.bashrc"
            echo "Added chezmoi to PATH in .bashrc"
        fi
    fi
    
    # Add to .zshrc if it exists
    if [ -f "${HOME}/.zshrc" ]; then
        if ! grep -q "# chezmoi PATH" "${HOME}/.zshrc"; then
            echo "" >> "${HOME}/.zshrc"
            echo "# chezmoi PATH" >> "${HOME}/.zshrc"
            echo "export PATH=\"\${PATH}:${DOTFILES_DIR}/bin\"" >> "${HOME}/.zshrc"
            echo "Added chezmoi to PATH in .zshrc"
        fi
    fi
fi

# Add to current session's PATH
export PATH="${PATH}:${DOTFILES_DIR}/bin"

echo "Chezmoi setup complete!"
echo "You can now use chezmoi commands to manage your dotfiles:"
echo "  ${CHEZMOI_BIN} cd      - Navigate to the source directory"
echo "  ${CHEZMOI_BIN} edit    - Edit a file managed by chezmoi"
echo "  ${CHEZMOI_BIN} apply   - Apply changes to your home directory"
echo "  ${CHEZMOI_BIN} diff    - Show the differences between the source and destination files"
echo "  ${CHEZMOI_BIN} status  - Show the status of files in the working directory"

echo ""
echo "To use chezmoi from anywhere, restart your shell or run:"
echo "  source ~/.bashrc  # if using bash"
echo "  source ~/.zshrc   # if using zsh"