# Nushell Config File
# GitHub: https://github.com/nushell/nushell

# Load environment from the default location
source ~/.config/nushell/env.nu

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
let dark_theme = {
    # Github Dark Colors
    separator: "#c9d1d9"
    leading_trailing_space_bg: { attr: n }
    header: { fg: "#58a6ff" attr: b }
    empty: "#58a6ff"
    bool: "#56d364"
    int: "#d2a8ff"
    filesize: "#56d364"
    duration: "#d2a8ff"
    date: "#56d364"
    range: "#d2a8ff"
    float: "#d2a8ff"
    string: "#e3b341"
    nothing: "#c9d1d9"
    binary: "#d2a8ff"
    cell-path: "#e3b341"
    row_index: { fg: "#58a6ff" attr: b }
    record: "#56d364"
    list: "#56d364"
    block: "#56d364"
    hints: "#6e7681"
    search_result: { fg: "#0d1117" bg: "#58a6ff" }
    shape_and: { fg: "#bc8cff" attr: b }
    shape_binary: { fg: "#bc8cff" attr: b }
    shape_block: { fg: "#79c0ff" attr: b }
    shape_bool: "#56d364"
    shape_custom: "#58a6ff"
    shape_datetime: { fg: "#56d364" attr: b }
    shape_directory: "#56d364"
    shape_external: "#56d364"
    shape_externalarg: { fg: "#58a6ff" attr: b }
    shape_filepath: "#56d364"
    shape_flag: { fg: "#58a6ff" attr: b }
    shape_float: { fg: "#d2a8ff" attr: b }
    shape_garbage: { fg: "#f0f6fc" bg: "#ff7b72" attr: b }
    shape_globpattern: { fg: "#56d364" attr: b }
    shape_int: { fg: "#d2a8ff" attr: b }
    shape_internalcall: { fg: "#56d364" attr: b }
    shape_list: { fg: "#56d364" attr: b }
    shape_literal: "#58a6ff"
    shape_match_pattern: "#58a6ff"
    shape_matching_brackets: { attr: u }
    shape_nothing: "#c9d1d9"
    shape_operator: "#ffa198"
    shape_or: { fg: "#bc8cff" attr: b }
    shape_pipe: { fg: "#bc8cff" attr: b }
    shape_range: { fg: "#ffa198" attr: b }
    shape_record: { fg: "#56d364" attr: b }
    shape_redirection: { fg: "#bc8cff" attr: b }
    shape_signature: { fg: "#58a6ff" attr: b }
    shape_string: "#e3b341"
    shape_string_interpolation: { fg: "#56d364" attr: b }
    shape_table: { fg: "#58a6ff" attr: b }
    shape_variable: "#d2a8ff"
    shape_vardecl: "#79c0ff"

    background: "#0d1117"
    foreground: "#c9d1d9"
    cursor: "#c9d1d9"
}

# External completer example
let fish_completer = {|spans|
    fish --command $"complete "--do-complete=($spans | str join ' ')"" | 
    $"value\tdescription" | 
    str replace --all '\t' '|' |
    from tsv --flexible --no-infer
}

# The default config record. This is where much of your global configuration is setup.
$env.config = {
    show_banner: false # hide the welcome banner
    completions: {
        case_sensitive: false # case-insensitive completions
        quick: true    # recommended especially for fzf users
        partial: true  # enable autocompletion of partial commands
        algorithm: "prefix" # prefix or fuzzy
        external: {
            enable: true # enable external completions
            max_results: 100 # maximum number of external completion results
            completer: $fish_completer # use fish for external completions
        }
    }
    color_config: $dark_theme # colors based on github-dark theme
    cursor_shape: {
        emacs: block # block or underscore
        vi_insert: block # block, underscore, or line
        vi_normal: underscore # block, underscore, or line
    }
    edit_mode: emacs # emacs or vi
    history: {
        file_format: "plaintext" # sqlite or plaintext
        max_size: 100_000 # maximum number of history entries
        sync_on_enter: true # sync history on enter
        isolation: false # history isolation between panes/tabs
    }
    keybindings: [
        {
            name: fzf_search_history
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: {
                send: executehostcommand
                cmd: "commandline (history | each { |it| $it.command } | uniq | reverse | str join (char nl) | fzf --layout=reverse --height=40% -q (commandline) | decode utf-8 | str trim)"
            }
        }
    ]
    ls: {
        use_ls_colors: true # use the LS_COLORS environment variable to colorize output
        clickable_links: true # enable clickable links in ls output
    }
    rm: {
        always_trash: true # always use trash instead of permanently deleting files
    }
    table: {
        mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none
        index_mode: always # always, auto, never
        trim: {
            methodology: wrapping # truncating or wrapping
            wrapping_try_keep_words: true # attempts to keep words together
        }
    }
    menus: [
        # Configuration for default nushell menus
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]
    use_grid_icons: true
    footer_mode: "25" # always, never, number_of_rows, auto
    float_precision: 2 # number of decimal places to show
    buffer_editor: "" # command that will be used to edit the current line buffer
    use_ansi_coloring: true
    quick_completions: true
    partial_completions: true
    max_history_size: 100_000 # maximum number of history entries
    
    hooks: {
        pre_prompt: [{ 
            code: "
                let direnv = (which direnv | get path)
                if $direnv != '' {
                    direnv export json | from json | load-env 
                }
            "
        }]
    }
}

# Oh My Posh setup
let oh_my_posh_path = (which oh-my-posh | get path)

if ($oh_my_posh_path | is-empty) {
    # Oh My Posh is not installed
    print "Oh My Posh is not installed. Using default prompt."
} else {
    # Using GitHub Dark theme from Oh My Posh
    $env.PROMPT_COMMAND = { 
        oh-my-posh prompt --config ~/.config/powershell/github-dark.omp.json --shell nu 
    }
}

# Aliases
alias ll = ls -la
alias la = ls -a
alias l = ls -la
alias c = clear
alias cat = bat
alias top = btop
alias fd = fd -H
alias rg = rg --hidden
alias ytdl = yt-dlp
alias vim = nvim
alias vi = nvim
alias v = nvim
alias lg = lazygit
alias ld = lazydocker
alias y = yazi
alias find = (if (which fd | length) > 0 { fd } else { find })
alias grep = (if (which rg | length) > 0 { rg } else { grep })
alias cat = (if (which bat | length) > 0 { bat --paging=never } else { cat })
alias du = (if (which dust | length) > 0 { dust } else { du })
alias diff = (if (which delta | length) > 0 { delta } else { diff })
alias tree = (if (which as-tree | length) > 0 { as-tree } else { tree })
alias top = (if (which bottom | length) > 0 { bottom } else { top })
alias broot = (if (which broot | length) > 0 { broot } else { broot })
alias dua = (if (which dua | length) > 0 { dua } else { dua })
alias dua-cli = (if (which dua-cli | length) > 0 { dua-cli } else { dua-cli })
alias ncdu = (if (which ncdu | length) > 0 { ncdu } else { ncdu })
alias just = (if (which just | length) > 0 { just } else { just })
alias atuin = (if (which atuin | length) > 0 { atuin } else { atuin })
alias bandwhich = (if (which bandwhich | length) > 0 { bandwhich } else { bandwhich })
alias hyperfine = (if (which hyperfine | length) > 0 { hyperfine } else { hyperfine })
alias miniserve = (if (which miniserve | length) > 0 { miniserve } else { miniserve })
alias dog = (if (which dog | length) > 0 { dog } else { dog })
alias choose = (if (which choose | length) > 0 { choose } else { choose })
alias zoxide = (if (which zoxide | length) > 0 { zoxide } else { zoxide })
alias zi = (if (which zoxide | length) > 0 { zoxide } else { zoxide })

# Modern Unix Replacements
def gcp [src, dst] {
    rsync -avh --progress $src $dst
}

def mvv [src, dst] {
    rsync -avh --progress --remove-source-files $src $dst
}

# Zoxide (directory jumper) integration
if (which zoxide | length) > 0 {
    source ~/.zoxide.nu
    if not ($env | default {} | get -i ZOXIDE_SOURCED) == 1 {
        zoxide init nushell | save -f ~/.zoxide.nu
        source ~/.zoxide.nu
    }
}

# FZF integration
def fzf-history [] {
    (history | each { |it| $it.command } | uniq | reverse | str join (char nl) | fzf --layout=reverse --height=40%)
}

def fzcd [] {
    cd (ls -a | where type == dir | select name | get name | fzf)
}

def fzf-preview [query?: string] {
    if not (which fzf | is-empty) {
        let preview_cmd = "bat --style=numbers --color=always {} || cat {} || exa --tree --level=2 {}"
        let selected = if $query == null {
            (fzf --preview $preview_cmd)
        } else {
            (fzf --query $query --preview $preview_cmd)
        }
        if not ($selected | is-empty) {
            $selected
        }
    }
}

# Python virtual environment helper
def venv [name: string = ".venv"] {
    if ($name | path exists) {
        $env.VIRTUAL_ENV = ($name | path expand)
        let bin_dir = if $nu.os-info.name == "windows" {
            [Scripts]
        } else {
            [bin]
        }
        
        let path_dirs = (
            $env.PATH | 
            split row (char esep) | 
            prepend ($env.VIRTUAL_ENV | path join $bin_dir | path expand)
        )
        
        $env.PATH = ($path_dirs | uniq | str join (char esep))
        print $"Activated virtual environment ($name)"
    } else {
        print $"Creating virtual environment ($name)..."
        python -m venv $name
        venv $name
    }
}

def venv-deactivate [] {
    if 'VIRTUAL_ENV' in $env {
        let venv_path = $env.VIRTUAL_ENV
        
        $env.PATH = (
            $env.PATH | 
            split row (char esep) | 
            where { |it| $it != ($venv_path | path join 'Scripts') } |
            where { |it| $it != ($venv_path | path join 'bin') } | 
            str join (char esep)
        )
        
        hide-env VIRTUAL_ENV
        print "Deactivated virtual environment"
    } else {
        print "No active virtual environment"
    }
}

# Conda integration
if ($env | default {} | get -i CONDA_EXE | is-empty) == false {
    conda activate base | ignore
}

# Git shortcuts
def gst [] { git status }
def ga [...args] { git add ...$args }
def gc [message: string] { git commit -m $message }
def gco [...args] { git checkout ...$args }
def gp [...args] { git push ...$args }
def gl [...args] { git pull ...$args }

# Automatically activate Node version from .nvmrc if nvm is installed
def use-nvm [] {
    if (which nvm | is-empty) {
        return
    }

    let nvmrc_path = (fd .nvmrc --max-depth 1 --type f)
    if ($nvmrc_path | is-empty) {
        return
    }

    let node_version = (open $nvmrc_path | str trim)
    nvm use $node_version
}

# Load Starship prompt if installed
if not (which starship | is-empty) {
    starship init nu | save -f ~/.starship.nu
    source ~/.starship.nu
}

# Directory shortcuts
def home [] { cd ~ }
def docs [] { cd ~/Documents }
def dl [] { cd ~/Downloads }
def dotfiles [] { cd ~/dotfiles }
def desktop [] { cd ~/Desktop }
def projects [] { cd ~/Projects }
def repos [] { cd ~/repos }
def work [] { cd ~/Work }

# Show system info
def sysinfo [] {
    if not (which neofetch | is-empty) {
        ^neofetch
    } else if not (which macchina | is-empty) {
        ^macchina
    } else {
        print $"(ansi blue)System: ($nu.os-info.name) ($nu.os-info.arch)(ansi reset)"
        print $"(ansi green)Host:   ($nu.os-info.hostname)(ansi reset)"
        print $"(ansi yellow)Shell:  Nushell ($nu.version)(ansi reset)"
    }
}

# Automatically run when Nushell starts
sysinfo

# Add hook to automatically use NVM if available
$env.config.hooks.pre_prompt = ($env.config.hooks.pre_prompt | append {
    code: "use-nvm"
})

# Show fastfetch/neofetch with custom OS logo and conda env
if (which fastfetch | is-empty) == false {
  if ($env.CONDA_DEFAULT_ENV? | is-empty) == false {
    fastfetch --logo ($nu.os-info.name) --custom ("Conda Env: " + $env.CONDA_DEFAULT_ENV)
  } else {
    fastfetch --logo ($nu.os-info.name)
  }
} else if (which neofetch | is-empty) == false {
  if ($env.CONDA_DEFAULT_ENV? | is-empty) == false {
    neofetch --ascii_distro ($nu.os-info.name) --print_info Conda
  } else {
    neofetch --ascii_distro ($nu.os-info.name)
  }
}

# Modern CLI tool aliases with graceful fallback
if (which eza | is-empty) == false {
  alias ls = eza --icons --git --color=auto --group-directories-first
} else if (which exa | is-empty) == false {
  alias ls = exa --icons --git --color=auto --group-directories-first
} else if (which lsd | is-empty) == false {
  alias ls = lsd --icon=auto
} else {
  alias ls = ls --color=auto
}
if (which sd | is-empty) == false {
  alias sed = sd
} else {
  alias sed = sed
}
if (which xh | is-empty) == false {
  alias http = xh
} else if (which http | is-empty) == false {
  alias http = http
} else {
  alias http = curl
}
if (which gitui | is-empty) == false {
  alias gui = gitui
}
if (which rga | is-empty) == false {
  alias rga = rga
}
if (which batman | is-empty) == false {
  alias batman = batman
}
if (which batgrep | is-empty) == false {
  alias batgrep = batgrep
}
if (which batdiff | is-empty) == false {
  alias batdiff = batdiff
}
if (which onefetch | is-empty) == false {
  alias onefetch = onefetch
}
# vivid LS_COLORS (https://github.com/sharkdp/vivid)
if (which vivid | is-empty) == false {
  $env.LS_COLORS = (vivid generate catppuccin-mocha)
}
# Tool docs:
# eza: https://github.com/eza-community/eza
# vivid: https://github.com/sharkdp/vivid
# sd: https://github.com/chmln/sd
# xh: https://github.com/ducaale/xh
# gitui: https://github.com/extrawurst/gitui
# rga: https://github.com/phiresky/ripgrep-all
# bat-extras: https://github.com/eth-p/bat-extras
# onefetch: https://github.com/o2sh/onefetch