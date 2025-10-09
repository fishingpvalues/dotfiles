# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for Unix-like systems (Mac/Linux/WSL), primarily focused on modern terminal-based development tools. The repository uses a `.config/` directory structure following XDG Base Directory specifications.

## Architecture

### Configuration Structure

All configurations are stored in `.config/` organized by tool:

- **nvim/**: Neovim configuration based on kickstart.nvim with extensive customization
  - Uses `lazy.nvim` plugin manager
  - Modular plugin system with 60+ plugins in `lua/plugins/`
  - Each plugin has its own file in `lua/plugins/` that is imported via `lua/plugins/init.lua`
  - Main config entry point: `init.lua`
  - Plugin lockfile: `lazy-lock.json`

- **tmux/**: Tmux configuration with vim-style keybindings
  - Uses TPM (Tmux Plugin Manager) for plugin management
  - Configured with `Ctrl-a` prefix (vim-friendly)
  - Seamless integration with Neovim via vim-tmux-navigator
  - Supports session persistence with tmux-resurrect/continuum

- **Tool configs**: Various modern CLI tools with SOTA 2025 configurations:
  - **atuin**: Shell history with sync (`config.toml`)
  - **bat**: Cat replacement with syntax highlighting (`config`)
  - **btop**: System monitor with vim keys (`btop.conf`)
  - **delta**: Git diff with syntax highlighting (`themes.gitconfig`)
  - **fd**: Fast find alternative (`ignore`)
  - **helix**: Post-modern editor (`config.toml`)
  - **lazygit**: Git TUI with vim keybindings (`config.yml`)
  - **lazydocker**: Docker TUI (`config.yml`)
  - **ripgrep**: Fast grep alternative (`ripgreprc`)
  - **starship**: Minimal prompt (`starship.toml`)
  - **yazi**: File manager with vim keys (`yazi.toml`, `keymap.toml`)
  - **zellij**: Tmux alternative (`config.kdl`)
  - **zoxide**: Smart cd command (`zoxide.env`)

### Neovim Plugin Organization

The Neovim setup follows a modular architecture:

1. Core kickstart.nvim base (maintained in `init.lua`)
2. Plugin imports via `{ import = 'plugins' }` at line 274 of init.lua
3. Each plugin configuration lives in its own file under `lua/plugins/`
4. Categories include:
   - LSP/completion: lspconfig, mason, blink_cmp, lspsaga, none_ls
   - UI: lualine, github_dark, noice, incline, indent_blankline, fidget
   - Navigation: telescope (in init.lua), neo-tree, flash, yazi
   - Git: gitsigns (in init.lua), diffview
   - Development: debug, dap_ui, neotest, refactoring
   - Language-specific: rustaceanvim, golang, jupynium, kubernetes
   - Utilities: treesitter variants, ufo (folding), bqf, spectre, todo_comments

## Key Development Patterns

### Adding New Neovim Plugins

1. Create a new file in `.config/nvim/lua/plugins/<plugin-name>.lua`
2. Return a lazy.nvim plugin spec table
3. Add `require('plugins.<plugin-name>')` to `.config/nvim/lua/plugins/init.lua`
4. Restart Neovim or run `:Lazy sync`

### Neovim Plugin Management

```bash
# Check plugin status
nvim +Lazy

# Update all plugins
nvim +Lazy update

# Sync plugins with lockfile
nvim +Lazy sync
```

### Tmux Plugin Management

```bash
# Install TPM plugins (first time)
# Press Ctrl-a + I inside tmux

# Update plugins
# Press Ctrl-a + U inside tmux

# Reload config
# Press Ctrl-a + r inside tmux
```

## Configuration Philosophy

- **Modular**: Each tool has its own directory; each plugin has its own file
- **Modern**: Uses contemporary tools (lazy.nvim, blink.cmp, etc.)
- **Vim-centric**: Strong emphasis on vim keybindings across all tools
- **SOTA (State of the Art)**: Configurations are marked with "SOTA" comments indicating modern best practices
- **Cross-platform**: Designed to work on Mac/Linux (note: repository currently on Windows/MINGW environment)

## CLI Tool Management

### Shell Integration Required

Add to `.bashrc` or `.zshrc`:

```bash
# Atuin (shell history)
eval "$(atuin init bash)"  # or zsh

# Starship (prompt)
eval "$(starship init bash)"  # or zsh

# Zoxide (smart cd)
eval "$(zoxide init bash)"  # or zsh

# Ripgrep config
export RIPGREP_CONFIG_PATH=~/.config/ripgrep/ripgreprc
```

### Git Integration

Add to `~/.gitconfig`:

```gitconfig
[include]
    path = ~/.config/delta/themes.gitconfig
[core]
    pager = delta
[delta]
    features = github-dark
```

## Common Tool Commands

- **atuin**: `Ctrl+R` for history search
- **bat**: Drop-in `cat` replacement with syntax highlighting
- **btop**: `h` for help, vim keys for navigation
- **fd**: `fd pattern` to find files (respects .gitignore)
- **helix**: `:q` quit, `:w` save, `?` help (selection -> action model)
- **lazygit**: `?` help, `hjkl` navigation, integrates with Neovim
- **lazydocker**: `?` help, `l` logs, vim-style navigation
- **ripgrep**: `rg pattern` for fast searching
- **yazi**: `hjkl` navigation, `~` toggle hidden, integrates with zoxide
- **zellij**: Alt-based keys to avoid vim conflicts
- **zoxide**: `z partial-path` or `zi` for interactive jump

## Notes for AI Assistants

- When modifying Neovim plugins, always edit the specific plugin file in `lua/plugins/`, not `init.lua`
- All CLI tools use GitHub Dark theme and vim-style keybindings for consistency
- Each tool config includes SOTA comments explaining modern best practices
- Ripgrep requires RIPGREP_CONFIG_PATH environment variable
- Delta requires .gitconfig integration
- Tmux is configured for vim-tmux-navigator integration with Neovim
- Zellij uses Alt-based keybindings to avoid collisions with vim
- Plugin management uses modern tools (lazy.nvim for Neovim, TPM for Tmux)
- See `.config/README.md` for detailed setup and usage instructions
