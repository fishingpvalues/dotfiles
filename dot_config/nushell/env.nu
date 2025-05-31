# Nushell Environment Config File
# GitHub: https://github.com/nushell/nushell

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Set editor to Neovim if available
let editor = if (which nvim | is-empty) { "code" } else { "nvim" }
$env.EDITOR = $editor
$env.VISUAL = $editor

# Common environment variables
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# Set PATH variable based on OS
def set-path [] {
    let default_path = if $nu.os-info.name == "windows" {
        $env.Path
    } else {
        $env.PATH
    }
    
    let user_bin = if $nu.os-info.name == "windows" {
        $"($env.USERPROFILE)\bin"
    } else {
        $"($env.HOME)/bin"
    }
    
    let local_bin = if $nu.os-info.name == "windows" {
        $"($env.USERPROFILE)\.local\bin"
    } else {
        $"($env.HOME)/.local/bin"
    }

    let cargo_bin = if $nu.os-info.name == "windows" {
        $"($env.USERPROFILE)\.cargo\bin"
    } else {
        $"($env.HOME)/.cargo/bin"
    }
    
    let go_bin = if $nu.os-info.name == "windows" {
        $"($env.USERPROFILE)\go\bin"
    } else {
        $"($env.HOME)/go/bin"
    }
    
    # For WSL integration with Windows-specific tools
    let wsl_paths = if $nu.os-info.name == "windows" {
        []
    } else if (sys).host.name == "linux" and (open /proc/version | str contains "microsoft") {
        # Add Windows executable paths for WSL environments
        ["/mnt/c/Windows", "/mnt/c/Windows/System32"]
    } else {
        []
    }
    
    # Gather all paths to add
    let add_paths = [
        $user_bin,
        $local_bin,
        $cargo_bin,
        $go_bin,
    ]
    
    # Add all paths together, filter out any that don't exist
    let path_list = (
        ($default_path | default [] | append $add_paths | append $wsl_paths) | 
        uniq | 
        where { |it| ($it | path exists) or ($it | path exists) }
    )
    
    # Set the PATH variable
    if $nu.os-info.name == "windows" {
        $env.Path = ($path_list | str join (char esep))
    } else {
        $env.PATH = ($path_list | str join (char esep))
    }
}

# Call the function to set up PATH
set-path

# GitHub CLI configuration
$env.GH_PAGER = "less"

# fzf settings
$env.FZF_DEFAULT_OPTS = "--height 40% --layout=reverse --border --preview 'bat --color=always {}'"
$env.FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow"

# Use bat as the man pager with colors
$env.MANPAGER = "sh -c 'col -bx | bat --language man --plain'"

# Less settings
$env.LESS = "-R"
$env.LESSHISTFILE = "-"

# For colored output in various commands
$env.CLICOLOR = 1 

# Use JetBrains Mono as PowerShell terminal font (Windows only)
if $nu.os-info.name == "windows" {
    $env.POWERSHELL_WINDOW_FONT = "JetBrains Mono"
}

# Python settings
$env.PYTHONDONTWRITEBYTECODE = 1
$env.PYTHONIOENCODING = "utf-8"

# ripgrep configuration
$env.RIPGREP_CONFIG_PATH = if $nu.os-info.name == "windows" {
    $"($env.USERPROFILE)\.ripgreprc"
} else {
    $"($env.HOME)/.ripgreprc"
}

# Miniforge
let miniforge_path = if $nu.os-info.name == "windows" {
    $"($env.USERPROFILE)\miniforge3"
} else {
    $"($env.HOME)/miniforge3"
}

if ($miniforge_path | path exists) {
    # Add miniforge bins to PATH if they exist
    let miniforge_bin = if $nu.os-info.name == "windows" {
        $"($miniforge_path)\Scripts"
    } else {
        $"($miniforge_path)/bin"
    }

    if ($miniforge_bin | path exists) {
        if $nu.os-info.name == "windows" {
            $env.Path = ($env.Path | prepend $miniforge_bin)
        } else {
            $env.PATH = ($env.PATH | prepend $miniforge_bin)
        }
    }
}

# Starship configuration
$env.STARSHIP_CONFIG = if $nu.os-info.name == "windows" {
    $"($env.USERPROFILE)\.config\starship.toml"
} else {
    $"($env.HOME)/.config/starship.toml"
}

# Set locale to English UTF-8 for consistency
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

# WSL specific settings (if applicable)
if (sys).host.name == "linux" and (open /proc/version | str contains "microsoft") {
    # Use Windows browser for opening URLs in WSL
    $env.BROWSER = "wslview"
}