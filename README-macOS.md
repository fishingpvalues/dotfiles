# macOS Dotfiles & System Automation

> For general installation and usage, see [README.md](README.md).

This guide covers macOS-specific setup, tips, and troubleshooting for this dotfiles repo. All configuration is managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

---

## Features (macOS)

- Automated system tweaks: UI/UX, keyboard, Finder, Dock, Safari, Mail, Terminal, Chrome, Spotlight, and more
- App install & configuration: Homebrew, CLI tools, terminal emulators, developer tools, fonts
- Cross-platform dotfiles: Shared config for zsh, bash, git, neovim, kitty, wezterm, starship, tmux, fzf, and more
- Safe & reproducible: All scripts are idempotent and can be re-run safely

---

## Prerequisites

- macOS (recent version recommended)
- [Xcode Command Line Tools](https://developer.apple.com/xcode/resources/): `xcode-select --install`
- [Homebrew](https://brew.sh/): `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
- [chezmoi](https://www.chezmoi.io/): `brew install chezmoi`

---

## Quick Start (macOS)

```sh
chezmoi init https://github.com/fishingpvalues/dotfiles.git
chezmoi apply
./bootstrap/setup-dotfiles.sh
# For a fresh setup, add --reinit
./bootstrap/setup-dotfiles.sh --reinit
```

---

## What Gets Configured?

- System tweaks (UI/UX, keyboard, Finder, Dock, etc.)
- App installs (WezTerm, kitty, zsh, bash, exa, bat, fzf, ripgrep, fd, starship, lazygit, neofetch, btop, tmux, wget, curl, git, ssh, Neovim, VSCode, Nerd Fonts, Rectangle, Amethyst, and more)
- All tools are open source or from official sources. No hacking/security tools are installed (for work compliance).

---

## Customization & Tips

- **Edit dotfiles:** `chezmoi edit <file>`
- **Add new config:** `chezmoi add ~/.config/myapp/config.toml`
- **Update dotfiles:** `chezmoi update`
- **Push/pull changes:** Use `chezmoi cd` to enter the source dir, then use git as usual
- **macOS tweaks:** Edit `bootstrap/.macos/.macos` or scripts in `bootstrap/.macos/apps/` for system/app settings
- **App lists:** Edit `bootstrap/dot_Brewfile` to add/remove Homebrew apps

---

## Troubleshooting & FAQ

**Q: Some settings require sudo or Security & Privacy approval?**
A: Yes, especially for system tweaks. Grant permissions as prompted.

**Q: Xcode Command Line Tools or Homebrew missing?**
A: Install them as shown above before running the setup script.

**Q: Some tweaks don't work on the latest macOS?**
A: Some settings may need updates for the latest OS. Check for errors and update scripts as needed.

**Q: How do I re-run the setup?**
A: Just run `./bootstrap/setup-dotfiles.sh` again. It's idempotent.

**Q: Are any hacking/security tools installed?**
A: No. All such tools have been removed for work compliance.

**Q: Where do I find more info or advanced usage?**
A: See [README.md](README.md) and [CHEZMOI.md](CHEZMOI.md).

---

## Automated Testing

- All setup scripts and configs are tested in CI and can be tested locally with the scripts in the `test/` directory.

---

Enjoy your automated, reproducible, and secure macOS setup!
