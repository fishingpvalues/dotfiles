# ML4W Dotfiles Integration Guide

This guide explains how to integrate ML4W (My Linux 4 Work) dotfiles with this repository.

## What is ML4W?

ML4W is a comprehensive Hyprland-based desktop environment configuration for Arch Linux and derivatives. It provides:

- **Hyprland**: Dynamic tiling window manager
- **Material themes**: Adaptive color themes based on wallpaper
- **Full desktop experience**: Pre-configured apps, panels, and settings
- **Graphical configuration**: GUI apps for easy customization

**Official Resources:**
- GitHub: https://github.com/mylinuxforwork/dotfiles
- Documentation: https://mylinuxforwork.github.io/dotfiles/
- Website: https://www.ml4w.com/

## ML4W Architecture

ML4W uses a modular zsh configuration approach:

### File Structure
```
~/.zshrc                    # Main loader (DON'T MODIFY)
~/.config/zshrc/            # Modular configuration directory
├── 00-init                 # Initialization & exports
├── 20-customization        # Theme and prompt
├── 25-aliases              # Command aliases
└── 30-autostart            # Autostart commands
~/.config/zshrc/custom/     # User customizations (overrides)
~/.zshrc_custom             # Additional custom config
```

### How ML4W zshrc Works

1. **Main .zshrc**: Loads all files from `~/.config/zshrc/`
2. **Custom overrides**: Checks for `~/.config/zshrc/custom/` versions
3. **Priority**: Custom files override default files
4. **Single custom file**: Can also use `~/.zshrc_custom`

## Integration Options

### Option 1: Keep Both Separate (Recommended for Different Purposes)

**Use ML4W for:**
- Hyprland desktop environment
- Full Arch Linux setup
- GUI-configured desktop

**Use this dotfiles repo for:**
- CLI-focused workflows
- Cross-platform development (Mac/Linux/WSL)
- Neovim/tmux-centric setup

**How to switch:**
```bash
# Use ML4W zshrc
ln -sf ~/.config/ml4w-dotfiles/.zshrc ~/.zshrc

# Use this repo's zshrc
ln -sf ~/.dotfiles/.zshrc ~/.zshrc
```

### Option 2: Hybrid Approach (Best of Both Worlds)

Integrate this repo's tools into ML4W's structure:

#### Step 1: Install this dotfiles repo
```bash
cd ~
git clone <your-repo> ~/.dotfiles
cd ~/.dotfiles
./setup-all.sh
```

#### Step 2: Create ML4W custom directory
```bash
mkdir -p ~/.config/zshrc/custom
```

#### Step 3: Create custom integration file
```bash
cat > ~/.config/zshrc/custom/99-dotfiles-integration << 'EOF'
# Integration with ~/.dotfiles (SOTA 2025)

# Starship prompt (overrides ML4W's fastfetch)
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Zoxide (smart cd)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Atuin (shell history)
if command -v atuin &> /dev/null; then
    eval "$(atuin init zsh)"
fi

# Modern tool aliases
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

# Additional aliases from ~/.dotfiles
alias lg='lazygit'
alias ld='lazydocker'
alias fm='yazi'

# Source additional custom config if exists
[ -f ~/.dotfiles/.config/zshrc-custom ] && source ~/.dotfiles/.config/zshrc-custom
EOF
```

#### Step 4: Keep ML4W aliases that don't conflict
```bash
# ML4W aliases like ml4w-settings, cleanup, etc. will still work
# Your new aliases will override any conflicts
```

### Option 3: ML4W with Oh My Zsh (Full Integration)

Modify ML4W to use Oh My Zsh from this repo:

#### Step 1: Backup ML4W config
```bash
cp -r ~/.config/zshrc ~/.config/zshrc.backup
```

#### Step 2: Install Oh My Zsh
```bash
cd ~/.dotfiles
./install-ohmyzsh.sh
```

#### Step 3: Create ML4W-compatible custom loader
```bash
cat > ~/.config/zshrc/custom/10-ohmyzsh << 'EOF'
# Load Oh My Zsh (SOTA 2025)
export ZSH="$HOME/.oh-my-zsh"

# Oh My Zsh Configuration
DISABLE_AUTO_UPDATE="true"
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_COMPFIX="true"

# Plugins
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
  docker
  docker-compose
)

source $ZSH/oh-my-zsh.sh
EOF
```

## Integration Best Practices

### 1. Keep ML4W Hyprland-Specific Features

Don't override these ML4W features:
- Window manager aliases (Qtile, Hyprland commands)
- ML4W app launchers (ml4w-settings, ml4w-hyprland, etc.)
- System-specific scripts (cleanup, snapshot, diagnosis)

### 2. Add Modern CLI Tools

Enhance ML4W with modern tools from this repo:
- **bat** instead of cat (already in this repo)
- **fd** instead of find
- **ripgrep** instead of grep
- **lazygit** for git TUI
- **lazydocker** for docker TUI

### 3. Use Custom Directory

Always put customizations in `~/.config/zshrc/custom/` to survive ML4W updates:

```bash
~/.config/zshrc/custom/
├── 10-ohmyzsh           # Oh My Zsh integration
├── 50-tools             # Tool-specific config
└── 99-dotfiles-integration  # This repo's integration
```

### 4. Maintain Both Repos

```bash
# Update ML4W
cd ~/ml4w-dotfiles
git pull

# Update this dotfiles repo
cd ~/.dotfiles
git pull
./setup-all.sh
```

## Testing Your Setup

### Check What's Loaded
```bash
# See all sourced files
echo $fpath

# Check which zshrc files are loaded
ls -la ~/.config/zshrc/
ls -la ~/.config/zshrc/custom/
```

### Profile Startup Time
```bash
# Add to top of .zshrc
zmodload zsh/zprof

# Add to bottom of .zshrc
zprof

# Then run
exec zsh
```

### Verify Tools
```bash
# Check aliases
alias | grep -E "cat|grep|find|lg|ld"

# Check functions
which z
which zi
which starship
```

## Troubleshooting

### ML4W and Oh My Zsh Conflict
If both try to configure the same things:
1. Use `~/.config/zshrc/custom/` to override ML4W
2. Set variables before Oh My Zsh loads
3. Source Oh My Zsh early (in 10-* file)

### Slow Startup
```bash
# Profile to find bottlenecks
time zsh -i -c exit

# Compile all zsh files
zsh-compile-all

# Disable plugins you don't use
```

### Aliases Not Working
```bash
# Check load order
ls -1 ~/.config/zshrc/custom/

# Ensure your files are numbered > 25 to load after ML4W aliases
mv ~/.config/zshrc/custom/dotfiles-integration ~/.config/zshrc/custom/99-dotfiles-integration
```

## Recommended Setup for Different Use Cases

### Case 1: Hyprland Desktop + Development
- Use ML4W for desktop environment
- Add this repo's tools via custom integration
- Keep ML4W apps and keybindings

### Case 2: Multiple Machines
- Use ML4W on Linux desktop
- Use this repo on servers/macOS
- Sync tool configs via Git

### Case 3: Migration from ML4W
- Gradually add features from this repo
- Test in `~/.config/zshrc/custom/`
- Eventually replace ML4W's .zshrc with this repo's

## Summary

**For Hyprland users:**
- Keep ML4W for desktop environment
- Add modern CLI tools via custom integration
- Best of both worlds

**For CLI-focused users:**
- This repo is complete and standalone
- No need for ML4W unless using Hyprland
- Lighter and more portable

**For experimentation:**
- Try both approaches
- Use symlinks to switch easily
- Keep backups before modifying
