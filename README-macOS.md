# macOS Dotfiles & System Automation

> For general installation and usage, see [README.md](README.md).

This guide covers macOS-specific setup, tips, and troubleshooting for this dotfiles repo. All configuration is managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

---

## Quick Start (macOS)

```sh
./bootstrap/install-macos.sh
```

This script will install Homebrew (if needed), all required packages, apply your dotfiles, and set up conda.

---

## Features (macOS)

- Automated system tweaks: UI/UX, keyboard, Finder, Dock, Safari, Mail, Terminal, Chrome, Spotlight, and more
- App install & configuration: Homebrew, CLI tools, terminal emulators, developer tools, fonts
- Cross-platform dotfiles: Shared config for zsh, bash, git, neovim, kitty, wezterm, starship, tmux, fzf, and more
- Safe & reproducible: All scripts are idempotent and can be re-run safely

---

## Customization & Tips

- **Edit dotfiles:** `chezmoi edit <file>`
- **Add new config:** `chezmoi add ~/.config/myapp/config.toml`
- **Update dotfiles:** `chezmoi update`
- **Push/pull changes:** Use `chezmoi cd` to enter the source dir, then use git as usual
- **macOS tweaks:** Edit `bootstrap/.macos/.macos` or scripts in `bootstrap/.macos/apps/` for system/app settings
- **App lists:** Edit `dot_Brewfile` to add/remove Homebrew apps

---

## Troubleshooting & FAQ

**Q: Some settings require sudo or Security & Privacy approval?**
A: Yes, especially for system tweaks. Grant permissions as prompted.

**Q: Xcode Command Line Tools or Homebrew missing?**
A: The script will prompt you to install them if needed.

**Q: Some tweaks don't work on the latest macOS?**
A: Some settings may need updates for the latest OS. Check for errors and update scripts as needed.

**Q: How do I re-run the setup?**
A: Just run `./bootstrap/install-macos.sh` again. It's idempotent.

**Q: Are any hacking/security tools installed?**
A: No. All such tools have been removed for work compliance.

**Q: Where do I find more info or advanced usage?**
A: See [README.md](README.md) and [CHEZMOI.md](CHEZMOI.md).

---

## Automated Testing

- All setup scripts and configs are tested in CI and can be tested locally with the scripts in the `test/` directory.

---

Enjoy your automated, reproducible, and secure macOS setup!
