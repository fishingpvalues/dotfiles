# Cross-Platform Dotfiles

[![CI](https://github.com/fishingpvalues/dotfiles/actions/workflows/act-dotfiles.yml/badge.svg)](https://github.com/fishingpvalues/dotfiles/actions)
![SOTA 2025 Ready](https://img.shields.io/badge/SOTA-2025-green)

Welcome! This repository contains a fully cross-platform dotfiles and developer environment setup for macOS, Linux (Arch), and Windows. All configuration is managed with [chezmoi](https://www.chezmoi.io/) and automated scripts.

## 🚀 Quick Start (All Platforms)

1. **Clone this repo**

   ```sh
   git clone --recurse-submodules https://github.com/fishingpvalues/dotfiles.git
   cd dotfiles
   ```

2. **Run the install script for your OS:**
   - **Linux:**

     ```sh
     ./bootstrap/install-linux.sh
     ```

   - **macOS:**

     ```sh
     ./bootstrap/install-macos.sh
     ```

   - **Windows (PowerShell):**

     ```powershell
     .\bootstrap\install-windows.ps1
     ```

3. **Done!** All tools, fonts, and configs will be installed automatically. See OS-specific guides for extra features and troubleshooting.

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

## 🚀 2025 SOTA CLI Tools (Recommended)

These are the latest, best-in-class, cross-platform CLI tools for developers, fully supported in this dotfiles repo:

| Tool         | Purpose                        | Config Location                  |
|--------------|-------------------------------|----------------------------------|
| **Ghostty**  | GPU-accelerated terminal      | `~/.config/ghostty/config`       |
| **mise**     | Universal version manager     | `~/.config/mise/config.toml`     |
| **Jujutsu**  | Next-gen VCS, Git-compatible | `~/.config/jj/config.toml`       |
| **code2**    | AI-powered CLI workflows      | `~/.config/code2/config.toml`    |
| **BashBuddy**| Natural language shell helper | `~/.config/bashbuddy/config.toml`|
| **lsd**      | Modern `ls` replacement       | `~/.config/lsd/config.yaml`      |
| **trash-cli**| Safe `rm` alternative         | N/A                              |

All tools are aliased and integrated for zsh/oh-my-zsh and Powerlevel10k. See `config/zsh/zshrc` for details.

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
A: Pull latest changes and run the install script for your OS again.

**Q: Something broke! How do I troubleshoot?**
A: See the troubleshooting section in your OS-specific guide. Most issues are solved by re-running the install script or checking permissions.

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

---

## 🚀 SOTA 2025 Upgrades & MCP/AI Automation

- **MCP/AI Health Checks:** Automated scripts (`bin/healthcheck-mcp.sh`, `bin/smart-config`) validate, monitor, and recommend SOTA settings for all configs and tools.
- **Self-Healing & Smart Config:** Detects config drift and offers auto-remediation or SOTA recommendations.
- **Security:** [Security policy](SECURITY.md) and responsible disclosure process. Secrets are always ignored and never committed.
- **CI/CD:** Unified, cross-platform CI with scheduled health checks, secret scanning, and SAST.
- **Documentation:** SOTA compliance and CI status badges, clear contribution and security guidelines.
