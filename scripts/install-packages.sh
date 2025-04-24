#!/usr/bin/env bash
# Cross-platform package installation script

set -e

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
  if [ -f /etc/arch-release ]; then
    DISTRO="arch"
  elif [ -f /etc/debian_version ]; then
    DISTRO="debian"
  elif [ -f /etc/fedora-release ]; then
    DISTRO="fedora"
  else
    DISTRO="unknown"
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ "$OSTYPE" == "cygwin" || "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  OS="windows"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

echo "Detected OS: $OS"
[ -n "$DISTRO" ] && echo "Linux distribution: $DISTRO"

# Common packages for all platforms
COMMON_PACKAGES=(
  "git"
  "curl"
  "wget"
  "unzip"
  "tmux"
  "neovim"
  "ripgrep"
  "fd"
  "fzf"
  "bat"
  "exa"
  "jq"
  "zsh"
  "starship"
  "delta"
)

# OS-specific packages
MACOS_PACKAGES=(
  "coreutils"
  "findutils"
  "gnu-sed"
  "grep"
  "ffmpeg"
  "htop"
  "nnn"
  "pyenv"
  "nvm"
)

ARCH_PACKAGES=(
  "base-devel"
  "htop"
  "python-pip"
  "docker"
  "docker-compose"
  "nnn"
  "ffmpeg"
)

DEBIAN_PACKAGES=(
  "build-essential"
  "software-properties-common"
  "apt-transport-https"
  "ca-certificates"
  "htop"
  "python3-pip"
  "python3-venv"
  "docker.io"
  "docker-compose"
  "ffmpeg"
)

FEDORA_PACKAGES=(
  "dnf-plugins-core"
  "htop"
  "python3-pip"
  "docker-ce"
  "docker-compose"
  "ffmpeg"
)

# Install Homebrew on macOS if not present
install_homebrew() {
  if ! command -v brew >/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH
    if [[ "$SHELL" == *"zsh" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zshrc
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
}

# Install packages on macOS
install_macos() {
  install_homebrew
  
  echo "Installing packages with Homebrew..."
  brew update
  
  # Install common packages
  for pkg in "${COMMON_PACKAGES[@]}"; do
    brew install "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install macOS-specific packages
  for pkg in "${MACOS_PACKAGES[@]}"; do
    brew install "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install GUI applications
  brew install --cask alacritty
  brew install --cask rectangle
  brew install --cask alfred
  brew install --cask visual-studio-code
  
  echo "macOS packages installed!"
}

# Install packages on Arch Linux
install_arch() {
  echo "Installing packages with pacman..."
  
  # Update package database
  sudo pacman -Syu --noconfirm
  
  # Install common packages
  for pkg in "${COMMON_PACKAGES[@]}"; do
    sudo pacman -S --noconfirm "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install Arch-specific packages
  for pkg in "${ARCH_PACKAGES[@]}"; do
    sudo pacman -S --noconfirm "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install AUR helper (yay) if not present
  if ! command -v yay >/dev/null; then
    echo "Installing yay AUR helper..."
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
  fi
  
  # Install AUR packages
  yay -S --noconfirm nerd-fonts-cascadia-code
  
  echo "Arch Linux packages installed!"
}

# Install packages on Debian/Ubuntu
install_debian() {
  echo "Installing packages on Debian/Ubuntu..."
  
  # Update package database
  sudo apt update
  
  # Add repositories for newer versions
  sudo add-apt-repository ppa:neovim-ppa/stable -y
  
  # Update again after adding new repositories
  sudo apt update
  
  # Install common packages
  for pkg in "${COMMON_PACKAGES[@]}"; do
    sudo apt install -y "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install Debian-specific packages
  for pkg in "${DEBIAN_PACKAGES[@]}"; do
    sudo apt install -y "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install starship if not found
  if ! command -v starship >/dev/null; then
    curl -sS https://starship.rs/install.sh | sh
  fi
  
  # Install newer versions of packages not in apt
  if ! command -v exa >/dev/null; then
    cargo install exa
  fi
  
  if ! command -v bat >/dev/null; then
    cargo install bat
  fi
  
  if ! command -v fd >/dev/null; then
    cargo install fd-find
  fi
  
  echo "Debian/Ubuntu packages installed!"
}

# Install packages on Fedora
install_fedora() {
  echo "Installing packages on Fedora..."
  
  # Update package database
  sudo dnf update -y
  
  # Add repositories for newer versions
  sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
  
  # Install common packages
  for pkg in "${COMMON_PACKAGES[@]}"; do
    sudo dnf install -y "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install Fedora-specific packages
  for pkg in "${FEDORA_PACKAGES[@]}"; do
    sudo dnf install -y "$pkg" || echo "Failed to install $pkg"
  done
  
  # Install starship if not found
  if ! command -v starship >/dev/null; then
    curl -sS https://starship.rs/install.sh | sh
  fi
  
  echo "Fedora packages installed!"
}

# Execute the appropriate installation function based on OS
case "$OS" in
  linux)
    case "$DISTRO" in
      arch)
        install_arch
        ;;
      debian)
        install_debian
        ;;
      fedora)
        install_fedora
        ;;
      *)
        echo "Unsupported Linux distribution: $DISTRO"
        exit 1
        ;;
    esac
    ;;
  macos)
    install_macos
    ;;
  windows)
    echo "For Windows, please run the PowerShell script: scripts/windows/install-packages.ps1"
    exit 0
    ;;
  *)
    echo "Unsupported OS: $OS"
    exit 1
    ;;
esac

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  
  # Install Powerlevel10k theme
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  
  # Install plugins
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "All packages have been installed successfully!"