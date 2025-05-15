# macOS Setup Guide for dotfiles

## Quick Start (Recommended)

Open Terminal and run:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/fishingpvalues/dotfiles/main/setup-dotfiles-macos.sh)"
```

> Replace `fishingpvalues/dotfiles` with your actual GitHub repo path.

This will download and run the setup script in one step, even if you haven't cloned the repo yet.

---

This guide will help you set up this dotfiles repository on a fresh macOS system for a seamless, error-free developer experience.

---

## 1. Prerequisites

- macOS Sonoma, Ventura, or Monterey
- Xcode Command Line Tools
- [Homebrew](https://brew.sh/)

## 2. Install Xcode Command Line Tools

```sh
xcode-select --install || true
```

## 3. Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 4. Clone the Dotfiles Repo

```sh
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

## 5. Run the Bootstrap Script

```sh
chmod +x setup-dotfiles-macos.sh
./setup-dotfiles-macos.sh
```

## 6. What the Script Does

- Installs Homebrew and all packages in `dot_Brewfile`
- Installs fonts (FiraCode, JetBrains Mono, Cascadia Code, CaskaydiaCove Nerd Font, Noto Color Emoji)
- Installs Python and Node, and Neovim providers
- Installs chezmoi and applies all dotfiles

## 7. Manual Steps (if needed)

- If you use tmux, install `reattach-to-user-namespace` and add this to your `~/.tmux.conf`:

  ```
  set-option -g default-command "reattach-to-user-namespace -l zsh"
  ```

- If you use a clipboard manager, install [Maccy](https://maccy.app/) or [Clipy](https://clipy-app.com/).

## 8. Neovim Healthcheck

After install, run:

```sh
nvim --headless "+checkhealth" +qa
```

Fix any reported issues (usually missing Python/Node providers or fonts).

## 9. Troubleshooting

- **Homebrew not in PATH:** Add this to your `~/.zshrc`:

  ```sh
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/usr/local/bin:$PATH"
  ```

- **Fonts not showing:** Ensure all fonts in the fallback list are installed via Homebrew Cask.
- **Clipboard not working in tmux:** Ensure `reattach-to-user-namespace` is installed and configured.
- **Chezmoi errors:** Run `chezmoi doctor` and `chezmoi apply --dry-run` to diagnose.
- **WezTerm config errors:** Open WezTerm and check for Lua errors in the terminal.

## 10. Checklist

- [ ] Homebrew installed and in PATH
- [ ] All fonts installed via Homebrew Cask
- [ ] Clipboard works in Neovim, tmux, and WezTerm
- [ ] All configs symlinked via chezmoi
- [ ] Python/Node providers for Neovim installed
- [ ] All scripts are executable
- [ ] This README followed and bootstrap script run

---

## 11. Bootstrap Script Example

See `setup-dotfiles-macos.sh` in this repo for a one-command setup.

---

## 12. Support

If you encounter issues, open an issue on the repo or contact the maintainer.
