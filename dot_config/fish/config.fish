# Show system info with fastfetch (SOTA) or fallback to neofetch
if type -q fastfetch
  fastfetch --logo ascii
else if type -q neofetch
  neofetch
end

# Modern CLI tool aliases with graceful fallback
if type -q eza
    alias ls 'eza --icons --git --color=auto --group-directories-first'
else if type -q exa
    alias ls 'exa --icons --git --color=auto --group-directories-first'
else if type -q lsd
    alias ls 'lsd --icon=auto'
else
    alias ls 'ls --color=auto'
end
if type -q sd
    alias sed 'sd'
else
    alias sed 'sed'
end
if type -q xh
    alias http 'xh'
else if type -q http
    alias http 'http'
else
    alias http 'curl'
end
if type -q gitui
    alias gui 'gitui'
end
if type -q rga
    alias rga 'rga'
end
if type -q batman
    alias batman 'batman'
end
if type -q batgrep
    alias batgrep 'batgrep'
end
if type -q batdiff
    alias batdiff 'batdiff'
end
if type -q onefetch
    alias onefetch 'onefetch'
end
# vivid LS_COLORS (https://github.com/sharkdp/vivid)
if type -q vivid
    set -x LS_COLORS (vivid generate catppuccin-mocha)
end
# Tool docs:
# eza: https://github.com/eza-community/eza
# vivid: https://github.com/sharkdp/vivid
# sd: https://github.com/chmln/sd
# xh: https://github.com/ducaale/xh
# gitui: https://github.com/extrawurst/gitui
# rga: https://github.com/phiresky/ripgrep-all
# bat-extras: https://github.com/eth-p/bat-extras
# onefetch: https://github.com/o2sh/onefetch

# Modern CLI tool aliases with graceful fallback
if type -q fd
    alias find 'fd'
else
    alias find 'find'
end
if type -q rg
    alias grep 'rg'
else
    alias grep 'grep'
end
if type -q bat
    alias cat 'bat --paging=never'
else
    alias cat 'cat'
end
if type -q dust
    alias du 'dust'
else
    alias du 'du'
end
if type -q delta
    alias diff 'delta'
else
    alias diff 'diff'
end
if type -q as-tree
    alias tree 'as-tree'
else
    alias tree 'tree'
end
if type -q bottom
    alias top 'bottom'
else
    alias top 'top'
end
if type -q broot
    alias broot 'broot'
end
if type -q dua
    alias dua 'dua'
end
if type -q dua-cli
    alias dua-cli 'dua-cli'
end
if type -q ncdu
    alias ncdu 'ncdu'
end
if type -q just
    alias just 'just'
end
if type -q atuin
    alias atuin 'atuin'
end
if type -q bandwhich
    alias bandwhich 'bandwhich'
end
if type -q hyperfine
    alias hyperfine 'hyperfine'
end
if type -q miniserve
    alias miniserve 'miniserve'
end
if type -q dog
    alias dog 'dog'
end
if type -q choose
    alias choose 'choose'
end
if type -q zoxide
    alias z 'zoxide'
    alias zi 'zoxide'
end
if type -q yazi
    alias y 'yazi'
end
if type -q lazygit
    alias lg 'lazygit'
end 