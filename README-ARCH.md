# Arch Linux Dotfiles: Hyprland, Live Theming, and Automation

## Features

- **Hyprland**: Modern Wayland window manager with macOS-inspired look
- **Live Theme Switching**: Instantly switch between Forest, Water, and Desert themes for all major apps
- **Universal App Integration**: Kitty, WezTerm, Alacritty, Foot, tmux, btop, htop, ranger, lf, micro, helix, zellij, ncmpcpp, bat, starship, lazygit, neofetch, yazi, zathura, mako, swaylock, mpv, k9s, obsidian, dunst, waybar, rofi, VSCode, Firefox, GTK, Qt, and more
- **pywal/pywalfox**: Optional dynamic color extraction from wallpapers
- **Advanced GTK/Qt Tricks**: Fonts, accent color, and more
- **Auto-symlink wallpapers**: Ensures your wallpapers are always available

---

## 1. Prerequisites

- Arch Linux (fresh or existing install)
- Internet connection
- [yay](https://github.com/Jguer/yay) AUR helper (auto-installed)

---

## 2. Installation

### 2.1 Clone the Repo

```sh
git clone --recurse-submodules https://github.com/fishingpvalues/dotfiles.git
cd dotfiles
```

If you already cloned without submodules, run:

```sh
git submodule update --init --recursive
```

### 2.2 Install Everything

```sh
make install-hyprland
make postinstall
```

- Installs all required packages, AUR apps, and dotfiles
- Symlinks wallpapers to `~/Pictures/Wallpapers`

---

## 3. Theme Switching

### 3.1 Switch Theme Manually

```sh
bootstrap/scripts/unix/set_theme.sh forest   # or water, desert
```

### 3.2 Cycle Themes with Hotkey

- Default: `Super + T` (see `config/hyprland/hyprland.conf`)
- Binds to `bootstrap/scripts/unix/cycle_theme.sh`

### 3.3 What Gets Themed?

- **Waybar, Kitty, WezTerm, Rofi, Dunst, Mako, Alacritty, Foot, tmux, btop, htop, ranger, lf, micro, helix, zellij, ncmpcpp, bat, starship, lazygit, neofetch, yazi, zathura, swaylock, mpv, k9s, obsidian, VSCode, Firefox, GTK, Qt, and more**
- **Wallpaper**: Random from the respective theme folder
- **GTK/Qt**: Theme, icon, cursor, font, accent color
- **pywal/pywalfox**: If installed, wallpaper colors propagate to all supported apps

---

## 4. Adding/Editing Themes

- For each app, add `forest`, `water`, and `desert` theme files in the correct config directory (see `set_theme.sh` for paths)
- Example: `~/.config/btop/themes/forest.theme`, `~/.config/tmux/forest.conf`, etc.
- The script will symlink and reload them automatically

---

## 5. Live Reload/Advanced Tricks

- **Terminals**: Reloaded via signals (SIGUSR1)
- **Waybar**: Reloaded via signal
- **VSCode**: Reloaded via simulated Ctrl+R (if `wmctrl` and `xdotool` are installed)
- **Firefox**: Reloaded via HUP signal (and pywalfox if available)
- **btop, tmux, ranger, nvim, mako, zathura, k9s, zellij, ncmpcpp**: Reloaded via command or signal
- **GTK/Qt**: Fonts, accent color, and theme set via `gsettings` and `sed`
- **pywal/pywalfox**: If installed, run automatically on theme switch

---

## 6. Wallpapers

- Place your wallpapers in `media/wallpapers/forest/`, `media/wallpapers/water/`, `media/wallpapers/desert/`
- On install, these are symlinked to `~/Pictures/Wallpapers/`
- The theme switcher picks a random wallpaper from the current theme's folder

---

## 7. Customization

- Add more apps by following the symlink + reload pattern in `set_theme.sh`
- Add more themes by creating the appropriate config files
- Extend GTK/Qt tricks as needed

---

## 8. Troubleshooting

- If an app does not update, check its config path and reload command in `set_theme.sh`
- For pywal/pywalfox, ensure they are installed and configured
- For VSCode/Firefox, ensure they are running for live reload
- For GTK/Qt, ensure you have the correct theme and font packages installed

---

## 9. Credits

- Inspired by the Arch, Hyprland, and ricing communities
- pywal/pywalfox, WhiteSur themes, and all open-source projects used

---

## 10. Enjoy

You now have a fully modular, live-theming, macOS-inspired Arch Linux desktop. Switch themes, enjoy instant updates, and rice to your heart's content!

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
