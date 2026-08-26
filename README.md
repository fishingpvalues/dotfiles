# dotfiles

CachyOS + Hyprland laptop (`sweetpotato`). Managed with
[chezmoi](https://chezmoi.io). Shell is **fish**.

    pacman -S --needed chezmoi
    chezmoi init --apply fishingpvalues/dotfiles

## What this owns, and what it does not

It owns the **shell and the terminal toolchain**: fish, starship, atuin, git,
neovim, and the config of every CLI tool below.

It does **not** own the desktop. Hyprland, waybar, rofi, swaync, quickshell,
matugen, waypaper and wlogout stay with
[ML4W](https://github.com/mylinuxforwork/dotfiles), which is what installed and
maintains them here. Two things managing the same file is how a working desktop
gets broken on a Tuesday; `.chezmoiignore` keeps chezmoi out of that tree.

## Layout

    .chezmoi.toml.tmpl        prompts for git identity on first init
    .chezmoiscripts/          package install, re-run when the list changes
    dot_config/fish/          config.fish + conf.d/ + functions/
    dot_config/nvim/          neovim, lazy.nvim, lsp via nvim 0.11+ API
    dot_config/<tool>/        one directory per CLI tool
    dot_gitconfig.tmpl        identity comes from the init prompts

## The tools, and why each one

Replacements for things that ship with the system:

| instead of | use | why |
|---|---|---|
| `ls` | `eza` | git status per file, tree mode, sane colours |
| `cat` | `bat` | syntax highlighting, git gutter, paging |
| `grep` | `rg` | respects .gitignore, orders of magnitude faster |
| `find` | `fd` | same, plus a sane default syntax |
| `du` | `dust` | shows where the space actually went |
| `df` | `duf` | readable, groups by device type |
| `ps` | `procs` | tree view, colours, searches by anything |
| `top` | `btop` / `btm` | btop for eyeballing, btm for a quick look |
| `sed -i` | `sd` | literal strings by default, no escaping puzzles |
| `cd` | `zoxide` | jumps to a directory by any part of its name |
| `ctrl-r` | `atuin` | history as a searchable database, not a text file |
| `diff` | `difft` | compares syntax trees, not lines |

Terminal UIs: `lazygit`, `lazydocker`, `dive` (image layers), `yazi` (files),
`gitui`, `broot`, `serpl` (find and replace), `television` (fuzzy picker),
`dysk` (disks).

Laptop hardware, because Hyprland ships no settings panel: `impala` (wifi),
`bluetui` (bluetooth), `wiremix` (pipewire). Without these, changing a wifi
network or an audio sink means `nmcli`/`wpctl` from memory.

Two that are here for a specific job rather than as a general upgrade:
`sops`, because potatostack's `.env` is SOPS+age encrypted and this laptop
administers it; and `ast-grep`, which matches the syntax tree rather than the
text - ripgrep cannot express "this call, but only when the second argument is
a literal".

## Conventions

Fish **abbreviations**, not aliases, for anything short. An abbreviation expands
in place before it runs, so what you see in your history is the real command -
which matters the day you paste it into a script or into a machine that does
not have these dotfiles.

Functions are for anything that takes an argument or needs logic. They live one
per file in `dot_config/fish/functions/` and are autoloaded, so they cost
nothing at startup.
