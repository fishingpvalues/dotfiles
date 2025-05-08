# Show system info with fastfetch (SOTA) or fallback to neofetch
if type -q fastfetch
  fastfetch --logo ascii
else if type -q neofetch
  neofetch
end 