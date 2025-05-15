#!/bin/bash
# Usage (from Terminal, no need to clone first):
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/fishingpvalues/dotfiles/main/setup-dotfiles-macos.sh)"
# Or, after cloning:
#   chmod +x setup-dotfiles-macos.sh && ./setup-dotfiles-macos.sh
set -e

# Check if running in Terminal (interactive shell)
if [[ -z "$PS1" && -z "$TERM_PROGRAM" ]]; then
  echo "[ERROR] Please run this script from Terminal, not by double-clicking in Finder."
  exit 1
fi

# 1. Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install || true
fi

# 2. Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
fi

# 3. Brew Bundle (installs all packages and fonts)
echo "Installing Homebrew packages and fonts..."
brew bundle --file="${HOME}/dotfiles/dot_Brewfile"

# 4. Chezmoi
echo "Installing chezmoi and applying dotfiles..."
brew install chezmoi || true
chezmoi init --source="${HOME}/dotfiles"
chezmoi apply

# 5. Neovim Python/Node providers
echo "Installing Neovim Python and Node providers..."
brew install python node || true
pip3 install --user pynvim || true
npm install -g neovim || true

# 6. Ensure all scripts are executable
find "${HOME}/dotfiles/bin" -type f -exec chmod +x {} \; 2>/dev/null || true
find "${HOME}/dotfiles/bootstrap/scripts" -type f -exec chmod +x {} \; 2>/dev/null || true

# 7. Final message
echo "\n✅ macOS dotfiles setup complete! Run 'nvim --headless \"+checkhealth\" +qa' to verify Neovim health." 