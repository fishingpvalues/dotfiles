SHELL = /bin/bash

.PHONY: all install install-arch install-packages install-configs clean help install-omz install-fonts install-aur install-yay install-vscode-extensions install-chezmoi update fonts install-hyprland install-dotfiles postinstall

all: help

# Check if running on Arch Linux
ARCH_CHECK := $(shell pacman -V > /dev/null 2>&1 && echo "true" || echo "false")

help:
	@echo "Dotfiles Installation"
	@echo "--------------------"
	@echo "make install       - Install everything (detect OS and install accordingly)"
	@echo "make install-arch  - Install configs and packages on Arch Linux"
	@echo "make install-configs - Only install config files (no packages)"
	@echo "make install-packages - Only install required packages on Arch"
	@echo "make install-omz   - Install Oh My Zsh and plugins"
	@echo "make install-fonts - Install Fira Code Nerd Font"
	@echo "make install-aur   - Install AUR packages"
	@echo "make install-yay   - Install yay AUR helper"
	@echo "make install-vscode-extensions - Install VS Code extensions"
	@echo "make install-chezmoi - Install and configure chezmoi dotfiles manager"
	@echo "make update        - Update dotfiles"
	@echo "make fonts         - Configure fonts"
	@echo "make clean         - Remove symlinks created by this Makefile"
	@echo "make install-hyprland - Install Hyprland and all related tools"
	@echo "make install-dotfiles - Apply all dotfiles"
	@echo "make postinstall   - Run post-install scripts"

install: fonts
	@echo "Installing dotfiles for Arch Linux..."
	@if [ "$(ARCH_CHECK)" = "true" ]; then \
		$(MAKE) install-arch; \
	else \
		echo "Not on Arch Linux, please use install.ps1 for Windows or install.sh for macOS/other Linux"; \
		echo "Running: ./install.sh"; \
		chmod +x ./install.sh; \
		./install.sh; \
	fi

install-arch: install-packages install-aur install-omz install-fonts install-chezmoi install-vscode-extensions
	@echo "Installation completed for Arch Linux!"
	@echo "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
	@echo "Consider changing your default shell to zsh: chsh -s /bin/zsh"

update:
	@echo "Updating dotfiles..."
	@chezmoi update

fonts:
	@echo "Setting up fonts..."
	@if [ -f "./arch/scripts/set_fonts.sh" ]; then \
		chmod +x ./arch/scripts/set_fonts.sh; \
		./arch/scripts/set_fonts.sh; \
	else \
		echo "Warning: Font configuration script not found"; \
	fi

install-yay:
	@if ! command -v yay &> /dev/null; then \
		echo "Installing yay AUR helper..."; \
		sudo pacman -S --needed --noconfirm git base-devel && \
		git clone https://aur.archlinux.org/yay.git /tmp/yay && \
		cd /tmp/yay && \
		makepkg -si --noconfirm && \
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
			thefuck \
			binwalk \
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
			hashcat \
			nmap \
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
		cat > "$${HOME}/.condarc" << EOF
envs_dirs:
		- $${CONDA_ENV_DIR}
		- $${HOME}/miniforge3/envs
EOF
		# Ensure conda initialization is in shell profiles \
		for SHELL_RC in "$${HOME}/.bashrc" "$${HOME}/.zshrc"; do \
			if [ -f "$$SHELL_RC" ]; then \
				if ! grep -q "conda initialize" "$$SHELL_RC"; then \
					echo "Adding conda initialization to $$SHELL_RC"; \
					SHELL_NAME=$$(basename "$$SHELL_RC" | sed 's/\.[^.]*$$//'); \
					$${HOME}/miniforge3/bin/conda init $$SHELL_NAME; \
				fi; \
			fi; \
		done; \
		echo "Configured conda to store environments in $${CONDA_ENV_DIR}"; \
		# Setup Python dev tools \
		pip install --user --upgrade uv ruff pyright pdoc commitizen pre-commit just; \
	else \
		echo "Not running on Arch Linux, skipping package installation"; \
	fi

install-aur: install-yay
	@echo "Installing AUR packages..."
	@if [ "$(ARCH_CHECK)" = "true" ]; then \
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
			panda \
			discord \
			betterdiscord-installer-bin \
			teams-for-linux \
			spotify-launcher; \
			\
		# Install Ghidra if not already installed \
		if ! pacman -Q ghidra &>/dev/null; then \
			echo "Installing Ghidra..."; \
			yay -S --needed --noconfirm ghidra; \
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
	\
	# Install powerlevel10k theme \
	if [ ! -d "$$ZSH_CUSTOM/themes/powerlevel10k" ]; then \
		echo "Installing powerlevel10k theme..."; \
		git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$$ZSH_CUSTOM/themes/powerlevel10k"; \
	fi

install-fonts:
	@echo "Installing Nerd Fonts..."
	@if [ ! -d "$$HOME/.local/share/fonts/FiraCode" ]; then \
		mkdir -p "$$HOME/.local/share/fonts/FiraCode"; \
		wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip" -O /tmp/firacode.zip; \
		unzip -q /tmp/firacode.zip -d "$$HOME/.local/share/fonts/FiraCode"; \
		rm /tmp/firacode.zip; \
	else \
		echo "Fira Code Nerd Font already installed"; \
	fi
	
	@if [ ! -d "$$HOME/.local/share/fonts/MesloLGS" ]; then \
		mkdir -p "$$HOME/.local/share/fonts/MesloLGS"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" -O "$$HOME/.local/share/fonts/MesloLGS/MesloLGS NF Regular.ttf"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" -O "$$HOME/.local/share/fonts/MesloLGS/MesloLGS NF Bold.ttf"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" -O "$$HOME/.local/share/fonts/MesloLGS/MesloLGS NF Italic.ttf"; \
		wget -q "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" -O "$$HOME/.local/share/fonts/MesloLGS/MesloLGS NF Bold Italic.ttf"; \
	else \
		echo "MesloLGS Nerd Font already installed"; \
	fi
	
	@fc-cache -f -v

install-vscode-extensions:
	@echo "Installing VS Code extensions..."
	@if command -v code &> /dev/null; then \
		code --install-extension adoxxorg.adoxx-adoscript; \
		code --install-extension alefragnani.project-manager; \
		code --install-extension batisteo.vscode-django; \
		code --install-extension codezombiech.gitignore; \
		code --install-extension donjayamanne.git-extension-pack; \
		code --install-extension donjayamanne.githistory; \
		code --install-extension donjayamanne.python-environment-manager; \
		code --install-extension donjayamanne.python-extension-pack; \
		code --install-extension eamodio.gitlens; \
		code --install-extension github.copilot; \
		code --install-extension github.copilot-chat; \
		code --install-extension gruntfuggly.todo-tree; \
		code --install-extension hediet.vscode-drawio; \
		code --install-extension kevinrose.vsc-python-indent; \
		code --install-extension mathworks.language-matlab; \
		code --install-extension ms-python.debugpy; \
		code --install-extension ms-python.python; \
		code --install-extension ms-python.vscode-pylance; \
		code --install-extension ms-toolsai.jupyter; \
		code --install-extension ms-toolsai.jupyter-keymap; \
		code --install-extension ms-toolsai.jupyter-renderers; \
		code --install-extension ms-toolsai.tensorboard; \
		code --install-extension ms-toolsai.vscode-jupyter-cell-tags; \
		code --install-extension ms-toolsai.vscode-jupyter-slideshow; \
		code --install-extension ms-vscode-remote.remote-wsl; \
		code --install-extension njpwerner.autodocstring; \
		code --install-extension visualstudioexptteam.intellicode-api-usage-examples; \
		code --install-extension visualstudioexptteam.vscodeintellicode; \
		code --install-extension wholroyd.jinja; \
		code --install-extension ziyasal.vscode-open-in-github; \
	else \
		echo "VS Code not installed, skipping extension installation"; \
	fi

# Install and configure chezmoi
install-chezmoi:
	@echo "Setting up chezmoi for dotfiles management..."
	@if ! command -v chezmoi &> /dev/null; then \
		echo "Installing chezmoi..."; \
		if [ "$(ARCH_CHECK)" = "true" ]; then \
			sudo pacman -S --needed --noconfirm chezmoi; \
		else \
			sh -c "$$(curl -fsLS get.chezmoi.io)" -- -b $$HOME/.local/bin; \
			if [ ! "$$PATH" = *"$$HOME/.local/bin"* ]; then \
				export PATH="$$PATH:$$HOME/.local/bin"; \
			fi; \
		fi; \
	else \
		echo "chezmoi already installed"; \
	fi
	
	@# Initialize chezmoi with the dotfiles directory
	@echo "Initializing chezmoi with dotfiles..."
	@DOTFILES_DIR="$$(cd "$$(dirname "$$0")" && pwd)"; \
	chezmoi init --apply --source="$$DOTFILES_DIR"
	
	@echo "chezmoi setup completed!"

install-configs:
	@echo "Installing configuration files using chezmoi..."
	@$(MAKE) install-chezmoi
	@echo "Config files installed successfully!"

clean:
	@echo "Cleaning up..."
	@rm -rf ~/.cache/chezmoi
	@echo "Removing symlinked config files..."
	@if command -v chezmoi &> /dev/null; then \
		echo "Removing files managed by chezmoi..."; \
		chezmoi purge --force; \
	else \
		rm -f $(HOME)/.bashrc; \
		rm -f $(HOME)/.zshrc; \
		if [ -d "$(HOME)/.config/nvim" ]; then \
			find $(CURDIR)/.nvim -type f -exec rm -f $(HOME)/.config/nvim/$(basename {}) \;; \
		fi; \
		if [ -d "$(HOME)/.config/wezterm" ]; then \
			find $(CURDIR)/.wezterm -type f -exec rm -f $(HOME)/.config/wezterm/$(basename {}) \;; \
		fi; \
		if [ -d "$(HOME)/.config/nushell" ]; then \
			find $(CURDIR)/nushell -type f -exec rm -f $(HOME)/.config/nushell/$(basename {}) \;; \
		fi; \
		if [ -d "$(HOME)/.config/Code/User" ]; then \
			rm -f $(HOME)/.config/Code/User/settings.json; \
			rm -f $(HOME)/.config/Code/User/keybindings.json; \
		fi; \
	fi
	
	@echo "Cleanup completed!"

install-hyprland: install-packages install-aur install-dotfiles
	@echo "Hyprland and all related tools installed!"

install-dotfiles:
	@chezmoi apply --force

postinstall:
	@chmod +x scripts/unix/symlink_wallpapers.sh
	@scripts/unix/symlink_wallpapers.sh