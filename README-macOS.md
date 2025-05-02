> **Note:** No pirated, unlicensed, or non-company-approved software is installed. All apps are open source or from official sources.
>
> **Security/AI tools (aircrack-ng, hashcat, john, nmap, wireshark, ollama) have been removed for work compliance.**

# macOS Dotfiles & System Automation

This guide explains how to set up and use these dotfiles for a highly customized, developer-friendly macOS environment. All configurations are managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

---

## Features

- **Automated macOS System Tweaks:** UI/UX, keyboard, trackpad, Finder, Dock, Safari, Mail, Terminal, Chrome, Spotlight, and more
- **App Install & Configuration:** Homebrew, CLI tools, terminal emulators, developer tools, fonts
- **Cross-Platform Dotfiles:** Shared config for zsh, bash, git, neovim, kitty, wezterm, starship, tmux, fzf, and more
- **Safe & Reproducible:** No pirated or unapproved software; all scripts are idempotent and can be re-run safely

---

## Prerequisites

- macOS (tested on recent versions, but some tweaks may need updates for the latest releases)
- [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/): `xcode-select --install`
- [Homebrew](https://brew.sh/): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- [chezmoi](https://www.chezmoi.io/): `brew install chezmoi`

---

## Quick Start

```sh
# 1. Clone the repository
chezmoi init https://github.com/fishingpvalues/dotfiles.git

# 2. Preview changes
chezmoi diff

# 3. Apply dotfiles
chezmoi apply

# 4. Run the macOS setup script (for system/app tweaks)
./bootstrap/setup-chezmoi.sh
# or, for a fresh setup, add --reinit
./bootstrap/setup-chezmoi.sh --reinit
```

---

## What Gets Configured?

### System Tweaks (via `bootstrap/.macos/.macos` and `bootstrap/.macos/apps/*`)

- **General UI/UX:** Scrollbars, highlight color, save/print panels, fast window resize, disable transparency, etc.
- **Keyboard/Trackpad:** Tap-to-click, fast key repeat, disable smart quotes/dashes, full keyboard access
- **Finder:** Show hidden files, default view, sidebar, search, etc.
- **Dock:** Size, autohide, hot corners, recent apps, minimize effects
- **Safari, Chrome, Mail:** Privacy, dev features, keyboard shortcuts, gestures
- **Terminal:** UTF-8, secure keyboard entry, custom themes
- **Spotlight:** Search result customization, indexing tweaks
- **System:** Energy saving, screen, login window, Notification Center, etc.

### Apps & Tools (installed/configured via Homebrew and scripts)

- **Terminal Emulators:** WezTerm, kitty
- **Shells:** zsh (with Powerlevel10k), bash
- **CLI Tools:** exa, bat, fzf, ripgrep, fd, starship, lazygit, neofetch, btop, tmux, wget, curl, git, ssh
- **Editors:** Neovim (custom config), VSCode (optional)
- **Fonts:** Nerd Fonts (MesloLGS NF, Fira Code, etc.)
- **Window Management:** Rectangle, Amethyst (optional)
- **Other:** starship prompt, custom scripts, and more

---

## Directory Structure

```
dotfiles/
  bootstrap/           # macOS-specific scripts and app configs
  config/           # App and tool configs (cross-platform)
  scripts/          # Helper scripts (unix/windows)
  bootstrap/setup-chezmoi.sh  # Main macOS/Linux setup script
  bootstrap/dot_Brewfile      # Homebrew bundle file (macOS)
  ...
```

---

## Customization & Tips

- **Edit dotfiles:** `chezmoi edit <file>`
- **Add new config:** `chezmoi add ~/.config/myapp/config.toml`
- **Update dotfiles:** `chezmoi update`
- **Push/pull changes:** Use `chezmoi cd` to enter the source dir, then use git as usual
- **macOS tweaks:** Edit `bootstrap/.macos/.macos` or scripts in `bootstrap/.macos/apps/` for system/app settings
- **App lists:** Edit `bootstrap/dot_Brewfile` to add/remove Homebrew apps

---

## Troubleshooting & Notes

- Some settings require **sudo** or Security & Privacy approval
- Xcode Command Line Tools and Homebrew are required for most automation
- Some tweaks may not work on the latest macOS without updates
- Backup your system before running large automation scripts
- If you have issues, re-run the setup script or check the logs

---

## More Info

- [Main README](README.md) — Cross-platform overview
- [CHEZMOI.md](CHEZMOI.md) — Chezmoi usage and advanced tips
- [Arch README](README-ARCH.md) — Linux/Hyprland setup
- [Chezmoi Documentation](https://www.chezmoi.io/)

---

Enjoy your automated, reproducible, and secure macOS setup!
