# Dotfiles Makefile - Easy setup commands

.PHONY: help install install-macos install-linux setup-shell setup-git setup-all check clean

# Default target
help:
	@echo "Dotfiles Setup Commands"
	@echo "======================="
	@echo ""
	@echo "make install       - Install all tools (auto-detect OS)"
	@echo "make install-macos - Install tools on macOS"
	@echo "make install-linux - Install tools on Linux"
	@echo "make setup-shell   - Setup shell integration"
	@echo "make setup-git     - Setup git configuration"
	@echo "make setup-all     - Complete setup (install + configure)"
	@echo "make check         - Check which tools are installed"
	@echo "make link          - Create symlinks"
	@echo "make clean         - Remove symlinks"
	@echo ""

# Auto-detect OS and install
install:
	@if [ "$$(uname)" = "Darwin" ]; then \
		$(MAKE) install-macos; \
	elif [ "$$(uname)" = "Linux" ]; then \
		$(MAKE) install-linux; \
	else \
		echo "Unsupported OS"; \
		exit 1; \
	fi

# Install on macOS
install-macos:
	@chmod +x install-macos.sh
	@./install-macos.sh

# Install on Linux
install-linux:
	@chmod +x install-linux.sh
	@./install-linux.sh

# Setup shell integration
setup-shell:
	@chmod +x setup-shell.sh
	@./setup-shell.sh

# Setup git configuration
setup-git:
	@chmod +x setup-git.sh
	@./setup-git.sh

# Complete setup
setup-all:
	@chmod +x setup-all.sh
	@./setup-all.sh

# Create symlinks
link:
	@echo "Creating symlinks..."
	@if [ -d "$$HOME/.config" ] && [ ! -L "$$HOME/.config" ]; then \
		echo "Backing up existing .config..."; \
		mv "$$HOME/.config" "$$HOME/.config.backup.$$(date +%Y%m%d_%H%M%S)"; \
	fi
	@ln -sf "$$(pwd)/.config" "$$HOME/.config"
	@echo "Symlink created: ~/.config -> $$(pwd)/.config"

# Check installed tools
check:
	@echo "Checking installed tools..."
	@echo ""
	@echo "Core tools:"
	@command -v nvim >/dev/null 2>&1 && echo "  ✓ neovim" || echo "  ✗ neovim"
	@command -v tmux >/dev/null 2>&1 && echo "  ✓ tmux" || echo "  ✗ tmux"
	@command -v git >/dev/null 2>&1 && echo "  ✓ git" || echo "  ✗ git"
	@echo ""
	@echo "CLI tools:"
	@command -v bat >/dev/null 2>&1 && echo "  ✓ bat" || echo "  ✗ bat"
	@command -v fd >/dev/null 2>&1 && echo "  ✓ fd" || echo "  ✗ fd"
	@command -v rg >/dev/null 2>&1 && echo "  ✓ ripgrep" || echo "  ✗ ripgrep"
	@command -v delta >/dev/null 2>&1 && echo "  ✓ delta" || echo "  ✗ delta"
	@echo ""
	@echo "TUI apps:"
	@command -v lazygit >/dev/null 2>&1 && echo "  ✓ lazygit" || echo "  ✗ lazygit"
	@command -v lazydocker >/dev/null 2>&1 && echo "  ✓ lazydocker" || echo "  ✗ lazydocker"
	@command -v btop >/dev/null 2>&1 && echo "  ✓ btop" || echo "  ✗ btop"
	@command -v yazi >/dev/null 2>&1 && echo "  ✓ yazi" || echo "  ✗ yazi"
	@echo ""
	@echo "Shell enhancements:"
	@command -v starship >/dev/null 2>&1 && echo "  ✓ starship" || echo "  ✗ starship"
	@command -v atuin >/dev/null 2>&1 && echo "  ✓ atuin" || echo "  ✗ atuin"
	@command -v zoxide >/dev/null 2>&1 && echo "  ✓ zoxide" || echo "  ✗ zoxide"
	@echo ""
	@echo "Editors:"
	@command -v helix >/dev/null 2>&1 && echo "  ✓ helix" || echo "  ✗ helix"
	@command -v zellij >/dev/null 2>&1 && echo "  ✓ zellij" || echo "  ✗ zellij"
	@echo ""

# Clean symlinks
clean:
	@echo "Removing symlinks..."
	@if [ -L "$$HOME/.config" ]; then \
		unlink "$$HOME/.config"; \
		echo "Removed: ~/.config"; \
	fi
	@echo "Clean complete"
