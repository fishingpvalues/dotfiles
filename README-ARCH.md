# Arch Linux Dotfiles: Hyprland, Live Theming, and Automation

> For general installation and usage, see [README.md](README.md).

This guide covers Arch/Hyprland-specific setup, tips, and troubleshooting for this dotfiles repo. All configuration is managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

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

## Quick Start (Arch)

```sh
git clone --recurse-submodules https://github.com/fishingpvalues/dotfiles.git
cd dotfiles
make install-hyprland
make postinstall
```

- Installs all required packages, AUR apps, and dotfiles
- Symlinks wallpapers to `~/Pictures/Wallpapers`

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
A: Run `sudo pacman -S yay chezmoi` first.

**Q: Some apps don't update theme?**
A: Check their config path and reload command in `set_theme.sh`.

**Q: How do I re-run the setup?**
A: Just run `make install-hyprland` again. It's idempotent.

**Q: Are any hacking/security tools installed?**
A: No. All such tools have been removed for work compliance.

**Q: Where do I find more info or advanced usage?**
A: See [README.md](README.md) and [CHEZMOI.md](CHEZMOI.md).

---

## Automated Testing

- All setup scripts and configs are tested in CI and can be tested locally with the scripts in the `test/` directory.

---

Enjoy your modular, live-theming, macOS-inspired Arch Linux desktop!
