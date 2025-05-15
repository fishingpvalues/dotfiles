SHELL = /bin/bash

.PHONY: all install install-arch install-packages install-configs clean help install-omz install-fonts install-aur install-yay install-vscode-extensions install-chezmoi update fonts install-hyprland install-dotfiles postinstall test

# Platform detection
UNAME_S := $(shell uname -s)
IS_WINDOWS := $(filter Windows_NT,$(OS))

# Error log file
ERROR_LOG := make_errors.log

all: help

# Check if running on Arch Linux
ARCH_CHECK := $(shell pacman -V > /dev/null 2>&1 && echo "true" || echo "false")

help:
	@echo "Dotfiles Installation"
	@echo "--------------------"
	@echo "make install                   - Install everything (detect OS and install accordingly)"
	@echo "make install-arch              - Install configs and packages on Arch Linux"
	@echo "make install-configs           - Only install config files (no packages)"
	@echo "make install-packages          - Only install required packages on Arch"
	@echo "make install-omz               - Install Oh My Zsh and plugins"
	@echo "make install-fonts             - Install Fira Code Nerd Font"
	@echo "make install-aur               - Install AUR packages"
	@echo "make install-yay               - Install yay AUR helper"
	@echo "make install-vscode-extensions - Install VS Code extensions"
	@echo "make install-chezmoi           - Install and configure chezmoi dotfiles manager"
	@echo "make update                    - Update dotfiles"
	@echo "make fonts                     - Configure fonts"
	@echo "make clean                     - Remove symlinks created by this Makefile"
	@echo "make install-hyprland          - Install Hyprland and all related tools"
	@echo "make install-dotfiles          - Apply all dotfiles"
	@echo "make postinstall               - Run post-install scripts"
	@echo "make test                      - Run tests for the current platform"

install: install-fonts
	@echo "Installing dotfiles..." | tee -a $(ERROR_LOG)
	@if [ "$(ARCH_CHECK)" = "true" ]; then \
		echo "Detected Arch Linux..." | tee -a $(ERROR_LOG); \
		$(MAKE) install-arch 2>>$(ERROR_LOG); \
	else \
		echo "Not on Arch Linux, attempting generic install via bootstrap/scripts/unix/install.sh..." | tee -a $(ERROR_LOG); \
		if [ -f "./bootstrap/scripts/unix/install.sh" ]; then \
			chmod +x ./bootstrap/scripts/unix/install.sh 2>>$(ERROR_LOG); \
			./bootstrap/scripts/unix/install.sh 2>>$(ERROR_LOG) || echo "[ERROR] install.sh failed, see $(ERROR_LOG)" | tee -a $(ERROR_LOG); \
		else \
			echo "[WARN] install.sh not found for non-Arch system. Skipping generic install." | tee -a $(ERROR_LOG); \
		fi; \
	fi

install-arch: install-packages install-aur install-omz install-fonts install-chezmoi install-vscode-extensions install-dotfiles postinstall
	@echo "Installation completed for Arch Linux!"
	@echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
	@echo "Consider changing your default shell to zsh: chsh -s /bin/zsh"

update:
	@echo "Updating dotfiles..." | tee -a $(ERROR_LOG)
	@chezmoi update 2>>$(ERROR_LOG) || echo "[ERROR] chezmoi update failed, see $(ERROR_LOG)" | tee -a $(ERROR_LOG)

fonts:
	@echo "Setting up fonts..."
	@if [ -f "./arch/scripts/set_fonts.sh" ]; then \
		chmod +x ./arch/scripts/set_fonts.sh; \
		./arch/scripts/set_fonts.sh; \
	else \
		echo "Warning: Font configuration script not found at ./arch/scripts/set_fonts.sh"; \
	fi

install-yay:
	@if ! command -v yay &> /dev/null; then \
		echo "Installing yay AUR helper..."; \
		sudo pacman -S --needed --noconfirm git base-devel && \
		git clone https://aur.archlinux.org/yay.git /tmp/yay && \
		cd /tmp/yay && \
		makepkg -si --noconfirm && \
		cd - && \
		rm -rf /tmp/yay; \
	else \
		echo "yay is already installed"; \
	fi

install-packages:
	@echo "Installing required packages..."
	@if [ "$(ARCH_CHECK)" = "true" ]; then \
		sudo pacman -S --needed --noconfirm \
			base-devel \
			git \
			neovim \
			zsh \
			bash \
			wget \
			curl \
			fzf \
			ripgrep \
			fd \
			bat \
			exa \
			htop \
			tmux \
			python-pip \
			nodejs \
			npm \
			wezterm \
			kubectl \
			helm \
			terraform \
			docker \
			lazygit \
			aria2 \
			ranger \
			tldr \
			zoxide \
			ncdu \
			ffmpeg \
			firefox \
			btop \
			openssh \
			openvpn \
			gnupg \
			unzip \
			yazi \
			lnav \
			powershell \
			vim \
			texlive-most \
			obsidian \
			p7zip \
			# hashcat \
			# nmap \
			hashcat \
			cmake \
			make \
			rustup \
			python-venv \
			python-setuptools \
			python-wheel \
			python-pytest \
			yt-dlp \
			chezmoi; \
		# Install Rust \
		rustup default stable; \
		# Install Miniforge3 (Conda) \
		if ! command -v conda &> /dev/null; then \
			echo "Installing Miniforge3..."; \
			wget -q https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O /tmp/miniforge.sh; \
			bash /tmp/miniforge.sh -b -p $${HOME}/miniforge3; \
			rm /tmp/miniforge.sh; \
			# Add to PATH for current session \
			export PATH="$${HOME}/miniforge3/bin:$$PATH"; \
			# Initialize conda for current and future sessions \
			eval "$$($${HOME}/miniforge3/bin/conda shell.bash hook)"; \
			$${HOME}/miniforge3/bin/conda init zsh bash; \
		fi; \
		# Configure conda to store environments in .conda/envs \
		CONDA_ENV_DIR="$${HOME}/.conda/envs"; \
		mkdir -p "$${CONDA_ENV_DIR}"; \
		# [Conda configuration removed. See scripts/setup-conda.sh for details.]
	fi; \

install-aur: install-yay
	@echo "Installing AUR packages..."
	@if [ "$(ARCH_CHECK)" = "true" ]; then \
		# Ensure yay is available before proceeding \
		if ! command -v yay &> /dev/null; then \
			echo "Error: yay command not found. Please install it first (make install-yay)."; \
			exit 1; \
		fi; \
		# List of AUR packages to install \
		yay -S --needed --noconfirm \
			visual-studio-code-bin \
			github-cli \
			drawio-desktop \
			slimtoolkit-bin \
			trivy \
			macchina \
			ollama \
			jan-bin \
			llama-cpp-python-git \
			google-chrome \
			warp-terminal-bin \
			keepassxc \
			lazydocker \
			stremio \
			jdownloader2 \
			hyprland-git \
			discord \
			betterdiscord-installer-bin \
			teams-for-linux \
			spotify-launcher || echo "WARNING: Some AUR packages might have failed to install."; \
		# Install Ghidra if not already installed \
		if ! pacman -Q ghidra &>/dev/null; then \
			echo "Installing Ghidra..."; \
			# yay -S --needed --noconfirm ghidra || echo "WARNING: Ghidra installation failed."; \
		fi; \
	else \
		echo "Not running on Arch Linux, skipping AUR package installation"; \
	fi

install-omz:
	@echo "Installing Oh My Zsh and plugins..."
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	else \
		echo "Oh My Zsh already installed"; \
	fi
	@# Install plugins
	@ZSH_CUSTOM="$$HOME/.oh-my-zsh/custom"; \
	if [ ! -d "$$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then \
		echo "Installing zsh-autosuggestions..."; \
		git clone https://github.com/zsh-users/zsh-autosuggestions "$$ZSH_CUSTOM/plugins/zsh-autosuggestions"; \
	fi; \
	if [ ! -d "$$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then \
		echo "Installing zsh-syntax-highlighting..."; \
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"; \
	fi; \
	# Install powerlevel10k theme \
	if [ ! -d "$$ZSH_CUSTOM/themes/powerlevel10k" ]; then \
		echo "Installing powerlevel10k theme..."; \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$$ZSH_CUSTOM/themes/powerlevel10k"; \
	fi

install-fonts:
	@echo "Installing Nerd Fonts..."
	@# Install FiraCode Nerd Font
	@if [ ! -d "$$HOME/.local/share/fonts/FiraCode" ]; then \
		echo "Installing FiraCode Nerd Font..."; \
		mkdir -p "$$HOME/.local/share/fonts/FiraCode"; \
		wget -q "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip" -O /tmp/firacode.zip; \
		unzip -q /tmp/firacode.zip -d "$$HOME/.local/share/fonts/FiraCode"; \
		rm /tmp/firacode.zip; \
	else \
		echo "Fira Code Nerd Font already installed"; \
	fi
	@# Install MesloLGS Nerd Font (for Powerlevel10k)
	@if [ ! -f "$$HOME/.local/share/fonts/MesloLGS NF Regular.ttf" ]; then \
		echo "Installing MesloLGS Nerd Font..."; \
		mkdir -p "$$HOME/.local/share/fonts"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -O "$$HOME/.local/share/fonts/MesloLGS NF Regular.ttf"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -O "$$HOME/.local/share/fonts/MesloLGS NF Bold.ttf"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -O "$$HOME/.local/share/fonts/MesloLGS NF Italic.ttf"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -O "$$HOME/.local/share/fonts/MesloLGS NF Bold Italic.ttf"; \
	else \
		echo "MesloLGS Nerd Font already installed"; \
	fi
	@# Update font cache
	@echo "Updating font cache..."; \
	fc-cache -f -v

install-vscode-extensions:
	@echo "Installing VS Code extensions..."
	@if command -v code &> /dev/null; then \
		code --install-extension adoxxorg.adoxx-adoscript || true; \
		code --install-extension alefragnani.project-manager || true; \
		code --install-extension batisteo.vscode-django || true; \
		code --install-extension codezombiech.gitignore || true; \
		code --install-extension donjayamanne.git-extension-pack || true; \
		code --install-extension donjayamanne.githistory || true; \
		code --install-extension donjayamanne.python-environment-manager || true; \
		code --install-extension donjayamanne.python-extension-pack || true; \
		code --install-extension eamodio.gitlens || true; \
		code --install-extension github.copilot || true; \
		code --install-extension github.copilot-chat || true; \
		code --install-extension gruntfuggly.todo-tree || true; \
		code --install-extension hediet.vscode-drawio || true; \
		code --install-extension kevinrose.vsc-python-indent || true; \
		code --install-extension mathworks.language-matlab || true; \
		code --install-extension ms-python.debugpy || true; \
		code --install-extension ms-python.python || true; \
		code --install-extension ms-python.vscode-pylance || true; \
		code --install-extension ms-toolsai.jupyter || true; \
		code --install-extension ms-toolsai.jupyter-keymap || true; \
		code --install-extension ms-toolsai.jupyter-renderers || true; \
		code --install-extension ms-toolsai.tensorboard || true; \
		code --install-extension ms-toolsai.vscode-jupyter-cell-tags || true; \
		code --install-extension ms-toolsai.vscode-jupyter-slideshow || true; \
		code --install-extension ms-vscode-remote.remote-wsl || true; \
		code --install-extension njpwerner.autodocstring || true; \
		code --install-extension visualstudioexptteam.intellicode-api-usage-examples || true; \
		code --install-extension visualstudioexptteam.vscodeintellicode || true; \
		code --install-extension wholroyd.jinja || true; \
		code --install-extension ziyasal.vscode-open-in-github || true; \
	else \
		echo "VS Code ('code' command) not found, skipping extension installation"; \
	fi

# Install and configure chezmoi
install-chezmoi:
	@echo "Setting up chezmoi for dotfiles management..."
	@if ! command -v chezmoi &> /dev/null; then \
		echo "Installing chezmoi..."; \
		if [ "$(ARCH_CHECK)" = "true" ]; then \
			sudo pacman -S --needed --noconfirm chezmoi; \
		else \
			echo "Attempting to install chezmoi using install script..."; \
			sh -c "$$(curl -fsLS get.chezmoi.io)" -- -b $$HOME/.local/bin; \
			if ! command -v chezmoi &> /dev/null; then \
				echo "chezmoi installation failed or $$HOME/.local/bin is not in PATH."; \
				echo "Please add $$HOME/.local/bin to your PATH."; \
				exit 1; \
			fi; \
		fi; \
	else \
		echo "chezmoi already installed"; \
	fi

# Install configuration files using chezmoi (assumes chezmoi is installed and initialized elsewhere or via dependency)
install-configs: install-chezmoi
	@echo "Applying configuration files using chezmoi..."
	@# Assuming chezmoi has been initialized pointing to the correct source directory
	@chezmoi apply --force
	@echo "Config files applied successfully!"

clean:
	@echo "Cleaning up..." | tee -a $(ERROR_LOG)
	@if [ -d "$$HOME/.cache/chezmoi" ]; then \
		echo "Removing chezmoi cache..." | tee -a $(ERROR_LOG); \
		rm -rf "$$HOME/.cache/chezmoi" 2>>$(ERROR_LOG); \
	fi
	@if command -v chezmoi &> /dev/null; then \
		echo "Removing files managed by chezmoi (purge)..." | tee -a $(ERROR_LOG); \
		chezmoi purge --force 2>>$(ERROR_LOG); \
	else \
		echo "chezmoi command not found, attempting manual removal of common symlinks..." | tee -a $(ERROR_LOG); \
		rm -f $$HOME/.bashrc $$HOME/.zshrc $$HOME/.gitconfig $$HOME/.tmux.conf 2>>$(ERROR_LOG); \
		rm -rf $$HOME/.config/nvim $$HOME/.config/wezterm $$HOME/.config/nushell $$HOME/.config/alacritty $$HOME/.config/htop 2>>$(ERROR_LOG); \
		rm -f $$HOME/.config/Code/User/settings.json $$HOME/.config/Code/User/keybindings.json 2>>$(ERROR_LOG); \
		rm -rf $$HOME/.oh-my-zsh 2>>$(ERROR_LOG); \
	fi
	@echo "Cleanup completed!" | tee -a $(ERROR_LOG)

install-hyprland: install-packages install-aur install-dotfiles
	@echo "Hyprland and potentially related tools installed/configured via dependencies!"
	@echo "Ensure necessary Hyprland components (waybar, wofi, etc.) are included in install-packages/install-aur."

install-dotfiles: install-chezmoi
	@echo "Applying dotfiles using chezmoi..."
	@chezmoi apply --force
	@echo "Dotfiles applied!"

postinstall:
	@# Example post-install task: Symlink wallpapers if script exists
	@if [ -f "./bootstrap/scripts/unix/symlink_wallpapers.sh" ]; then \
		echo "Running wallpaper symlink script..."; \
		chmod +x ./bootstrap/scripts/unix/symlink_wallpapers.sh; \
		./bootstrap/scripts/unix/symlink_wallpapers.sh; \
	else \
		echo "Wallpaper symlink script not found, skipping."; \
	fi

# Unified test target for all platforms with fallback and error logging
# Usage: make test

test:
ifeq ($(IS_WINDOWS),Windows_NT)
	@echo "Running all Windows dotfiles tests via test/run-all.ps1..." | tee -a $(ERROR_LOG)
	@if [ -f ./test/run-all.ps1 ]; then \
		pwsh ./test/run-all.ps1 2>>$(ERROR_LOG) || echo "[ERROR] Windows tests failed, see $(ERROR_LOG)" | tee -a $(ERROR_LOG); \
	else \
		echo "[WARN] test/run-all.ps1 not found. Skipping Windows tests." | tee -a $(ERROR_LOG); \
	fi
else
	@echo "Running all Unix/macOS/Linux dotfiles tests via test/run-all.sh..." | tee -a $(ERROR_LOG)
	@if [ -f ./test/run-all.sh ]; then \
		chmod +x ./test/run-all.sh; \
		./test/run-all.sh 2>>$(ERROR_LOG) || echo "[ERROR] Unix tests failed, see $(ERROR_LOG)" | tee -a $(ERROR_LOG); \
	else \
		echo "[WARN] test/run-all.sh not found. Skipping Unix tests." | tee -a $(ERROR_LOG); \
	fi
endif

# Include platform-specific Makefile fragments if they exist
ifeq ($(IS_WINDOWS),Windows_NT)
-include Makefile.windows
else
-include Makefile.unix
endif