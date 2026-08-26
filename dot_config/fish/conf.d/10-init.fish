# Tool init. Interactive only - every one of these installs keybindings or a
# prompt, which a script neither needs nor can use, and several are slow enough
# that running them for `ssh host somecommand` is noticeable.
status is-interactive; or exit

# Order matters exactly once: zoxide must come AFTER any cd wrapper, because it
# wraps cd itself.
command -q starship; and starship init fish | source
command -q zoxide; and zoxide init fish --cmd cd | source
command -q direnv; and direnv hook fish | source
command -q mise; and mise activate fish | source

# atuin replaces ctrl-r with a searchable history database. --disable-up-arrow
# keeps the up key doing fish's own prefix search, which is the faster motion
# for "the thing I ran a moment ago".
command -q atuin; and atuin init fish --disable-up-arrow | source

# Completions for tools that generate their own.
if command -q television
    tv init fish 2>/dev/null | source
end
