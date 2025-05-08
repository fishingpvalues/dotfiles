# Show system info with fastfetch (SOTA) or fallback to neofetch
if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --logo ascii
elif command -v neofetch >/dev/null 2>&1; then
  neofetch
fi 