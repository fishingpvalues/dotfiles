# dotfiles

CachyOS + Hyprland laptop (`sweetpotato`). Managed with
[chezmoi](https://chezmoi.io). Shell is **fish**.

    pacman -S --needed chezmoi
    chezmoi init --apply fishingpvalues/dotfiles

## What this owns, and what it does not

It owns the **shell and the terminal toolchain**: fish, starship, atuin, git,
neovim, and the config of every tool below.

It does **not** own the desktop. Hyprland, waybar, rofi, swaync, quickshell,
matugen, waypaper and wlogout stay with
[ML4W](https://github.com/mylinuxforwork/dotfiles), which installed and updates
them here. Two things managing one file is how a working desktop gets broken on
a Tuesday; `.chezmoiignore` keeps chezmoi out of that tree.

## Everyday commands

    chezmoi diff            what would change if you applied
    chezmoi apply -v        make it so
    chezmoi edit --apply    edit a file in the source tree and apply it
    chezmoi update -v       pull the repo and apply in one step
    chezmoi cd              drop into the source tree

Abbreviated as `cmd`, `cma`, `cme`, `cmu`, `cm`.

---

## The toolchain

Every package the install script puts on the machine, and why it is there.
59 in total; all are in the official CachyOS/Arch repos. `rustfmt` and
`goimports` are deliberately absent - they arrive with rustup and the go
toolchain, which `mise` manages per project rather than system-wide.

### Shell and prompt

| tool | what it is for |
|---|---|
| `fish` | the login shell. Sane defaults, real autosuggestions, no framework needed |
| `starship` | the prompt. Two lines, so a long path never pushes the cursor right |
| `atuin` | history as a SQLite database - host, directory, exit status, duration. Owns `ctrl-r` |
| `zoxide` | `cd` that jumps by any part of a directory name. Aliased over `cd` |
| `fzf` | the fuzzy finder everything else builds on |
| `direnv` | per-directory env, loaded on `cd` and unloaded on the way out |
| `mise` | per-project runtime versions (node, python, go) without a shim per language |

### Replacements for the coreutils

| instead of | use | why |
|---|---|---|
| `ls` | `eza` | git status per file, tree mode, sane colours |
| `cat` | `bat` | syntax highlighting, git gutter, paging |
| `grep` | `ripgrep` | respects .gitignore, orders of magnitude faster |
| `find` | `fd` | same, plus a syntax you can remember |
| `du` | `dust` | shows where the space actually went, as a tree |
| `df` | `duf` | readable, grouped by device type |
| `ps` | `procs` | tree view, colours, searches by anything |
| `top` | `btop`, `bottom` | `btop` to eyeball, `btm` for a quick look |
| `sed -i` | `sd` | literal strings by default, no escaping puzzles |
| `diff` | `difftastic` | compares syntax trees, not lines |

### Git

| tool | what it is for |
|---|---|
| `git-delta` | the pager. Syntax-highlighted diffs, `n`/`N` to jump between files |
| `lazygit` | the TUI. Staging hunks, rebasing, cherry-picking, all without the flags |
| `gitui` | a faster, smaller alternative when lazygit feels heavy |
| `git-absorb` | amends staged changes into the commit that introduced each line |

### Files, search, navigation

| tool | what it is for |
|---|---|
| `yazi` | file manager. Previews, batch rename, opens things in `$EDITOR` |
| `broot` | a tree you can search and act on, good for finding your way in a strange repo |
| `television` | a general fuzzy picker over files, git, processes, anything |
| `serpl` | find-and-replace across a project, with a preview before you commit to it |
| `ast-grep` | search and rewrite by **syntax tree** - "this call, but only when arg 2 is a literal", which ripgrep cannot express |
| `fclones` | finds and de-duplicates identical files |
| `ouch` | compress and decompress anything without remembering tar's flags |
| `dysk` | which filesystems exist, how full, and where they are mounted |

### Network

| tool | what it is for |
|---|---|
| `xh` | HTTP client. curl's job with a syntax you can type from memory |
| `dog` | DNS lookups, readable output. `dig` without the ceremony |
| `gping` | ping as a graph, so you can see a bad link rather than read it |
| `trippy` | traceroute and ping combined, live, per hop |

### Editors and multiplexing

| tool | what it is for |
|---|---|
| `neovim` | the editor. Config in `dot_config/nvim`, see below |
| `helix` | second editor, kept because it needs no config to be useful on a strange box |
| `tmux` | persistent sessions. `Ctrl-a` prefix, so it does not fight vim or the pager |

### Data and text

| tool | what it is for |
|---|---|
| `jq` | JSON. The one everything else assumes you have |
| `yq` | the same for YAML, which is most of what a homelab is made of |
| `glow` | renders markdown in the terminal instead of showing you the asterisks |

### Development

| tool | what it is for |
|---|---|
| `hyperfine` | benchmarks a command properly - warmup, repeats, statistics |
| `tokei` | counts code by language, fast, for "how big is this actually" |
| `navi` | a cheatsheet you can execute, for commands you use twice a year |
| `tealdeer` | `tldr` pages. Examples instead of a man page, when you want the common case |
| `stylua`, `shfmt`, `ruff`, `prettier`, `taplo` | formatters. conform.nvim calls these on save; without them format-on-save silently does nothing for that filetype |
| `just` | a command runner for per-project tasks, where make would be lying about being a build system |

### Containers

| tool | what it is for |
|---|---|
| `lazydocker` | containers, logs, stats, exec, in one screen |
| `dive` | image layers - why an image is 900 MB, which lazydocker will not tell you |

### Laptop hardware

Hyprland ships no settings panel. Without these, changing a network or an audio
sink means `nmcli` and `wpctl` from memory.

| tool | what it is for |
|---|---|
| `impala` | wifi |
| `bluetui` | bluetooth |
| `wiremix` | pipewire audio, sinks and volumes |

### Secrets

| tool | what it is for |
|---|---|
| `sops` | potatostack's `.env` is SOPS+age encrypted and this laptop administers that stack. Without it `make sops-decrypt` cannot run here |
| `age` | the encryption backend sops uses |

### Supporting

| tool | what it is for |
|---|---|
| `ttf-jetbrains-mono-nerd` | the font. Every icon in eza, starship, lazygit and yazi needs it |
| `wl-clipboard` | wayland clipboard. Neovim's `unnamedplus` and tmux copy-mode both go through it |

---

## Fish

`config.fish` holds interactive-only settings. Anything a **non-interactive**
shell also needs - PATH, `EDITOR`, `RIPGREP_CONFIG_PATH` - lives in
`conf.d/00-env.fish`, because `ssh host somecommand` needs those too.

### Abbreviations, not aliases

An abbreviation expands in place before it runs, so history holds the real
command. That matters the day you paste a line into a script or onto a machine
without these dotfiles. 61 of them; `abbr --list` shows the lot.

Aliases are reserved for the few where seeing the expansion every time is pure
noise: `mkdir -p`, and the interactive `rm`/`cp`/`mv`.

### Functions

Autoloaded, one per file, so they cost nothing at startup.

| function | what it does |
|---|---|
| `mkcd` | mkdir -p, then cd into it |
| `extract` | unpack any archive; uses `ouch` when present |
| `backup` | timestamped copy of a file next to the original |
| `dsh` | shell into a container, picking it with fzf; falls back to `sh` when there is no bash |
| `dips` | every container with its networks and IPs |
| `dmem` | real container memory from the **cgroup**. `docker stats` counts page cache, so it shows a container as near-OOM when it is nowhere near its limit |
| `dprune` | reclaim docker disk, showing what will go before it goes |
| `gclean` | delete local branches whose upstream is gone, with confirmation |
| `pot` | ssh to a potatostack host by short name |

### Keybindings

| key | does |
|---|---|
| `ctrl-r` | atuin history search |
| `ctrl-alt-f` | fzf file search |
| `ctrl-alt-d` | fzf directory search |
| `ctrl-alt-l` | fzf git log |
| `ctrl-alt-s` | fzf git status |
| `ctrl-alt-p` | fzf process search |
| `ctrl-v` | fzf variable search |
| `ctrl-y` | accept the whole autosuggestion |
| `alt-f` | accept one word of it |

Vi mode is on, with the emacs bindings your fingers already know kept:
`ctrl-a`, `ctrl-e`, `ctrl-k`, `ctrl-w`.

**`conf.d/zz-keybinds.fish` sorts last on purpose.** fzf.fish installs as
`conf.d/fzf.fish`, which sorts after `10-init.fish` where atuin binds `ctrl-r`,
so the plugin wins and you silently get fzf's history search instead of atuin's.
The `zz-` file puts atuin back. Check with `bind ctrl-r`; it must say
`_atuin_search`.

Plugins are pinned in `dot_config/fish/fish_plugins` and installed by a
`run_onchange_` script, so the set is reproducible.

## Neovim

Targets 0.11+. LSP servers are configured with the built-in `vim.lsp.config` /
`vim.lsp.enable`, not `lspconfig`'s `setup()` - that API is now in core and
nvim-lspconfig is only a bag of default server definitions.

| choice | over | because |
|---|---|---|
| `blink.cmp` | nvim-cmp | a fraction of the config, Rust fuzzy matcher |
| `fzf-lua` | telescope | shells out to fzf, stays fast on a big repo |
| `oil.nvim` | a file tree | edit the filesystem as a buffer; renaming ten files is a visual block edit |
| `mini.nvim` | five separate plugins | ai, surround, pairs, icons in one |
| `conform.nvim` | null-ls | format on save with a timeout, lsp as fallback |

`snacks.nvim` supplies the big-file guard, notifier and lazygit integration.
Leader is space; `<leader>ff` files, `<leader>fg` grep, `<leader>gg` lazygit.

## Layout

    .chezmoi.toml.tmpl        chezmoi's own config; no prompts, see below
    .chezmoiignore            what to leave on disk (the ML4W desktop)
    .chezmoiscripts/
      10-packages             installs the table above; re-runs when the list changes
      20-shell                makes fish the login shell
      30-fisher               installs dot_config/fish/fish_plugins
    dot_config/fish/          config.fish + conf.d/ + functions/
    dot_config/nvim/          init.lua + lua/{options,keymaps,lsp,plugins}
    dot_config/<tool>/        one directory per tool
    dot_gitconfig.tmpl        identity comes from .chezmoi.toml.tmpl data
    dot_bashrc                minimal, for scripts and the rescue case

### Two things that will bite you

**The scripts fail soft when `sudo` does not work.** chezmoi runs the package
script *before* it writes a single file, so a hard exit there means no dotfiles
at all on a machine whose only problem is that this user cannot escalate right
now. They print the command to run and carry on.

**There are no init prompts.** `promptStringOnce` opens `/dev/tty` directly and
dies with "could not open a new TTY" whenever chezmoi runs without one - over
ssh, from a script - and `--promptString` does not answer it, because it matches
the prompt *text* and not the field name. The git identity is static instead.
