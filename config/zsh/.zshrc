# .zshrc - ZSH configuration file

# Enable Powerlevel10k instant prompt for faster startup. Should stay at the top of .zshrc
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Set the Zsh theme to Powerlevel10k
ZSH_THEME="powerlevel10k/powerlevel10k"

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt hist_ignore_dups
setopt hist_ignore_space
setopt share_history

# Speed-optimized plugins (carefully selected for balance)
plugins=(
  git                 # Git integration (low overhead, high value)
  zsh-autosuggestions # Command suggestions based on history
  fast-syntax-highlighting # Faster syntax highlighting than zsh-syntax-highlighting
  fzf                 # Fuzzy finder (loaded only when used)
  history-substring-search # History search (lightweight)
  direnv              # Directory-specific environment variables
  vi-mode             # Vim keybindings
  zsh-interactive-cd  # Better directory navigation with tab completion
  autojump            # Jump to directories with j command (faster than z)
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Basic auto/tab completion - precompiled for faster loading
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Environment variables
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias vim='nvim'
alias cd..='cd ..'

# Git aliases
alias g='git'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gco='git checkout'
alias ga='git add'
alias gb='git branch'
alias glog='git log'

# Better terminal commands (if available)
if command -v exa &> /dev/null; then
  alias ls='exa'
  alias ll='exa --long --header --icons --git'
  alias la='exa --all'
  alias lt='exa --tree --level=2'
fi

if command -v bat &> /dev/null; then
  alias cat='bat'
fi

# OS-specific aliases
if [[ "$(uname)" == "Darwin" ]]; then
  # macOS specific aliases
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
  
  # If brew exists, add its sbin to PATH
  if command -v brew &> /dev/null; then
    export PATH="$(brew --prefix)/sbin:$PATH"
  fi
elif [[ "$(uname)" == "Linux" ]]; then
  # Linux specific aliases
  if command -v pacman &> /dev/null; then
    # Arch Linux
    alias pacman='sudo pacman'
    alias update='sudo pacman -Syu'
    alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
  elif command -v apt-get &> /dev/null; then
    # Debian/Ubuntu
    alias update='sudo apt update && sudo apt upgrade'
    alias install='sudo apt install'
    alias remove='sudo apt remove'
    alias cleanup='sudo apt autoremove'
  fi
fi

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Enhanced navigation with fzf
if command -v fzf &> /dev/null; then
  export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git"
  
  # Load fzf keybindings and completion (lazy loading)
  fzf_load() {
    if [ -f ~/.fzf.zsh ]; then
      source ~/.fzf.zsh
    elif [ -f /usr/share/fzf/key-bindings.zsh ]; then
      source /usr/share/fzf/key-bindings.zsh
      source /usr/share/fzf/completion.zsh
    elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
      source /usr/share/doc/fzf/examples/key-bindings.zsh
      source /usr/share/doc/fzf/examples/completion.zsh
    fi
  }
  
  # Lazy-load FZF only when needed
  fzf-file-widget() { fzf_load; zle fzf-file-widget }
  zle -N fzf-file-widget
  bindkey '^T' fzf-file-widget
  
  fzf-cd-widget() { fzf_load; zle fzf-cd-widget }
  zle -N fzf-cd-widget
  bindkey '^G' fzf-cd-widget
  
  fzf-history-widget() { fzf_load; zle fzf-history-widget }
  zle -N fzf-history-widget
  bindkey '^R' fzf-history-widget
fi

# Load direnv if installed (with caching for performance)
if command -v direnv &> /dev/null; then
  export DIRENV_WARN_TIMEOUT=100s
  eval "$(direnv hook zsh)"
fi

# Add local bin to path
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Extract function
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar x "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Enhanced find file function
function ff() { find . -type f -name "*$1*"; }

# Enable vi-mode for Zsh with reduced latency
bindkey -v
export KEYTIMEOUT=1

# Add key bindings for history search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# System information (only run if terminal is interactive to speed up startup)
if [[ -o interactive ]]; then
  if command -v neofetch &> /dev/null; then
    neofetch
  elif command -v macchina &> /dev/null; then
    macchina
  fi
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh