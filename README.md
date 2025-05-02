# Cross-Platform Dotfiles

> **Arch Linux user?** 👉 [See the Arch-specific setup guide here!](README-ARCH.md)
> 
> **macOS user?** 👉 [See the macOS-specific setup guide here!](README-macOS.md)

## Start Here

1. **Clone this repo** to your machine.
2. **Run the setup script for your OS:**
   - Windows: `setup-chezmoi.ps1` (add `-Reinit` to force reinit)
   - macOS/Linux: `setup-chezmoi.sh` (add `--reinit` to force reinit)
3. **Install all tools and fonts:**
   - This is now handled automatically by the setup script, which calls the appropriate install script:
     - Windows: `scripts/windows/install.ps1`
     - macOS/Linux: `scripts/unix/install.sh`
     - These may call `brew bundle`, `make`, or other package managers as needed.
4. **If you have issues, run the healer script:**
   - Windows: `scripts/windows/healer.ps1`
   - macOS/Linux: `scripts/unix/healer.sh`
5. **To edit dotfiles:**
   - Use `chezmoi edit <file>`
6. **To push/pull changes:**
   - Use `chezmoi cd` to enter the source directory, then use `git` commands (`git add`, `git commit`, `git push`, `git pull`)
   - Or use `chezmoi git <args>` from anywhere (e.g., `chezmoi git status`)

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
chezmoi init https://github.com/fishingpvalues/dotfiles.git

# Preview changes
chezmoi diff

# Apply dotfiles
chezmoi apply
```

### Detailed Setup

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

```
dotfiles/
  README.md
  CHEZMOI.md
  LICENSE
  .chezmoi.toml
  .chezmoi.toml.tmpl
  .chezmoiignore
  .editorconfig
  .gitignore
  dot_Brewfile
  Makefile
  bin/
    chezmoi.exe
  config/
    bash/
    zsh/
    nvim/
    kitty/
    wezterm/
    windows-terminal/
    powershell/
    starship/
    git/
    ssh/
    fzf/
    lazygit/
    nushell/
    wget/
    curl/
    tmux/
    idea/
  scripts/
    README.md
    windows/
      install.ps1
      healer.ps1
      install-packages.ps1
    unix/
      install.sh
      healer.sh
      install-oh-my-posh.sh
  setup-chezmoi.ps1
  setup-chezmoi.sh
  setup-chezmoi-arch.sh
  reinit-chezmoi.ps1
  media/
    wallpapers/
  .macos/
  .conda/
```

- All scripts are grouped by OS in `scripts/`.
- Use the main README and `scripts/README.md` for guidance.
- Use chezmoi as your main dotfiles manager: `chezmoi edit`, `chezmoi apply`, `chezmoi cd`, `chezmoi git <args>`.

## Customization

To modify or add new dotfiles:

1. Make changes to the local files in the chezmoi source directory:

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

### Adding New Configurations

```bash
# Add new file to chezmoi
chezmoi add ~/.config/newconfig
```

### Modifying macOS Settings

1. Edit the relevant file in `.macos/apps/`
2. Test the changes in a clean environment
3. Update the documentation if needed

## Troubleshooting

### Common Issues

- **Permission Errors**: Run with sudo when required, check System Preferences → Security & Privacy, grant Full Disk Access to Terminal/iTerm2
- **Failed Commands**: Verify OS version compatibility, check for required applications, review system logs for errors
- **Settings Not Applied**: Logout/restart might be required, check command syntax for OS version, verify paths and permissions

### Recovery

```bash
# Before applying changes
defaults read > defaults.before

# Revert specific setting
defaults delete com.apple.finder NewWindowTarget

# Restart affected application
killall Finder
```

## License

MIT

## Platform-Specific Setup Guides

- [Arch Linux Setup](README-ARCH.md)
- [macOS Setup](README-macOS.md)
- [Chezmoi Usage](CHEZMOI.md)

## Windows PowerShell + Dotfiles Setup Guide

Follow these steps to ensure your PowerShell loads your dotfiles profile and Oh My Posh works correctly, even with OneDrive and script security:

### 1. Install All Tools and Fonts
Run the provided script (as Administrator):
```powershell
./install-everything.ps1
```
This will install all required tools and fonts, and symlink your PowerShell profile.

### 2. OneDrive Profile Loader (if needed)
If your `$PROFILE` is in OneDrive (common on Windows), create a loader profile at:
```
C:\Users\<YourUser>\OneDrive\Dokumente\PowerShell\Microsoft.PowerShell_profile.ps1
```
with this content:
```powershell
. 'C:\dotfiles\config\powershell\user_profile.ps1'
```
This ensures PowerShell always loads your dotfiles profile.

### 3. Set Execution Policy
Open PowerShell as Administrator and run:
```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
This allows local scripts to run.

### 4. Unblock All Dotfiles Scripts
If you get errors about scripts not being digitally signed, unblock them:
```powershell
Get-ChildItem -Path C:\dotfiles -Recurse -Filter *.ps1 | Unblock-File
```

### 5. Ensure Oh My Posh is on PATH
The profile includes logic to add common install locations for `oh-my-posh` to your PATH. Make sure it is installed and accessible:
```powershell
oh-my-posh --version
```

### 6. Restart PowerShell
Open a new PowerShell window. You should see your custom prompt and settings.

---

**Troubleshooting:**
- If you see errors about digital signatures, make sure you have set the execution policy and unblocked your scripts.
- If your profile is not loading, check `$PROFILE` and ensure the loader or symlink is in the correct location.
- If Oh My Posh is not found, ensure it is installed and on your PATH.

---

This guide summarizes the steps that made the setup work as discussed in this chat. Use it for future reference or when setting up on a new machine!

## macOS & Linux Shell + Dotfiles Setup Guide

Follow these steps to ensure your shell (zsh, bash, fish, etc.) loads your dotfiles profile and prompt tools (like Starship or Oh My Posh) work correctly:

### 1. Install All Tools and Fonts
Run the provided script:
```bash
./install-everything.sh
```
This will install all required tools and fonts, and symlink your shell profiles.

### 2. Symlink or Source Your Dotfiles Profile
For each shell you use, ensure your system profile sources your dotfiles version.  
For example, for zsh:
```bash
# In ~/.zshrc (or ~/.bashrc, ~/.bash_profile, ~/.config/fish/config.fish, etc.)
source ~/dotfiles/config/zsh/zshrc
```
Or, symlink:
```bash
ln -sf ~/dotfiles/config/zsh/zshrc ~/.zshrc
```
Repeat for other shells as needed.

### 3. Ensure Prompt Tool is Installed and on PATH
For Starship:
```bash
starship --version
```
For Oh My Posh:
```bash
oh-my-posh --version
```
If not found, install via Homebrew, apt, or your package manager.

### 4. Set Script Permissions
If you get "permission denied" errors, make scripts executable:
```bash
chmod +x ~/dotfiles/scripts/unix/*.sh
```

### 5. Install Fonts
Make sure you have a Nerd Font installed and selected in your terminal emulator for prompt icons to display correctly.

### 6. Restart Your Terminal
Open a new terminal window to see your custom prompt and settings.

---

**Troubleshooting:**
- If your profile is not loading, check that your shell's config file sources or symlinks to your dotfiles profile.
- If your prompt tool is not found, ensure it is installed and on your PATH.
- If icons are missing, ensure a Nerd Font is installed and selected in your terminal.
- If you get "permission denied" errors, check script permissions.

---

This guide summarizes the steps to ensure your dotfiles and prompt tools work on macOS and Linux, just like on Windows.

## Cursor Editor

[Cursor](https://www.cursor.so/) is a modern AI-powered code editor. To install Cursor:

### Windows
Download and run the installer from:
https://www.cursor.so/download/windows

### macOS
Download and run the installer from:
https://www.cursor.so/download/mac

Or install via Homebrew:
```bash
brew install --cask cursor
```

### Linux
Download the AppImage from:
https://www.cursor.so/download/linux

Or use the .deb or .rpm packages as provided on the website.

After installation, you can launch Cursor from your applications menu or with the `cursor` command.

## Entry Points

- **Windows:**
  - `setup-chezmoi.ps1` — Initial chezmoi and dotfiles setup
  - `scripts/windows/install.ps1` — Install all tools and fonts, fix profile
  - `scripts/windows/healer.ps1` — Heal/fix common issues (run if you have errors)
- **macOS/Linux:**
  - `setup-chezmoi.sh` — Initial chezmoi and dotfiles setup
  - `scripts/unix/install.sh` — Install all tools and fonts
  - `scripts/unix/healer.sh` — Heal/fix common issues (run if you have errors)

## Recommended Structure

```
dotfiles/
  README.md
  CHEZMOI.md
  LICENSE
  .chezmoi.toml
  .chezmoi.toml.tmpl
  .chezmoiignore
  .editorconfig
  .gitignore
  dot_Brewfile
  Makefile
  bin/
    chezmoi.exe
  config/
    bash/
    zsh/
    nvim/
    kitty/
    wezterm/
    windows-terminal/
    powershell/
    starship/
    git/
    ssh/
    fzf/
    lazygit/
    nushell/
    wget/
    curl/
    tmux/
    idea/
  scripts/
    README.md
    windows/
      install.ps1
      healer.ps1
      install-packages.ps1
    unix/
      install.sh
      healer.sh
      install-oh-my-posh.sh
  setup-chezmoi.ps1
  setup-chezmoi.sh
  setup-chezmoi-arch.sh
  reinit-chezmoi.ps1
  media/
    wallpapers/
  .macos/
  .conda/
```

- Remove any empty or obsolete folders (e.g., `nvim.old/`, `.chezmoi/source/`, `.vscode/` if not needed)
- Consolidate install scripts to one per OS
- Use the healer scripts to fix common issues

## Arch Linux: Automated Hyprland/macOS-like Setup

1. **Install all required packages and dotfiles:**
   ```sh
   make install-hyprland
   ```
   This will install Hyprland, Waybar, Kitty, Dunst, Rofi, WezTerm, Anyrun, Cairo Dock/Eww, WhiteSur themes, Nerd Fonts, and all plugins/deps, then apply your dotfiles.

2. **Theme switching:**
   - Use `scripts/unix/set_theme.sh <forest|water|desert>` to set a theme.
   - Use `scripts/unix/cycle_theme.sh` to cycle through themes (bind to a key, e.g. Super+T in Hyprland).
   - Wallpapers are switched automatically based on theme and must be named `forest_*`, `water_*`, or `desert_*` in `~/Pictures/Wallpapers/`.

3. **Modular config structure:**
   - All themeable configs (Waybar, Kitty, WezTerm, Rofi, etc.) use symlinks to `current-theme` files, switched by the scripts.
   - Add new themes by creating new color files and updating the scripts if needed.

4. **Customize further:**
   - See `scripts/unix/set_theme.sh` for how to add more apps or theme logic.
   - See the Makefile for all installable targets.
