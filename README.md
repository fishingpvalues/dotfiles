# Cross-Platform Dotfiles (Chezmoi-First, SOTA 2025)

[![CI](https://github.com/fishingpvalues/dotfiles/actions/workflows/act-dotfiles.yml/badge.svg)](https://github.com/fishingpvalues/dotfiles/actions)
![SOTA 2025 Ready](https://img.shields.io/badge/SOTA-2025-green)

Welcome! This repository is a fully cross-platform, **chezmoi-native** dotfiles and developer environment setup for macOS, Linux (Arch, Ubuntu, Armbian, Termux), and Windows. All configuration, scripts, and documentation are managed by [chezmoi](https://www.chezmoi.io/).

---

## 🚀 Quick Start (All Platforms)

1. **Clone this repo**

   ```sh
   git clone --recurse-submodules https://github.com/fishingpvalues/dotfiles.git
   cd dotfiles
   ```

2. **Initialize chezmoi with this repo as the source**

   ```sh
   chezmoi init --source="$PWD" --apply
   ```

   - This sets the current directory as the chezmoi source state.
   - All dotfiles, configs, and scripts will be applied to your home directory.

3. **Edit, add, or update configs using chezmoi**

   - **Edit a config:**

     ```sh
     chezmoi edit ~/.zshrc
     ```

   - **Add a new config:**

     ```sh
     chezmoi add ~/.config/myapp/config.toml
     ```

   - **Apply changes:**

     ```sh
     chezmoi apply
     ```

   - **Update from git:**

     ```sh
     chezmoi update
     ```

---

## 🛠️ Chezmoi-Managed Structure

All configs, scripts, and documentation are now managed by chezmoi. The `.chezmoiignore` has been updated to only exclude secrets, cache, build, and system files. **No more manual copying or install scripts required.**

**Key Directories:**

- `dot_config/` → `~/.config/`
- `bin/` → `~/bin/`
- `README.md`, `CHEZMOI.md`, etc. are managed and can be edited via chezmoi.

**File Naming:**

- Files like `.zshrc`, `.bashrc`, `starship.toml`, etc. are named for direct chezmoi compatibility.
- Remove any `dot_` prefix from config files (e.g., use `.zshrc`, not `dot_zshrc`).
- Use `.tmpl` suffix for templated configs if needed.

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
A: macOS, Arch Linux, Ubuntu, Armbian, Termux, and Windows. Most configs are cross-platform.

**Q: How do I add my own configs?**
A: Use `chezmoi add <file>` and edit as needed. See [CHEZMOI.md](CHEZMOI.md) for advanced templating and secrets.

**Q: How do I update everything?**
A: Pull latest changes and run `chezmoi apply` again.

**Q: Something broke! How do I troubleshoot?**
A: Run `chezmoi doctor` and check for errors. Most issues are solved by re-running `chezmoi apply` or checking permissions.

**Q: How do I test my setup?**
A: Run the test scripts in the `test/` directory for your platform. All tests are also run in CI.

**Q: Are any hacking/security tools installed?**
A: No. All such tools have been removed for work compliance. Only developer and productivity tools are included.

---

## 📂 Project Structure

```
dotfiles/
  README.md
  CHEZMOI.md
  bin/
  dot_config/
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
