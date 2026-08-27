# Environment. Sourced for EVERY shell, interactive or not - a script run over
# ssh needs PATH and EDITOR just as much as a terminal does.

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER 'nvim +Man!'          # man pages with syntax highlighting
set -gx LESS '-R --mouse --incsearch'

# XDG, spelled out. Half the tools below only put their droppings in the right
# place if these are set explicitly.
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache

# ripgrep only reads its config file if this points at it. There is no default
# path - miss this and rg silently ignores every setting in ripgreprc.
set -gx RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/ripgreprc

set -gx BAT_THEME "Visual Studio Dark+"
set -gx SYSTEMD_PAGER ''               # systemctl in a pager is a menace

# fzf: use fd (respects .gitignore) and preview with bat/eza.
set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
set -gx FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -gx FZF_DEFAULT_OPTS '--height 60% --layout=reverse --border --info=inline'
set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --follow --exclude .git'
set -gx FZF_ALT_C_OPTS "--preview 'eza --tree --level=2 --colour=always {}'"

fish_add_path -g $HOME/.local/bin $HOME/.cargo/bin
