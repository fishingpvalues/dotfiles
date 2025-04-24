# Dotfiles Management with Chezmoi

This repository contains my personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/). These dotfiles can be installed across different operating systems (Windows, macOS, and Linux/Arch) using the appropriate installation script.

## Quick Start

### Option 1: Using Setup Scripts (Recommended)

Use the provided setup scripts to configure chezmoi with your dotfiles:

#### On Windows

```powershell
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
powershell -ExecutionPolicy Bypass -File setup-chezmoi.ps1
```

#### On macOS/Linux

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
chmod +x setup-chezmoi.sh
./setup-chezmoi.sh
```

#### On Arch Linux

```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
chmod +x setup-chezmoi-arch.sh
./setup-chezmoi-arch.sh
```

### Option 2: Using Chezmoi Directly

If you already have chezmoi installed, you can directly initialize your dotfiles:

```bash
chezmoi init --apply git@github.com:yourusername/dotfiles.git
```

## What's Included?

- Shell configurations (.bashrc, .zshrc)
- Neovim setup with Lazy.nvim
- VS Code settings and extensions
- Terminal configurations (WezTerm, Kitty, Windows Terminal)
- Package installation for:
  - macOS (via Homebrew)
  - Windows (via winget and Scoop)
  - Arch Linux (via pacman and yay)
  - Debian/Ubuntu (via apt)

## Chezmoi Dotfiles Management

This repository is fully configured to work with chezmoi. For detailed instructions on using chezmoi to manage your dotfiles, please see [CHEZMOI.md](CHEZMOI.md).

Key features:
- Cross-platform dotfiles management
- Template support for OS-specific configurations
- Secret management capabilities
- Version control integration

## Directory Structure

```
.
├── .chezmoi.toml       # Chezmoi configuration
├── .chezmoiignore      # Files to ignore from management
├── bin/                # Contains the chezmoi binary
├── config/             # Configuration files organized by application
│   ├── bash/           # Bash shell configuration
│   ├── nvim/           # Neovim configuration
│   ├── vscode/         # VS Code settings and keybindings
│   ├── kitty/          # Kitty terminal configuration
│   ├── wezterm/        # WezTerm terminal configuration
│   └── ...             # Other tool configurations
├── scripts/            # Installation and setup scripts
│   ├── unix/           # Scripts for Unix-like systems
│   └── windows/        # Scripts for Windows
├── setup-chezmoi.ps1   # Windows setup script for chezmoi
├── setup-chezmoi.sh    # Unix setup script for chezmoi
└── setup-chezmoi-arch.sh # Arch Linux setup script for chezmoi
```

## Operating System Detection

The setup scripts automatically detect your operating system and apply the appropriate configurations and packages:

- **macOS**: Uses Homebrew to install packages and installs macOS-specific tools
- **Windows**: Uses winget and Scoop to install packages
- **Arch Linux**: Uses pacman and yay (AUR helper) to install packages
- **Debian/Ubuntu**: Uses apt to install packages

## Customizing

To customize these dotfiles for your own use:

1. Fork this repository
2. Modify the configurations as needed
3. Update the installation scripts if necessary
4. Run the appropriate setup script for your OS

## License

This project is licensed under the MIT License - see the LICENSE file for details.
