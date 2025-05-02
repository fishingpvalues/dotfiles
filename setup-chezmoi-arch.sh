#!/usr/bin/env bash
# setup-chezmoi-arch.sh - Script to configure chezmoi for Arch Linux systems

set -e # Exit on error

# Source the main setup script first
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../bootstrap/setup-chezmoi.sh"

# Additional Arch Linux specific configurations
echo "Setting up Arch Linux specific configurations..."

# Create Arch-specific config mappings if needed
ARCH_CONFIG_DIR="${DOTFILES_DIR}/arch"
if [ -d "${ARCH_CONFIG_DIR}" ]; then
    # Map Arch-specific configurations
    declare -A arch_config_mappings
    arch_config_mappings["arch/pacman.conf"]="/etc/pacman.conf"
    arch_config_mappings["arch/makepkg.conf"]="/etc/makepkg.conf"
    
    # Need root permissions for these files
    for source_path in "${!arch_config_mappings[@]}"; do
        target_path="${arch_config_mappings[${source_path}]}"
        full_source_path="${DOTFILES_DIR}/${source_path}"
        
        if [ -f "${full_source_path}" ]; then
            echo "Adding ${source_path} to chezmoi (might require sudo)..."
            
            # Need sudo to copy to system directories
            if [ -f "${target_path}" ]; then
                sudo cp "${full_source_path}" "${target_path}"
                # We don't add system files to chezmoi management
            fi
        fi
    done
fi

# Install Oh My Posh if not already installed
if [ ! -f "/usr/local/bin/oh-my-posh" ]; then
    echo "Installing Oh My Posh..."
    if [ -f "${DOTFILES_DIR}/bootstrap/scripts/unix/install-oh-my-posh.sh" ]; then
        chmod +x "${DOTFILES_DIR}/bootstrap/scripts/unix/install-oh-my-posh.sh"
        "${DOTFILES_DIR}/bootstrap/scripts/unix/install-oh-my-posh.sh"
    fi
fi

# Setup Makefile symlink for easy usage
if [ -f "${DOTFILES_DIR}/Makefile" ] && [ ! -L "${HOME}/.local/bin/dotfiles-update" ]; then
    mkdir -p "${HOME}/.local/bin"
    ln -sf "${DOTFILES_DIR}/Makefile" "${HOME}/.local/bin/dotfiles-update"
    echo "Created symlink to Makefile at ~/.local/bin/dotfiles-update"
fi

echo "Arch Linux specific setup complete!"
echo "You can now use 'make install' from your dotfiles directory to install packages."