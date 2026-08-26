# Abbreviations, not aliases.
#
# An abbreviation expands in place before it runs, so the history holds the real
# command. That matters the day you paste a line into a script, or onto a box
# that has none of this - an alias leaves you with `ll` and no idea what it was.
# Aliases are reserved below for the few cases where the expansion would be
# noise every single time.
status is-interactive; or exit

# --- ls -> eza -------------------------------------------------------------
abbr -a ls   'eza --group-directories-first --icons'
abbr -a ll   'eza -l --group-directories-first --icons --git --time-style=long-iso'
abbr -a la   'eza -la --group-directories-first --icons --git --time-style=long-iso'
abbr -a lt   'eza --tree --level=2 --icons --group-directories-first'
abbr -a ltt  'eza --tree --level=4 --icons --group-directories-first'
# Sorted by mtime, newest last, so the interesting file is next to the prompt.
abbr -a lr   'eza -l --sort=modified --reverse --icons --git --time-style=long-iso'

# --- the rest of the replacements ------------------------------------------
abbr -a cat  'bat'
abbr -a du   'dust'
abbr -a df   'duf'
abbr -a ps   'procs'
abbr -a top  'btop'
abbr -a dig  'doggo'
abbr -a ping 'gping'
abbr -a trace 'trip'
abbr -a curl 'xh'
abbr -a diff 'difft'

# --- git --------------------------------------------------------------------
# Deliberately few. lazygit is better than any alias for the interactive work;
# these are the ones worth typing.
abbr -a g    'git'
abbr -a gs   'git status --short --branch'
abbr -a gd   'git diff'
abbr -a gds  'git diff --staged'
abbr -a ga   'git add'
abbr -a gap  'git add --patch'
abbr -a gc   'git commit'
abbr -a gca  'git commit --amend'
abbr -a gp   'git push'
abbr -a gpl  'git pull --ff-only'
abbr -a gl   'git log --oneline --graph --decorate -20'
abbr -a gla  'git log --oneline --graph --decorate --all -30'
abbr -a gb   'git branch'
abbr -a gco  'git checkout'
abbr -a gsw  'git switch'
abbr -a gst  'git stash push -m'
abbr -a lg   'lazygit'

# --- docker -----------------------------------------------------------------
abbr -a d    'docker'
abbr -a dc   'docker compose'
abbr -a dps  'docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
abbr -a dpsa 'docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
abbr -a dlog 'docker logs -f --tail 100'
abbr -a lzd  'lazydocker'

# --- systemd ----------------------------------------------------------------
abbr -a sc   'systemctl'
abbr -a scu  'systemctl --user'
abbr -a jc   'journalctl'
abbr -a jcf  'journalctl -f'
abbr -a jcb  'journalctl -b -p warning'

# --- pacman -----------------------------------------------------------------
abbr -a pi   'sudo pacman -S --needed'
abbr -a pr   'sudo pacman -Rns'
abbr -a pu   'sudo pacman -Syu'
abbr -a pse  'pacman -Ss'
abbr -a pq   'pacman -Q'
# Which package owns this file - the question you always ask at the wrong time.
abbr -a pown 'pacman -Qo'

# --- misc -------------------------------------------------------------------
abbr -a v    'nvim'
abbr -a e    '$EDITOR'
abbr -a y    'yazi'
abbr -a cm   'chezmoi'
abbr -a cme  'chezmoi edit --apply'
abbr -a cma  'chezmoi apply -v'
abbr -a cmd  'chezmoi diff'
abbr -a cmu  'chezmoi update -v'
abbr -a ..   'cd ..'
abbr -a ...  'cd ../..'
abbr -a .... 'cd ../../..'

# Aliases, for the handful where seeing the expansion every time is just noise.
alias mkdir 'mkdir -p'
alias rm 'rm -i'
alias cp 'cp -i'
alias mv 'mv -i'
