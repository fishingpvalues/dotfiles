# fish config. Interactive-only settings live here; anything that must apply to
# non-interactive shells (PATH, tool env) goes in conf.d/00-env.fish, which fish
# sources for every shell.

if not status is-interactive
    exit
end

set -g fish_greeting            # no banner

# vi keys, but keep the emacs bindings that everyone's fingers already know.
fish_vi_key_bindings
bind -M insert \cA beginning-of-line
bind -M insert \cE end-of-line
bind -M insert \cK kill-line
bind -M insert \cW backward-kill-word
bind -M insert \cF forward-char        # accept one char of the autosuggestion

# ctrl-f: accept the whole autosuggestion; alt-f: one word of it.
bind -M insert \cy accept-autosuggestion
bind -M insert \ef forward-word

# Cursor shape follows the mode, so you can see which one you are in.
set -g fish_cursor_default block
set -g fish_cursor_insert line
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block
