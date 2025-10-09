# SOTA 2025 ZSH Configuration
# Performance-optimized with Oh My Zsh, modern plugins, and Starship prompt

# ============================================
# Performance Monitoring (uncomment to profile)
# ============================================
# zmodload zsh/zprof

# ============================================
# Oh My Zsh Configuration
# ============================================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Disable auto-update (manual control recommended)
DISABLE_AUTO_UPDATE="true"

# Disable magic functions for better performance
DISABLE_MAGIC_FUNCTIONS="true"

# Disable compfix warnings
DISABLE_COMPFIX="true"

# Uncomment if using SSH
# COMPLETION_WAITING_DOTS="true"

# Timestamp format for history
HIST_STAMPS="yyyy-mm-dd"

# ============================================
# SOTA Plugins (Essential Only)
# ============================================

plugins=(
  git                      # Git aliases and functions
  zsh-autosuggestions      # Fish-like autosuggestions
  zsh-syntax-highlighting  # Syntax highlighting for commands
  you-should-use           # Reminds you of aliases
  docker                   # Docker completions
  docker-compose           # Docker-compose completions
  sudo                     # ESC ESC to add sudo
  web-search               # Web search from terminal
  z                        # Jump around directories
  colored-man-pages        # Colorful man pages
  command-not-found        # Suggests packages for missing commands
  copyfile                 # Copy file contents to clipboard
  copybuffer               # Copy terminal buffer
  dirhistory               # Directory navigation with Alt+arrows
  extract                  # Extract any archive
  jsontools                # JSON manipulation
)

# ============================================
# Load Oh My Zsh
# ============================================

source $ZSH/oh-my-zsh.sh

# ============================================
# Performance Optimizations
# ============================================

# Aggressive completion caching
autoload -Uz compinit

# Only rebuild compdump once a day
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

# Compile zshrc for faster loading (auto-compiles on change)
if [[ ! -f ~/.zshrc.zwc ]] || [[ ~/.zshrc -nt ~/.zshrc.zwc ]]; then
  zcompile ~/.zshrc
fi

# ============================================
# Environment Variables
# ============================================

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

# Language
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Path additions
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"

# XDG Base Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Tool configurations
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/ripgreprc"
export BAT_THEME="GitHub"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always --style=numbers --line-range=:500 {}"'

# ============================================
# Starship Prompt (SOTA 2025)
# ============================================

if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# ============================================
# Modern CLI Tool Integration
# ============================================

# Zoxide (smart cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
  [ -f "$HOME/.config/zoxide/zoxide.env" ] && source "$HOME/.config/zoxide/zoxide.env"
fi

# Atuin (shell history)
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# FZF key bindings
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
fi

# ============================================
# Aliases (Modern Tools)
# ============================================

# Use modern alternatives
if command -v bat &> /dev/null; then
  alias cat='bat'
  alias catp='bat --plain'  # Plain output without decoration
fi

if command -v fd &> /dev/null; then
  alias find='fd'
fi

if command -v rg &> /dev/null; then
  alias grep='rg'
fi

if command -v eza &> /dev/null; then
  alias ls='eza --icons'
  alias ll='eza -lh --icons --git'
  alias la='eza -lah --icons --git'
  alias lt='eza -lh --icons --tree --level=2'
else
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# Git aliases (additional to oh-my-zsh)
alias gaa='git add --all'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'

# Quick access to tools
alias lg='lazygit'
alias ld='lazydocker'
alias fm='yazi'
alias v='nvim'
alias vim='nvim'
alias vi='nvim'

# System
alias update='sudo apt update && sudo apt upgrade -y'  # Debian/Ubuntu
# alias update='brew update && brew upgrade'            # macOS
# alias update='sudo pacman -Syu'                       # Arch

# Clipboard (platform-specific)
if command -v xclip &> /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
elif command -v wl-copy &> /dev/null; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi

# ============================================
# Helper Functions
# ============================================

# Quick file preview with fzf and bat
fzf-preview() {
  fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'
}

# Search and edit with ripgrep
rge() {
  local file
  file=$(rg --files-with-matches --no-messages "$1" | fzf --preview "bat --color=always {}")
  [[ -n $file ]] && ${EDITOR:-nvim} "$file"
}

# Create directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract any archive
# Note: Oh My Zsh extract plugin provides 'x' command

# Git clone and cd
gcl() {
  git clone "$1" && cd "$(basename "$1" .git)"
}

# Quick note taking
note() {
  local note_dir="$HOME/notes"
  mkdir -p "$note_dir"
  ${EDITOR:-nvim} "$note_dir/$(date +%Y-%m-%d).md"
}

# Find and kill process
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "$pid" | xargs kill -${1:-9}
  fi
}

# Fuzzy cd into directory
fcd() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git | fzf --preview 'tree -C -L 2 {}')
  [[ -n $dir ]] && cd "$dir"
}

# Update all tools
update-all() {
  echo "Updating system packages..."
  if command -v apt &> /dev/null; then
    sudo apt update && sudo apt upgrade -y
  elif command -v brew &> /dev/null; then
    brew update && brew upgrade
  elif command -v pacman &> /dev/null; then
    sudo pacman -Syu
  fi

  echo "Updating Oh My Zsh..."
  omz update

  echo "Updating Neovim plugins..."
  nvim --headless "+Lazy! sync" +qa

  echo "All updates complete!"
}

# Compile all zsh files for performance
zsh-compile-all() {
  echo "Compiling zsh files..."

  # Compile .zshrc
  zcompile ~/.zshrc

  # Compile Oh My Zsh files
  for f in ~/.oh-my-zsh/**/*.zsh; do
    zcompile "$f"
  done

  # Compile custom plugins
  for f in ~/.oh-my-zsh/custom/**/*.zsh; do
    zcompile "$f"
  done

  echo "Compilation complete! Restart your shell for changes."
}

# ============================================
# Key Bindings
# ============================================

# Vim mode
bindkey -v

# Better history search
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Edit command line in editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# ============================================
# History Configuration
# ============================================

HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history

setopt EXTENDED_HISTORY          # Write timestamp to history
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS      # Delete old duplicates
setopt HIST_FIND_NO_DUPS         # Don't display duplicates
setopt HIST_IGNORE_SPACE         # Don't record entries starting with space
setopt HIST_SAVE_NO_DUPS         # Don't write duplicates
setopt HIST_VERIFY               # Show before executing from history
setopt SHARE_HISTORY             # Share history between sessions

# ============================================
# Options
# ============================================

setopt AUTO_CD              # cd by typing directory name
setopt AUTO_PUSHD           # Push directories to stack
setopt PUSHD_IGNORE_DUPS    # Don't push duplicates
setopt PUSHD_SILENT         # Don't print directory stack
setopt CORRECT              # Correct command typos
setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode

# ============================================
# Platform-Specific Configuration
# ============================================

case "$(uname -s)" in
  Darwin*)
    # macOS specific settings
    export HOMEBREW_NO_AUTO_UPDATE=1
    ;;
  Linux*)
    # Linux specific settings
    ;;
  MINGW*|MSYS*)
    # Windows/Git Bash specific settings
    ;;
esac

# ============================================
# Local Configuration (optional)
# ============================================

# Source local configuration if it exists
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# ============================================
# Performance Monitoring (uncomment to see results)
# ============================================
# zprof

# SOTA Note: This configuration prioritizes performance with:
# - Minimal essential plugins only
# - Aggressive caching and zcompile
# - Starship for fast prompt
# - Modern tool integration (zoxide, atuin)
# - Vim bindings for consistency
# To profile startup time, uncomment zprof lines and run: zsh -i -c exit
