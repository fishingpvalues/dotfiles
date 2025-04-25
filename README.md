# Cross-Platform Dotfiles

This repository contains my personal configuration files (dotfiles) for multiple operating systems, managed with [chezmoi](https://www.chezmoi.io/).

## Features

- **Cross-Platform Support**: Works on macOS, Linux, and Windows
- **Package Management**: Using OS-specific package managers (Homebrew, pacman, winget)
- **Shell Configuration**: zsh, bash, PowerShell with customizations
- **Terminal Utilities**: exa, bat, ripgrep, fzf, etc.
- **Development Environment**: VSCode, Neovim, Docker, Python, Rust, and more
- **Window Management**: Rectangle, Hammerspoon (macOS), and system-specific alternatives
- **System Settings**: Sensible defaults for developer-focused setups

## Installation

### Option 1: Using the Setup Scripts

This repository includes dedicated setup scripts for different operating systems:

#### Windows

```powershell
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Run the setup script
powershell -ExecutionPolicy Bypass -File setup-chezmoi.ps1
```

#### macOS/Linux

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# Run the setup script
chmod +x setup-chezmoi.sh
./setup-chezmoi.sh
```

### Option 2: Manual Installation

#### Prerequisites

Install [chezmoi](https://www.chezmoi.io/) if you haven't already:

For macOS/Linux:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
```

For Windows (PowerShell):
```powershell
(irm -useb get.chezmoi.io/ps1) | powershell -c -
```

Or with package managers:
```bash
# macOS with Homebrew
brew install chezmoi

# Arch Linux
pacman -S chezmoi

# Windows with Scoop
scoop install chezmoi
```

#### Quick Start

Initialize chezmoi with this repository:

```bash
chezmoi init https://github.com/yourusername/dotfiles.git
```

Apply the dotfiles to your system:

```bash
chezmoi apply
```

### Step-by-step Setup

1. **Initialize chezmoi with this repository**:

```bash
chezmoi init https://github.com/yourusername/dotfiles.git
```

2. **Check what changes would be made**:

```bash
chezmoi diff
```

3. **Apply the dotfiles**:

```bash
chezmoi apply
```

4. **Install applications and tools**:

OS-specific installation scripts will run automatically during setup.

5. **Configure system settings**:

System-specific settings will be applied automatically during setup.

## Included Software & Tools

### Terminal & Shell

- **Cross-Platform**: zsh, bash, PowerShell with customizations
- **Themes**: Powerlevel10k (zsh), Oh My Posh (PowerShell)
- **Terminal Utilities**: exa, bat, fzf, ripgrep, fd, etc.
- **Terminal Emulators**: WezTerm, kitty, Windows Terminal

### Development Tools

- **VSCode**: With extensions for various languages and tools
- **Neovim**: Text editor with custom configurations
- **Git**: With lazygit for easier Git operations
- **Docker & Kubernetes**: Docker, kubectl, helm, k9s
- **Programming Languages**: Python, Rust (via rustup)
- **AI & ML**: Ollama, Jan AI, etc.

### Productivity

- **Window Management**:
  - macOS: Rectangle, Hammerspoon, Amethyst
  - Windows: PowerToys
  - Linux: System-specific tools

### Applications

Platform-specific applications are installed through the respective package managers.

## Fonts

- **Nerd Fonts**: MesloLGS NF, Fira Code Nerd Font, etc.

## Structure

- `CHEZMOI.md`: Detailed guide for using chezmoi
- `setup-chezmoi.ps1`: Windows setup script
- `setup-chezmoi.sh`: Unix (macOS/Linux) setup script
- `config/`: Directory containing configuration files for various tools
- OS-specific package files and settings

## Customization

To modify or add new dotfiles:

1. Make changes to the local files in the chezmoi source directory:

```bash
chezmoi edit ~/.zshrc  # or equivalent for your system
```

2. Apply the changes:

```bash
chezmoi apply
```

3. Update the repository:

```bash
chezmoi cd
git add .
git commit -m "Update dotfiles"
git push
```

## License

MIT
