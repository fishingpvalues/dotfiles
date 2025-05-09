# Show fastfetch/neofetch with custom OS logo and conda env
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    if ($env:CONDA_DEFAULT_ENV) {
        fastfetch --logo $env:OS --custom "Conda Env: $env:CONDA_DEFAULT_ENV"
    } else {
        fastfetch --logo $env:OS
    }
} elseif (Get-Command neofetch -ErrorAction SilentlyContinue) {
    if ($env:CONDA_DEFAULT_ENV) {
        neofetch --ascii_distro $env:OS --print_info Conda
    } else {
        neofetch --ascii_distro $env:OS
    }
}

# Rust-powered tool aliases
Set-Alias find fd
Set-Alias grep rg
Set-Alias cat bat
Set-Alias du dust
Set-Alias diff delta
Set-Alias tree as-tree
Set-Alias top bottom
Set-Alias broot broot
Set-Alias dua dua
Set-Alias dua-cli dua-cli
Set-Alias ncdu ncdu
Set-Alias just just
Set-Alias atuin atuin
Set-Alias bandwhich bandwhich
Set-Alias hyperfine hyperfine
Set-Alias miniserve miniserve
Set-Alias dog dog
Set-Alias choose choose 