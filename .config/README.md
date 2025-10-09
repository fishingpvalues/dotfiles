# Modern CLI Tools Configuration (SOTA 2025)

This directory contains state-of-the-art configurations for modern command-line tools, designed with vim-style keybindings and cross-platform compatibility (Mac/Linux/WSL).

## Configuration Philosophy

- **Vim-centric**: All tools use vim-style keybindings (hjkl navigation)
- **GitHub Dark theme**: Consistent color scheme across all tools
- **Minimal but powerful**: Essential features without bloat
- **Well-commented**: Each config explains its purpose and usage
- **Cross-platform**: Works on Mac, Linux, and WSL

## Tool Overview

### Shell & Terminal

- **atuin** - Magical shell history with sync and search
  - Config: `atuin/config.toml`
  - Features: Fuzzy search, workspace filtering, sync support

- **starship** - Fast, minimal prompt with vim mode indicators
  - Config: `starship/starship.toml`
  - Features: Git status, language versions, execution time

- **zoxide** - Smarter cd command that learns your patterns
  - Config: `zoxide/zoxide.env`
  - Usage: `z <partial-path>` or `zi` for interactive selection

- **tmux** - Terminal multiplexer with vim integration
  - Config: `tmux/.tmux.conf`
  - Features: Vim-tmux-navigator, session persistence, TPM plugins

- **zellij** - Modern tmux alternative (for experimentation)
  - Config: `zellij/config.kdl`
  - Features: Alt-based keybindings to avoid vim conflicts

### File Operations

- **bat** - Cat clone with syntax highlighting
  - Config: `bat/config`
  - Features: Line numbers, git integration, GitHub Dark theme

- **fd** - Fast find alternative
  - Config: `fd/ignore`
  - Features: Respects .gitignore, parallel search

- **ripgrep** - Fast grep alternative
  - Config: `ripgrep/ripgreprc`
  - Features: Smart case, custom file types, color output
  - Note: Set `export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc`

- **yazi** - Terminal file manager with vim keybindings
  - Config: `yazi/yazi.toml`, `yazi/keymap.toml`
  - Features: Preview, bulk operations, image support

### Git & Docker

- **lazygit** - Terminal UI for git
  - Config: `lazygit/config.yml`
  - Features: Vim keybindings, GitHub Dark theme, delta integration

- **lazydocker** - Terminal UI for Docker
  - Config: `lazydocker/config.yml`
  - Features: Container management, log viewing, vim navigation

- **delta** - Syntax-highlighting pager for git diff
  - Config: `delta/themes.gitconfig`
  - Features: Line numbers, side-by-side, syntax themes
  - Note: Include in your .gitconfig

### System Monitoring

- **btop** - System resource monitor
  - Config: `btop/btop.conf`
  - Features: Vim keybindings, GPU support, customizable layout

### Editors

- **helix** - Post-modern text editor
  - Config: `helix/config.toml`
  - Features: Built-in LSP, tree-sitter, vim-inspired keybindings
  - Note: Uses selection -> action model (different from vim)

- **nvim** - Neovim with extensive plugin setup
  - Config: `nvim/init.lua` + `nvim/lua/plugins/`
  - See nvim directory for detailed documentation

## Installation & Setup

### 1. Install Tools

```bash
# macOS (using Homebrew)
brew install atuin bat btop fd git-delta helix lazydocker lazygit ripgrep starship tmux yazi zellij zoxide

# Linux (Ubuntu/Debian)
# Use your package manager or install from releases
```

### 2. Symlink Configurations

```bash
# Option 1: Manual symlinks
ln -s ~/.dotfiles/.config ~/.config

# Option 2: Using stow (recommended)
cd ~/.dotfiles
stow -t ~ .config
```

### 3. Shell Integration

Add to your `.bashrc` or `.zshrc`:

```bash
# Atuin
eval "$(atuin init bash)"  # or zsh

# Starship
eval "$(starship init bash)"  # or zsh

# Zoxide
eval "$(zoxide init bash)"  # or zsh

# Ripgrep
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc

# Source zoxide config
[ -f ~/.config/zoxide/zoxide.env ] && source ~/.config/zoxide/zoxide.env
```

### 4. Git Configuration

Add to your `~/.gitconfig`:

```gitconfig
[include]
    path = ~/.config/delta/themes.gitconfig

[core]
    pager = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    features = github-dark
    navigate = true
```

### 5. Tmux Plugin Installation

```bash
# Clone TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux and install plugins
tmux
# Press Ctrl-a + I (capital i)
```

## Usage Tips

### Quick Reference

- **atuin**: `Ctrl+R` to search history
- **bat**: Use as `cat` replacement: `bat file.txt`
- **btop**: Press `h` for help, `q` to quit
- **fd**: `fd pattern` to find files
- **helix**: `:q` to quit, `:w` to save, `?` for help
- **lazygit**: `?` for help, `hjkl` to navigate, `q` to quit
- **lazydocker**: `?` for help, `l` for logs, `q` to quit
- **ripgrep**: `rg pattern` to search
- **starship**: Automatic prompt, shows git/language info
- **tmux**: `Ctrl-a` prefix, `Ctrl-a + ?` for help
- **yazi**: `hjkl` to navigate, `~` toggle hidden, `q` to quit
- **zellij**: `Alt+h/j/k/l` to navigate, `Alt+q` to quit
- **zoxide**: `z partial-path` to jump, `zi` for interactive

### Integration Examples

```bash
# Use bat with ripgrep for better output
rg "pattern" | bat

# Use fd with bat
fd "\.rs$" -x bat

# Use yazi with zoxide
# In yazi, press 'z' to use zoxide for quick jumps

# Use lazygit in tmux
# Ctrl-a + c (new window), then run 'lazygit'
```

## Customization

Each config file contains comments explaining options. Key customization points:

- **Colors**: All configs use GitHub Dark theme - modify theme sections
- **Keybindings**: Vim-style by default - check keymap sections
- **Performance**: Adjust timeouts, buffer sizes, and cache settings
- **Platform-specific**: Some configs have OS-specific sections

## Troubleshooting

### Ripgrep config not loading
```bash
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc
```

### Tmux colors look wrong
```bash
# Add to .bashrc/.zshrc
export TERM=xterm-256color
```

### Atuin not syncing
Check `~/.config/atuin/config.toml` and set sync_address

### Zoxide not tracking directories
Ensure `eval "$(zoxide init <shell>)"` is in shell config

## Additional Resources

- [Neovim config documentation](nvim/README.md)
- [Tmux setup guide](tmux/howto.md)
- Individual tool documentation in their config files

## SOTA (State of the Art) 2025

These configurations represent best practices as of 2025:
- Modern plugin managers (lazy.nvim, TPM)
- Async operations where supported
- Integration between tools
- Performance optimizations
- Security considerations (e.g., encrypted sync)
