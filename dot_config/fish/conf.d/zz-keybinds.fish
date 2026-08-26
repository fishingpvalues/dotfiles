# Runs LAST, on purpose. Everything in conf.d is sourced in lexical order, so
# "zz-" sorts after every plugin fisher drops in here.
#
# This exists because fzf.fish binds ctrl-r to its own history search, and it
# installs as conf.d/fzf.fish - which sorts AFTER 10-init.fish, where atuin
# binds ctrl-r. The plugin therefore wins, silently, and you get fzf's history
# search instead of atuin's. Verified: `bind ctrl-r` reported
# `_fzf_search_history` before this file existed.
#
# atuin is the one we want for history: it is a database with host, directory,
# exit status and duration, not a grep over a text file. fzf.fish's OTHER
# bindings are genuinely good and are left alone:
#     ctrl-alt-f  file search        ctrl-alt-l  git log
#     ctrl-alt-s  git status         ctrl-alt-p  process search
#     ctrl-alt-d  directory search   ctrl-v      variable search
status is-interactive; or exit

if functions -q _atuin_search
    bind ctrl-r _atuin_search
    bind -M insert ctrl-r _atuin_search
    bind -M default ctrl-r _atuin_search
end
