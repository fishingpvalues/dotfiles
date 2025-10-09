# Modern Dotfiles (SOTA 2025)

A complete, state-of-the-art configuration for modern command-line tools with vim-style keybindings and GitHub Dark theme.

## Overview

This repository contains carefully crafted configurations for 15+ modern CLI tools, all designed to work together seamlessly with a consistent vim-centric approach and unified color scheme.

### What's Included

**Editor & Multiplexer:**
- **Neovim** - 60+ plugins, LSP, debugging, testing
- **Tmux** - Session management with vim integration
- **Helix** - Post-modern editor alternative

**Shell & Navigation:**
- **Starship** - Fast, minimal prompt with vim mode
- **Atuin** - Magical shell history with sync
- **Zoxide** - Smart directory jumping

**File Operations:**
- **Bat** - Cat with syntax highlighting
- **Fd** - Fast file finding
- **Ripgrep** - Lightning-fast search
- **Yazi** - Terminal file manager

**Git & Docker:**
- **Lazygit** - Git TUI with vim keys
- **Lazydocker** - Docker TUI
- **Delta** - Beautiful git diffs

**System:**
- **Btop** - System monitor
- **Zellij** - Modern tmux alternative

## Features

- **Vim-centric**: All tools use vim-style keybindings (hjkl navigation)
- **Consistent theme**: GitHub Dark theme across all tools
- **Modern & Fast**: Rust-based tools for performance
- **Well-documented**: Every config file has detailed comments
- **Cross-platform**: Works on Mac, Linux, and WSL
- **Integrated**: Tools work seamlessly together

## Quick Start

```bash
# Clone repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# Read installation guide
cat INSTALL.md

# Symlink configs
ln -sf ~/.dotfiles/.config ~/.config

# Install tools for your platform (see INSTALL.md)
```

## Documentation

- **[INSTALL.md](INSTALL.md)** - Complete installation guide
- **[CLAUDE.md](CLAUDE.md)** - Repository architecture for AI assistants
- **[.config/README.md](.config/README.md)** - Tool configurations overview

## Configuration Philosophy

### SOTA (State of the Art) 2025
- Modern plugin managers (lazy.nvim, TPM)
- Performance optimizations
- Security best practices
- Latest tool versions

### Vim-Centric Design
- Consistent hjkl navigation
- Modal editing patterns
- Muscle memory friendly
- Minimal learning curve

### Integration Focus
- Tools complement each other
- Shared color scheme
- Cross-tool workflows
- Unified experience

## Screenshots

```
# Neovim with LSP, debugging, and file tree
┌─────────────────────────────────────┐
│ NeoTree │ Code with LSP hints      │
│          │ + line numbers           │
│          │ + git changes            │
│          │ + syntax highlighting    │
└─────────────────────────────────────┘

# Lazygit with GitHub Dark theme
┌─────────────────────────────────────┐
│ Status │ Commits │ Files │ Branches │
│ Vim-style navigation + git visual   │
└─────────────────────────────────────┘

# Tmux with multiple panes
┌─────────────────────────────────────┐
│ Neovim        │ Terminal            │
├───────────────┼─────────────────────┤
│ Lazygit       │ Btop                │
└─────────────────────────────────────┘
```

## Tool Integration Examples

```bash
# Search with ripgrep, view with bat
rg "function" --json | bat

# Find files with fd, open in yazi
fd ".rs" | xargs yazi

# Jump to directory, open lazygit
z project && lazygit

# Use yazi with zoxide integration
# Press 'z' in yazi to use zoxide
```

## Keybinding Quick Reference

All tools share vim-style navigation:

| Key | Action | Works In |
|-----|--------|----------|
| `h/j/k/l` | Navigate | All tools |
| `gg` | Go to top | Neovim, Yazi, Btop |
| `G` | Go to bottom | Neovim, Yazi, Btop |
| `/` | Search | Most tools |
| `?` | Help | Most tools |
| `q` | Quit | Most tools |
| `Ctrl+R` | History search | Atuin (in shell) |
| `Ctrl+a` | Tmux prefix | Tmux |
| `Alt+` | Zellij prefix | Zellij |

## Customization

Each config file includes:
- Detailed comments explaining options
- SOTA notes on best practices
- Platform-specific sections
- Integration tips

Edit configs in `~/.config/` to customize.

## Requirements

- Modern terminal with true color support
- Nerd Font for icons
- Git for version control
- Internet for initial plugin/tool downloads

## Platform Support

- ✅ macOS (primary)
- ✅ Linux (tested on Ubuntu, Arch)
- ✅ WSL2 (Windows Subsystem for Linux)
- ⚠️ Windows native (limited, use WSL2)

## Contributing

This is a personal dotfiles repository, but feel free to:
- Fork and adapt to your needs
- Open issues for questions
- Share improvements via PRs

## License

MIT License - Use freely, no attribution required.

## Acknowledgments

Built on the shoulders of giants:
- kickstart.nvim by TJ DeVries
- Modern CLI tools community
- Vim philosophy
- SOTA 2025 best practices

---

**Note**: These configurations are opinionated and vim-centric. If you prefer different keybindings or themes, they're easy to customize - all configs are well-documented and modular.
