# .bashrc - Bash configuration file

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment variables
export EDITOR="nvim"
export VISUAL="nvim"
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=10000

# Initialize Oh My Posh with GitHub Dark theme
export POSH_THEME="$HOME/.config/oh-my-posh/github-dark.omp.json"

# Check if Oh My Posh is installed and initialize it
if command -v oh-my-posh &> /dev/null; then
    eval "$(oh-my-posh init bash --config $POSH_THEME)"
else
    echo "Oh My Posh not found. Using default prompt."
    # Fallback prompt if Oh My Posh is not installed
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

# Aliases
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias vim='nvim'
alias pacman='sudo pacman'
alias update='sudo pacman -Syu'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Better directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

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
alias gl='git log'

# Load additional configs if they exist
[[ -f ~/.bash_aliases ]] && . ~/.bash_aliases
[[ -f ~/.bash_functions ]] && . ~/.bash_functions
[[ -f ~/.bash_local ]] && . ~/.bash_local

# Add local bin to path
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load zoxide for smart directory jumping if available
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init bash)"
    alias z='zoxide query'
    alias zi='zoxide query -i'
fi

# Enable fzf key bindings and completion if available
if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
fi

# Custom functions
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

# Find file by name
function ff() { find . -type f -name "*$1*"; }

# Display current Git branch in prompt if Oh My Posh isn't active
if ! command -v oh-my-posh &> /dev/null; then
    parse_git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
    }
    export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
fi

# Show system info with fastfetch (SOTA) or fallback to neofetch
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --logo ascii
elif command -v neofetch >/dev/null 2>&1; then
  neofetch
fi