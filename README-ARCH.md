# Arch Linux Dotfiles: Hyprland, Live Theming, and Automation

> For general installation and usage, see [README.md](README.md).

This guide covers Arch/Hyprland-specific setup, tips, and troubleshooting for this dotfiles repo. All configuration is managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

---

## Quick Start (Arch)

```sh
./bootstrap/install-linux.sh
```

This script will install all required packages, AUR helper, AUR packages, apply your dotfiles, and set up conda.

---

## Features (Arch/Hyprland)

- Hyprland window manager with macOS-inspired look
- Live theme switching (Forest, Water, Desert) for all major apps
- Universal app integration (Kitty, WezTerm, Alacritty, tmux, btop, htop, ranger, lazygit, yazi, etc.)
- pywal/pywalfox support (optional)
- Auto-symlink wallpapers
- Automated system tweaks and package installs

---

## Prerequisites

- Arch Linux (fresh or existing install)
- Internet connection
- [yay](https://github.com/Jguer/yay) AUR helper (auto-installed)
- [chezmoi](https://www.chezmoi.io/): `pacman -S chezmoi`

---

## Theme Switching

- Switch theme manually:

  ```sh
  bootstrap/scripts/unix/set_theme.sh forest   # or water, desert
  ```

- Cycle themes with hotkey (default: Super + T, see `config/hyprland/hyprland.conf`)
- What gets themed: All major apps, wallpaper, GTK/Qt, pywal/pywalfox (if installed)

---

## Customization & Tips

- Add/edit themes: Add `forest`, `water`, `desert` theme files in the correct config directory (see `set_theme.sh` for paths)
- Add more apps: Follow the symlink + reload pattern in `set_theme.sh`
- Add more themes: Create the appropriate config files
- Extend GTK/Qt tricks as needed

---

## Troubleshooting & FAQ

**Q: yay or chezmoi not found?**
A: The script will install them if needed.

**Q: Some apps don't update theme?**
A: Check their config path and reload command in `set_theme.sh`.

**Q: How do I re-run the setup?**
A: Just run `./bootstrap/install-linux.sh` again. It's idempotent.

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

Enjoy your modular, live-theming, macOS-inspired Arch Linux desktop!
