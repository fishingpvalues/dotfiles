# Show system info with fastfetch (SOTA) or fallback to neofetch
if type -q fastfetch
  fastfetch --logo ascii
else if type -q neofetch
  neofetch
end

# Rust-powered tool aliases
alias find 'fd'
alias grep 'rg'
alias cat 'bat --paging=never'
alias du 'dust'
alias diff 'delta'
alias tree 'as-tree'
alias top 'bottom'
alias broot 'broot'
alias dua 'dua'
alias dua-cli 'dua-cli'
alias ncdu 'ncdu'
alias just 'just'
alias atuin 'atuin'
alias bandwhich 'bandwhich'
alias hyperfine 'hyperfine'
alias miniserve 'miniserve'
alias dog 'dog'
alias choose 'choose' 