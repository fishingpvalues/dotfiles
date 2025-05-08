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
./bootstrap/setup-dotfiles.sh
# or, for a fresh setup, add --reinit
./bootstrap/setup-dotfiles.sh --reinit
```

---

## Cloning with Submodules

This repository uses a submodule for the bootstrap scripts. To clone with all dependencies:

```sh
git clone --recurse-submodules https://github.com/fishingpvalues/dotfiles.git
```

If you already cloned without submodules, run:

```sh
git submodule update --init --recursive
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
  bootstrap/setup-dotfiles.sh  # Main macOS/Linux setup script
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

## Automated Testing Framework

This repository includes a robust, cross-platform testing framework to ensure all setup scripts, dotfiles, and functions work as expected on all supported platforms (Linux, macOS, Windows).

### How It Works

- **Docker-based matrix testing** for Ubuntu, Fedora, Arch, and Alpine Linux using Dockerfiles in `test/`.
- **GitHub Actions CI** runs all tests on every push and pull request, including:
  - All Linux Docker containers
  - macOS runner
  - Windows runner
- **Test scripts** (`test/test.sh`, `test/test.ps1`) source all shell profiles and run all key functions/aliases, checking for errors and expected output.
- **Idempotency**: Install scripts are run multiple times to ensure re-runs are safe.

### Running Tests Locally

#### Linux (Docker required)

```sh
./test/run-all.sh
```

#### macOS

```sh
./test/test.sh
```

#### Windows (PowerShell)

```powershell
./test/test.ps1
```

### In CI

- All tests run automatically via `.github/workflows/test-dotfiles.yml`.

### Refreshing All READMEs

To keep documentation up to date after changes, scan the root directory for all `README*.md` files and update them with any new features, scripts, or test instructions. You can automate this with a script or manually review and update each README as needed.

---

Enjoy your automated, reproducible, and secure macOS setup!
