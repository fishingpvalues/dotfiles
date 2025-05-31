#!/bin/bash
# 🚀 Dotfiles Setup Entry Point (macOS)
set -euo pipefail

info()    { echo -e "\033[1;34mℹ️  $*\033[0m"; }
success() { echo -e "\033[1;32m✅ $*\033[0m"; }
warn()    { echo -e "\033[1;33m⚠️  $*\033[0m"; }
error()   { echo -e "\033[1;31m🛑 $*\033[0m" >&2; exit 1; }

# --- Check if running in Terminal (interactive shell) ---
if [[ -z "${PS1:-}" && -z "${TERM_PROGRAM:-}" ]]; then
  error "Please run this script from Terminal, not by double-clicking in Finder."
fi

# --- Xcode Command Line Tools ---
if ! xcode-select -p &>/dev/null; then
  info "Installing Xcode Command Line Tools..."
  xcode-select --install || true
fi

# --- Homebrew ---
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

# --- Brew Bundle (installs all packages and fonts, including yazi) ---
info "Installing Homebrew packages and fonts..."
brew bundle --file="${HOME}/dotfiles/dot_Brewfile"

# --- Ensure Yazi and ya are installed (AFTER brew bundle) ---
if ! command -v yazi >/dev/null 2>&1; then
  warn "Yazi is not installed. Skipping Yazi config and plugin setup. Please install yazi with 'brew install yazi' if you want full functionality."
elif ! command -v ya >/dev/null 2>&1; then
  warn "ya (Yazi assistant) is not installed. Skipping Yazi plugin setup. It should be bundled with yazi. Please check your installation."
else
  # --- Set up Yazi config if present ---
  if [ -f "$HOME/dotfiles/config/yazi/yazi.toml" ]; then
    yazi_config_dir="$HOME/.config/yazi"
    mkdir -p "$yazi_config_dir"
    cp -f "$HOME/dotfiles/config/yazi/yazi.toml" "$yazi_config_dir/yazi.toml"
    success "Yazi config installed."
  fi
  # --- Install Yazi plugins using ya pack ---
  yazi_config_dir="$HOME/.config/yazi"
  cd "$yazi_config_dir"
  info "Installing Yazi plugins..."
  ya pack -a eza-preview.yazi glow.yazi rich-preview.yazi hexyl.yazi lsar.yazi mediainfo.yazi \
    bunny.yazi easyjump.yazi projects.yazi compress.yazi diff.yazi system-clipboard.yazi \
    dual-pane.yazi starship.yazi lazygit.yazi DreamMaoMao/git.yazi fm-nvim mikavilpas/yazi.nvim || \
    warn "Some Yazi plugins may not have installed correctly."
  cd - >/dev/null
fi

# --- Chezmoi ---
info "Installing chezmoi and applying dotfiles..."
brew install chezmoi || true
chezmoi init --source="$(cd "$(dirname "$0")" && pwd)"
chezmoi apply || error "chezmoi apply failed."

# --- Neovim Python/Node providers ---
info "Installing Neovim Python and Node providers..."
brew install python node || true
pip3 install --user pynvim || true
npm install -g neovim || true

# --- Ensure all scripts are executable ---
find "${HOME}/dotfiles/bin" -type f -exec chmod +x {} \; 2>/dev/null || true
find "${HOME}/dotfiles/bootstrap/scripts" -type f -exec chmod +x {} \; 2>/dev/null || true

success "macOS dotfiles setup complete! Run 'nvim --headless "+checkhealth" +qa' to verify Neovim health. 🎉" 