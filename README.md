# Cross-Platform Dotfiles

Welcome! This repository contains a fully cross-platform dotfiles and developer environment setup for macOS, Linux (Arch), and Windows. All configuration is managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

## 🚀 Quick Start (All Platforms)

1. **Install chezmoi** (see [chezmoi.io/install](https://www.chezmoi.io/install/) for more options):

   - **macOS (with Homebrew):**

     ```sh
     brew install chezmoi
     ```

   - **Arch Linux:**

     ```sh
     pacman -S chezmoi
     ```

   - **Windows (with Scoop):**

     ```powershell
     scoop install chezmoi
     ```

   - **Any OS (universal script):**

     ```sh
     sh -c "$(curl -fsLS get.chezmoi.io)" -- -b $HOME/.local/bin
     # or for Windows PowerShell
     (irm -useb get.chezmoi.io/ps1) | powershell -c -
     ```

2. **Clone and apply your dotfiles:**

   ```sh
   chezmoi init https://github.com/fishingpvalues/dotfiles.git
   chezmoi apply
   ```

3. **Run the setup script for your OS:**
   - **macOS/Linux:**

     ```sh
     ./bootstrap/setup-dotfiles.sh
     # For a fresh setup, add --reinit
     ./bootstrap/setup-dotfiles.sh --reinit
     ```

   - **Windows:**

     ```powershell
     ./bootstrap/setup-dotfiles.ps1
     # For a fresh setup, add -Reinit
     ./bootstrap/setup-dotfiles.ps1 -Reinit
     ```

4. **Done!** All tools, fonts, and configs will be installed automatically. See OS-specific guides for extra features and troubleshooting.

---

## 🖥️ OS-Specific Guides

- [macOS Guide & Tips](README-macOS.md)
- [Arch Linux/Hyprland Guide](README-ARCH.md)
- [Chezmoi Advanced Usage](CHEZMOI.md)

---

## 🛠️ What's Included?

- **Modern CLI tools** (fd, ripgrep, bat, fzf, broot, etc.)
- **Shells:** zsh, bash, PowerShell (with customizations and aliases)
- **Editors:** Neovim (modular config), VSCode
- **Dev Tools:** Docker, Python, Rust, Git, Kubernetes tools, etc.
- **Window Management:** Rectangle, Amethyst (macOS), PowerToys (Windows), Hyprland (Arch)
- **Fonts:** Nerd Fonts (MesloLGS, Fira Code, etc.)
- **Automated system tweaks** (macOS, Arch)
- **Unified test suite** for all platforms

See the OS-specific guides for full lists and details.

---

## 📝 Usage

- **Edit dotfiles:**

  ```sh
  chezmoi edit <file>
  ```

- **Add new config:**

  ```sh
  chezmoi add ~/.config/myapp/config.toml
  ```

- **Update dotfiles:**

  ```sh
  chezmoi update
  ```

- **Push/pull changes:**

  ```sh
  chezmoi cd   # enter source dir
  git add . && git commit -m "..." && git push
  # or use chezmoi git <args>
  ```

---

## ❓ FAQ

**Q: What OSes are supported?**
A: macOS, Arch Linux, and Windows (with PowerShell). Most configs are cross-platform.

**Q: How do I add my own configs?**
A: Use `chezmoi add <file>` and edit as needed. See [CHEZMOI.md](CHEZMOI.md) for advanced templating and secrets.

**Q: How do I update everything?**
A: Pull latest changes and run `chezmoi apply` and the setup script for your OS.

**Q: Something broke! How do I troubleshoot?**
A: See the troubleshooting section in your OS-specific guide. Most issues are solved by re-running the setup script or checking permissions.

**Q: How do I test my setup?**
A: Run the test scripts in the `test/` directory for your platform. All tests are also run in CI.

**Q: Are any hacking/security tools installed?**
A: No. All such tools have been removed for work compliance. Only developer and productivity tools are included.

---

## 📂 Project Structure

```
dotfiles/
  README.md
  README-macOS.md
  README-ARCH.md
  CHEZMOI.md
  bin/
  config/
  bootstrap/
  ...
```

---

## 🤝 Contributing

- Keep scripts modular and cross-platform.
- Add tests for new features.
- Document any new tools or configs.

---

For advanced usage, templating, and secrets, see [CHEZMOI.md](CHEZMOI.md).
