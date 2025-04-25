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

## macOS Configuration

The repository includes extensive macOS system configurations in the `.macos` directory:

### Application-Specific Settings

- **Finder**: Custom view options, showing hidden files, and improved navigation
- **Dock**: Optimized appearance and behavior, hot corners setup
- **Safari**: Enhanced privacy and developer features
- **Terminal**: UTF-8 support, secure keyboard entry, and custom theme
- **Chrome**: Gesture controls and print dialog settings
- **Mail**: Improved email handling and keyboard shortcuts
- **Spotlight**: Customized search results and indexing
- **System**: Energy saving, screen behavior, and UI/UX preferences

### Known Issues and Warnings

1. **Permission Requirements**:
   - Many commands require sudo access
   - Some settings may need Security & Privacy approval
   - Full Disk Access may be required for certain operations

2. **Compatibility Notes**:
   - Some settings might not work on newer macOS versions
   - Xcode Command Line Tools are required
   - Some features depend on specific applications being installed

3. **Potential Risks**:
   - Disabling System Integrity Protection might be required for some settings
   - Some security features are modified (e.g., Gatekeeper settings)
   - Backup your system before applying settings

4. **Bug Fixes Required**:
   - Terminal theme installation needs path verification
   - Some PlistBuddy commands might fail silently
   - Spotlight indexing commands might need adjustment for newer OS versions

## Installation

### Prerequisites

1. Install [chezmoi](https://www.chezmoi.io/):

```bash
# macOS with Homebrew
brew install chezmoi

# Arch Linux
pacman -S chezmoi

# Windows with Scoop
scoop install chezmoi

# Direct installation (macOS/Linux)
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin

# Direct installation (Windows PowerShell)
(irm -useb get.chezmoi.io/ps1) | powershell -c -
```

2. **macOS Additional Requirements**:
   - Install Xcode Command Line Tools: `xcode-select --install`
   - Install Homebrew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
   - Grant necessary permissions in System Preferences

### Quick Start

```bash
# Initialize chezmoi with this repository
chezmoi init https://github.com/yourusername/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles
chezmoi apply
```

### Detailed Setup

1. **Clone and Initialize**:

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles

# For Windows
powershell -ExecutionPolicy Bypass -File setup-chezmoi.ps1

# For macOS/Linux
chmod +x setup-chezmoi.sh
./setup-chezmoi.sh
```

2. **Verify Installation**:

```bash
# Check applied changes
chezmoi diff

# View source state
chezmoi verify
```

3. **Update Configuration**:

```bash
# Edit files
chezmoi edit $FILE

# Apply changes
chezmoi apply

# Update repository
chezmoi cd
git add .
git commit -m "Update dotfiles"
git push
```

## Directory Structure

```
dotfiles/
├── .chezmoi/           # Chezmoi internal files
├── .macos/             # macOS specific settings
│   ├── apps/          # Application-specific configurations
│   └── source_all.sh  # Main configuration script
├── config/             # Tool configurations
│   ├── alacritty/     # Terminal emulator settings
│   ├── nvim/          # Neovim configuration
│   └── ...            # Other tool configs
├── scripts/           # Utility scripts
└── setup-*.sh         # Setup scripts
```

## Customization

### Adding New Configurations

1. **Add Files**:

```bash
# Add new file to chezmoi
chezmoi add ~/.config/newconfig

# Edit the file
chezmoi edit ~/.config/newconfig
```

2. **Test Changes**:

```bash
# Preview changes
chezmoi diff

# Apply changes
chezmoi apply
```

### Modifying macOS Settings

1. Edit the relevant file in `.macos/apps/`
2. Test the changes in a clean environment
3. Update the documentation if needed

## Troubleshooting

### Common Issues

1. **Permission Errors**:
   - Run with sudo when required
   - Check System Preferences → Security & Privacy
   - Grant Full Disk Access to Terminal/iTerm2

2. **Failed Commands**:
   - Verify OS version compatibility
   - Check for required applications
   - Review system logs for errors

3. **Settings Not Applied**:
   - Logout/restart might be required
   - Check command syntax for OS version
   - Verify paths and permissions

### Recovery

1. **Backup Default Settings**:

```bash
# Before applying changes
defaults read > defaults.before
```

2. **Restore Settings**:

```bash
# Revert specific setting
defaults delete com.apple.finder NewWindowTarget

# Restart affected application
killall Finder
```

## License

MIT
