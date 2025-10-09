# Dotfiles Installation Guide

Complete setup guide for modern CLI tools with SOTA 2025 configurations.

## Quick Start

```bash
# 1. Clone the repository
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles

# 2. Create symlink
ln -sf ~/.dotfiles/.config ~/.config

# 3. Install tools (see below for your platform)

# 4. Setup shell integration (see Shell Configuration section)
```

## Tool Installation

### macOS (Homebrew)

```bash
# Core tools
brew install neovim tmux git

# Modern CLI replacements
brew install bat fd ripgrep fzf

# TUI applications
brew install lazygit lazydocker btop

# Navigation & history
brew install starship atuin zoxide

# File manager
brew install yazi

# Alternative multiplexer
brew install zellij

# Post-modern editor
brew install helix

# Git delta
brew install git-delta
```

### Linux (Ubuntu/Debian)

```bash
# Core tools
sudo apt update
sudo apt install neovim tmux git build-essential

# Modern CLI tools (may need to install from releases)
# Visit GitHub releases pages for:
# - bat: https://github.com/sharkdp/bat/releases
# - fd: https://github.com/sharkdp/fd/releases
# - ripgrep: https://github.com/BurntSushi/ripgrep/releases
# - lazygit: https://github.com/jesseduffield/lazygit/releases
# - lazydocker: https://github.com/jesseduffield/lazydocker/releases
# - starship: https://starship.rs/guide/#-installation
# - atuin: https://atuin.sh/docs/installation
# - zoxide: https://github.com/ajeetdsouza/zoxide/releases
# - yazi: https://github.com/sxyazi/yazi/releases
# - zellij: https://github.com/zellij-org/zellij/releases
# - helix: https://github.com/helix-editor/helix/releases
# - delta: https://github.com/dandavison/delta/releases

# Or use snap for some tools
sudo snap install btop
```

### Linux (Arch)

```bash
sudo pacman -S neovim tmux git \
    bat fd ripgrep fzf \
    lazygit btop \
    starship zoxide \
    helix git-delta

# Install from AUR
yay -S atuin lazydocker yazi zellij
```

## Configuration Setup

### 1. Neovim Setup

```bash
# Start Neovim (it will auto-install lazy.nvim)
nvim

# Inside Neovim, lazy.nvim will install all plugins automatically
# Wait for all installations to complete
```

### 2. Tmux Setup

```bash
# Install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Start tmux
tmux

# Install plugins: Press Ctrl-a + I (capital I)
# Wait for all plugins to install
```

### 3. Shell Configuration

Add to your `~/.bashrc` (Bash) or `~/.zshrc` (Zsh):

```bash
# ============================================
# Modern CLI Tools Integration
# ============================================

# Starship prompt
eval "$(starship init bash)"  # or: eval "$(starship init zsh)"

# Atuin (shell history)
eval "$(atuin init bash)"     # or: eval "$(atuin init zsh)"

# Zoxide (smart cd)
eval "$(zoxide init bash)"    # or: eval "$(zoxide init zsh)"

# Ripgrep configuration
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"

# Source zoxide environment variables
[ -f "$HOME/.config/zoxide/zoxide.env" ] && source "$HOME/.config/zoxide/zoxide.env"

# Bat theme
export BAT_THEME="GitHub"

# ============================================
# Aliases for modern tools
# ============================================

# Use modern alternatives
alias cat='bat'
alias find='fd'
alias grep='rg'
alias ls='eza'  # if you install eza

# Quick access to common tools
alias lg='lazygit'
alias ld='lazydocker'
alias fm='yazi'
```

### 4. Git Configuration

Add to your `~/.gitconfig`:

```gitconfig
[user]
    name = Your Name
    email = your.email@example.com

[include]
    path = ~/.config/delta/themes.gitconfig

[core]
    pager = delta
    editor = nvim

[interactive]
    diffFilter = delta --color-only

[delta]
    features = github-dark
    navigate = true
    line-numbers = true

[init]
    defaultBranch = main

[pull]
    rebase = true
```

### 5. Terminal Configuration

For best results, use a modern terminal emulator:

- **macOS**: WezTerm, iTerm2, or Alacritty
- **Linux**: WezTerm, Alacritty, or Kitty
- **Windows**: WezTerm, Windows Terminal, or Alacritty

Ensure your terminal:
- Supports true color (24-bit color)
- Uses a Nerd Font (for icons)
- Has proper clipboard integration

Recommended Nerd Fonts:
```bash
# macOS
brew tap homebrew/cask-fonts
brew install font-jetbrains-mono-nerd-font

# Linux - download from https://www.nerdfonts.com/
```

## Verification

### Test Each Tool

```bash
# Neovim
nvim --version
nvim +checkhealth

# Bat
bat --version
bat ~/.config/bat/config

# Ripgrep
rg --version
rg "test" ~/.config/

# Fd
fd --version
fd "config"

# Lazygit
lazygit --version
# Open in a git repo: cd <git-repo> && lazygit

# Starship
starship --version
# Should see custom prompt

# Atuin
atuin --version
# Press Ctrl+R to test history search

# Zoxide
zoxide query --list
# Use: z <partial-path>

# Yazi
yazi --version
# Test: yazi

# Btop
btop --version
# Test: btop (press q to quit)

# Helix
hx --version
# Test: hx file.txt

# Tmux
tmux -V
# Test: tmux (Ctrl-a + ? for help)
```

## Common Issues

### Neovim plugins not installing
```bash
# Inside Neovim
:Lazy sync
:Lazy restore
```

### Tmux colors wrong
```bash
# Add to shell config
export TERM=xterm-256color

# Or in tmux.conf (already configured)
set -g default-terminal "tmux-256color"
```

### Ripgrep config not loading
```bash
# Ensure environment variable is set
echo $RIPGREP_CONFIG_PATH
# Should output: /home/user/.config/ripgrep/ripgreprc

# Test with
rg --debug "test" 2>&1 | grep -i config
```

### Atuin not syncing
```bash
# Register for sync (optional)
atuin register -u <your-username> -e <your-email>
atuin login -u <your-username>

# Or use self-hosted server
# Edit ~/.config/atuin/config.toml
```

### Starship prompt not showing
```bash
# Ensure init is in shell config
grep "starship init" ~/.bashrc  # or ~/.zshrc

# Test manually
eval "$(starship init bash)"  # or zsh
```

### Zoxide not tracking
```bash
# Ensure init is in shell config
grep "zoxide init" ~/.bashrc  # or ~/.zshrc

# Test database
zoxide query --list

# Add directory manually
zoxide add /path/to/directory
```

## Next Steps

1. **Customize**: Edit configs in `~/.config/` to match your preferences
2. **Learn keybindings**: Each tool uses vim-style keys - press `?` for help
3. **Integrate workflows**: Tools work together (e.g., yazi + zoxide, rg + bat)
4. **Read documentation**: Check `~/.config/README.md` and individual config files

## Useful Resources

- [Neovim documentation](https://neovim.io/doc/)
- [Tmux documentation](https://github.com/tmux/tmux/wiki)
- [Starship configuration](https://starship.rs/config/)
- [Lazygit documentation](https://github.com/jesseduffield/lazygit)
- [Atuin documentation](https://atuin.sh/docs/)
- [Yazi documentation](https://yazi-rs.github.io/)

## Philosophy

These configurations follow:
- **SOTA 2025**: State-of-the-art best practices
- **Vim-centric**: Consistent vim keybindings across all tools
- **GitHub Dark**: Unified color scheme
- **Performance**: Optimized for speed and responsiveness
- **Integration**: Tools work seamlessly together

Enjoy your modern, vim-powered terminal environment!
