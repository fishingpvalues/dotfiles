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

## 2025 SOTA CLI Tools (Recommended)

- **Ghostty**: GPU-accelerated terminal (`~/.config/ghostty/config`)
- **mise**: Universal version manager (`~/.config/mise/config.toml`)
- **Jujutsu**: Next-gen VCS, Git-compatible (`~/.config/jj/config.toml`)
- **code2**: AI-powered CLI workflows (`~/.config/code2/config.toml`)
- **BashBuddy**: Natural language shell helper (`~/.config/bashbuddy/config.toml`)
- **lsd**: Modern `ls` replacement (`~/.config/lsd/config.yaml`)
- **trash-cli**: Safe `rm` alternative (no config needed)

All are integrated and aliased for zsh/oh-my-zsh and Powerlevel10k. See `config/zsh/zshrc` for details.

---

Enjoy your automated, reproducible, and secure macOS setup!
