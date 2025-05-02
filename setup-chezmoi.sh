#!/usr/bin/env bash
# setup-chezmoi.sh - Script to configure chezmoi for the current dotfiles structure on Unix systems

set -euo pipefail # Exit on error, undefined variables, and pipe failures
IFS=$'\n\t'      # Stricter word splitting

# Function to handle errors
error_handler() {
    local line_no=$1
    local command=$2
    local error_code=${3:-1}
    echo "Error on line ${line_no}: command '${command}' exited with status ${error_code}"
}

trap 'error_handler ${LINENO} "${BASH_COMMAND}" $?' ERR

# Function to create backup
create_backup() {
    local path="$1"
    if [ -e "$path" ]; then
        local backup_path="${path}.backup.$(date +%Y%m%d_%H%M%S)"
        echo "Creating backup of ${path} to ${backup_path}"
        cp -R "$path" "$backup_path"
    fi
}

REINIT=false
if [[ "$1" == "--reinit" ]]; then
  REINIT=true
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_DIR="${DOTFILES_DIR}/.chezmoi"
CHEZMOI_BIN="${DOTFILES_DIR}/bin/chezmoi"
LOCAL_CHEZMOI_DIR="${HOME}/.local/share/chezmoi"

if $REINIT; then
  echo "[setup] Reinitializing chezmoi..."
  if [ -d "$LOCAL_CHEZMOI_DIR" ]; then
    rm -rf "$LOCAL_CHEZMOI_DIR"
    echo "Removed $LOCAL_CHEZMOI_DIR"
  fi
  if [ -d "$CHEZMOI_DIR" ]; then
    rm -rf "$CHEZMOI_DIR"
    echo "Removed $CHEZMOI_DIR"
  fi
fi

# Detect OS type
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=linux;;
    Darwin*)    MACHINE=darwin;;
    *)          echo "Unsupported OS: ${OS}"; exit 1;;
esac

echo "Detected OS: ${MACHINE}"

# Install chezmoi if not already installed
if [ ! -f "${CHEZMOI_BIN}" ]; then
    echo "Installing chezmoi..."
    mkdir -p "${DOTFILES_DIR}/bin"
    
    # Download and install chezmoi
    if command -v curl &> /dev/null; then
        sh -c "$(curl -fsSL get.chezmoi.io)" -- -b "${DOTFILES_DIR}/bin"
    elif command -v wget &> /dev/null; then
        sh -c "$(wget -qO- get.chezmoi.io)" -- -b "${DOTFILES_DIR}/bin"
    else
        echo "Error: Neither curl nor wget found. Please install one of them and try again."
        exit 1
    fi
    
    # Verify installation
    if [ ! -x "${CHEZMOI_BIN}" ]; then
        echo "Error: chezmoi installation failed"
        exit 1
    fi
fi

# Create chezmoi directories if they don't exist
mkdir -p "${CHEZMOI_DIR}"

# Check if chezmoi is already initialized
if [ ! -f "${CHEZMOI_DIR}/config" ]; then
    "${CHEZMOI_BIN}" init --source="${DOTFILES_DIR}"
fi

# Map config directories to their destination paths
declare -A config_mappings

# Function to safely add config mapping
add_config_mapping() {
    local source="$1"
    local target="$2"
    if [ -e "${DOTFILES_DIR}/${source}" ]; then
        config_mappings["${source}"]="${target}"
    fi
}

# Shell configurations
add_config_mapping "config/bash/bashrc" ".bashrc"
add_config_mapping "config/zsh/zshrc" ".zshrc"
add_config_mapping "config/zsh/p10k.zsh" ".p10k.zsh"
add_config_mapping "config/nushell" ".config/nushell"

# Editor configurations
add_config_mapping "config/nvim" ".config/nvim"

# VS Code configuration
if [ "${MACHINE}" = "darwin" ]; then
    add_config_mapping "config/vscode/settings.json" "Library/Application Support/Code/User/settings.json"
    add_config_mapping "config/vscode/keybindings.json" "Library/Application Support/Code/User/keybindings.json"
elif [ "${MACHINE}" = "linux" ]; then
    add_config_mapping "config/vscode/settings.json" ".config/Code/User/settings.json"
    add_config_mapping "config/vscode/keybindings.json" ".config/Code/User/keybindings.json"
fi

# Terminal configurations
add_config_mapping "config/kitty" ".config/kitty"
add_config_mapping "config/wezterm" ".config/wezterm"
add_config_mapping "config/alacritty" ".config/alacritty"

# Git configuration
add_config_mapping "config/git/gitconfig" ".gitconfig"
add_config_mapping "config/git/gitignore_global" ".gitignore_global"

# Other tools configuration
add_config_mapping "config/ssh/config" ".ssh/config"
add_config_mapping "config/tmux/tmux.conf" ".tmux.conf"
add_config_mapping "config/starship/starship.toml" ".config/starship.toml"
add_config_mapping "config/lazygit" ".config/lazygit"
add_config_mapping "config/fzf/fzf.config" ".config/fzf/config"
add_config_mapping "config/wget" ".config/wget"
add_config_mapping "config/curl" ".config/curl"

# Create chezmoi source directory
echo "Setting up chezmoi source directory..."

# Create the .local/share/chezmoi directory where chezmoi expects data
SOURCE_DIR="${HOME}/.local/share/chezmoi"
mkdir -p "${SOURCE_DIR}"

# Map files to their chezmoi locations
for source_path in "${!config_mappings[@]}"; do
    target_path="${config_mappings[${source_path}]}"
    full_source_path="${DOTFILES_DIR}/${source_path}"
    full_target_path="${HOME}/${target_path}"
    
    if [ -e "${full_source_path}" ]; then
        echo "Processing ${source_path}..."
        
        # Create backup of existing files
        create_backup "${full_target_path}"
        
        # Create target directory
        target_dir="$(dirname "${full_target_path}")"
        mkdir -p "${target_dir}"
        
        # Copy files/directories
        if [ -d "${full_source_path}" ]; then
            cp -R "${full_source_path}" "${full_target_path}" 2>/dev/null || true
        else
            cp "${full_source_path}" "${full_target_path}" 2>/dev/null || true
        fi
        
        # Add to chezmoi
        "${CHEZMOI_BIN}" add "${full_target_path}" 2>/dev/null || {
            echo "Warning: Failed to add ${full_target_path} to chezmoi"
        }
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

[merge]
    command = "code"
    args = ["--wait", "--merge", "{{.Destination}}", "{{.Source}}", "{{.Target}}"]

# Define OS-specific settings
[data.windows]
    homeDir = "C:\\Users\\{{- .chezmoi.username }}"

[data.linux]
    homeDir = "/home/{{- .chezmoi.username }}"

[data.darwin]
    homeDir = "/Users/{{- .chezmoi.username }}"

[edit]
    command = "code"
    args = ["--wait"]
EOF
fi

# Add .chezmoi.toml to chezmoi management
if [ -f "${DOTFILES_DIR}/.chezmoi.toml" ]; then
    "${CHEZMOI_BIN}" add "${DOTFILES_DIR}/.chezmoi.toml" 2>/dev/null || true
fi

# Function to safely modify shell config
modify_shell_config() {
    local config_file="$1"
    local comment="$2"
    local command="$3"
    
    if [ -f "${config_file}" ]; then
        # Create backup
        create_backup "${config_file}"
        
        # Add to shell config if not already present
        if ! grep -q "${comment}" "${config_file}"; then
            {
                echo ""
                echo "${comment}"
                echo "${command}"
            } >> "${config_file}"
            echo "Updated ${config_file}"
        fi
    fi
}

# Add chezmoi to PATH in shell configs
if [ "${MACHINE}" = "darwin" ] || [ "${MACHINE}" = "linux" ]; then
    modify_shell_config "${HOME}/.bashrc" "# chezmoi PATH" "export PATH=\"\${PATH}:${DOTFILES_DIR}/bin\""
    modify_shell_config "${HOME}/.zshrc" "# chezmoi PATH" "export PATH=\"\${PATH}:${DOTFILES_DIR}/bin\""
fi

# Add to current session's PATH
export PATH="${PATH}:${DOTFILES_DIR}/bin"

# Verify installation
echo "Verifying installation..."
if ! "${CHEZMOI_BIN}" verify; then
    echo "Warning: Some files differ from their targets. Run 'chezmoi diff' to see the differences."
fi

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

# At the end, call the install script
INSTALL_SCRIPT="$DOTFILES_DIR/bootstrap/scripts/unix/install.sh"
if [ -f "$INSTALL_SCRIPT" ]; then
  echo "[setup] Running install script..."
  bash "$INSTALL_SCRIPT"
else
  echo "[setup] Install script not found: $INSTALL_SCRIPT"
fi