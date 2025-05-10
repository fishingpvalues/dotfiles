# Show system info with fastfetch (SOTA) or fallback to neofetch
if type -q fastfetch
  fastfetch --logo ascii
else if type -q neofetch
  neofetch
end

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