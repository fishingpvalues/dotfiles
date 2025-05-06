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