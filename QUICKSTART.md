# Quick Start Guide

Get up and running with modern CLI tools in 5 minutes!

## One-Command Setup

### macOS / Linux
```bash
git clone <your-repo-url> ~/.dotfiles && cd ~/.dotfiles && ./setup-all.sh
```

### Windows (PowerShell)
```powershell
git clone <your-repo-url> ~\.dotfiles; cd ~\.dotfiles; .\setup-all.ps1
```

## What Gets Installed

✅ **15+ Modern CLI Tools**
- Neovim, tmux, git, bat, fd, ripgrep
- lazygit, lazydocker, btop, yazi
- starship, atuin, zoxide

✅ **SOTA Configurations**
- Oh My Zsh with performance optimizations
- Vim keybindings everywhere
- GitHub Dark theme across all tools

✅ **Shell Integration**
- Smart command history (atuin)
- Fast directory jumping (zoxide)
- Beautiful prompt (starship)
- Auto-suggestions & syntax highlighting

## Quick Commands After Installation

```bash
# Restart shell
exec zsh  # or exec bash

# Check installed tools
make check

# Start using modern tools
lg        # lazygit (git TUI)
ld        # lazydocker (docker TUI)
fm        # yazi (file manager)
btop      # system monitor
z <path>  # quick jump
Ctrl+R    # search history
```

## Directory Structure

```
~/.dotfiles/
├── .config/           # All tool configurations
│   ├── nvim/          # Neovim (60+ plugins)
│   ├── tmux/          # Tmux with vim integration
│   ├── bat/           # Syntax highlighting
│   ├── lazygit/       # Git TUI
│   ├── starship/      # Prompt
│   └── ...            # 10+ more tools
├── .zshrc             # Oh My Zsh SOTA configuration
├── setup-all.sh       # Complete setup script
└── Makefile           # Easy commands
```

## Essential Keybindings

All tools use vim-style navigation:

| Key | Action | Works In |
|-----|--------|----------|
| `hjkl` | Navigate | All tools |
| `gg` / `G` | Top / Bottom | Most tools |
| `/` | Search | Most tools |
| `?` | Help | Most tools |
| `q` | Quit | Most tools |
| `Ctrl+R` | History search | Shell (atuin) |
| `Ctrl+a` | Tmux prefix | Tmux |

## Tool-Specific Quick Reference

### Neovim
```
<Space>   - Leader key
<Space>sf - Search files (telescope)
<Space>sg - Search grep
<Space>e  - File tree (neo-tree)
:Lazy     - Plugin manager
```

### Lazygit
```
hjkl      - Navigate
<Space>   - Stage/unstage
c         - Commit
P         - Push
p         - Pull
?         - Help
```

### Yazi (File Manager)
```
hjkl      - Navigate
<Space>   - Select
<Enter>   - Open
~         - Toggle hidden
z         - Jump with zoxide
```

### Zoxide
```
z project - Jump to "project" directory
zi        - Interactive selection with fzf
z -       - Go to previous directory
```

## Customization

### Edit Configurations
```bash
# Neovim plugins
nvim ~/.config/nvim/lua/plugins/

# Shell config
nvim ~/.zshrc

# Tool configs
cd ~/.config
ls -la
```

### Add Custom Aliases
```bash
# Add to ~/.zshrc or ~/.zshrc_custom
alias myalias='command'
```

### Change Theme
All tools use GitHub Dark theme. To change:
- Edit color settings in each tool's config
- Files are in `~/.config/<tool>/`

## Troubleshooting

### Tools not found
```bash
# Check installation
make check

# Install missing tools
./install-macos.sh  # or install-linux.sh
```

### Slow shell startup
```bash
# Profile startup
time zsh -i -c exit

# Compile zsh files
zsh-compile-all
```

### Config not loading
```bash
# Verify symlink
ls -la ~/.config

# Re-run setup
./setup-all.sh
```

## Advanced Features

### Oh My Zsh Integration
- Pre-configured with essential plugins
- zcompile optimization
- Compatible with ML4W dotfiles (see ML4W-INTEGRATION.md)

### Performance Optimizations
- Compiled zsh files (.zwc)
- Aggressive completion caching
- Lazy loading where possible
- Startup time: < 100ms

### Cross-Platform
- Works on macOS, Linux, WSL
- Platform-specific configs included
- Scoop integration for Windows

## Next Steps

1. **Customize**: Edit configs in `~/.config/`
2. **Learn**: Press `?` in any tool for help
3. **Integrate**: Add to your workflow gradually
4. **Share**: Fork and adapt to your needs

## Getting Help

- **Documentation**: See INSTALL.md for detailed setup
- **Tool Configs**: Check .config/README.md
- **ML4W Integration**: See ML4W-INTEGRATION.md
- **Issues**: Check tool-specific documentation

## Pro Tips

```bash
# Search files and preview
fzf-preview

# Search and edit
rge "pattern"

# Create and cd
mkcd new-directory

# Git clone and cd
gcl https://github.com/user/repo

# Update everything
update-all
```

Happy hacking! 🚀
