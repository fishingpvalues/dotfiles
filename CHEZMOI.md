# Chezmoi Dotfiles Management Guide

> For general installation and usage, see [README.md](README.md).

> **Note:** This project is designed for chezmoi v2.x (latest tested: v2.37.0). For compatibility, always install chezmoi v2.x. See install instructions below.

This guide explains how to use [chezmoi](https://www.chezmoi.io/) to manage your dotfiles across multiple machines and operating systems. It covers advanced usage, templating, and secret management.

## Table of Contents

- [Getting Started](#getting-started)
- [Basic Commands](#basic-commands)
- [Configuration Structure](#configuration-structure)
- [Templates and Variables](#templates-and-variables)
- [Secret Management](#secret-management)
- [OS-Specific Configuration](#os-specific-configuration)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)
- [2025 SOTA CLI Tools (Recommended)](#2025-sota-cli-tools-recommended)

## Getting Started

Chezmoi is a powerful dotfiles manager that helps you:

- Track changes to your configuration files
- Synchronize configuration across multiple machines
- Use templates to customize configuration per machine
- Securely handle sensitive information
- Work across different operating systems

## Basic Commands

After installation (see [README.md](README.md)), you can use the following commands to manage your dotfiles:

### View Status

Check the status of your dotfiles to see what would change if you applied:

```bash
chezmoi status
```

### Edit a File

Edit a file managed by chezmoi:

```bash
chezmoi edit ~/.bashrc
# or
chezmoi edit $HOME/.config/nvim/init.lua
```

### Add a File

Add a new dotfile to chezmoi's management:

```bash
chezmoi add ~/.config/new-config-file
```

### Apply Changes

Apply the changes to your home directory:

```bash
# First check what would change
chezmoi diff

# Then apply the changes
chezmoi apply
```

### Update from Git Repository

Pull the latest changes from your Git repository and apply them:

```bash
chezmoi update
```

## Configuration Structure

The repository is organized to work with chezmoi's expected structure:

```
dotfiles/
├── .chezmoi.toml         # Chezmoi configuration
├── bin/                  # Contains chezmoi binary
├── config/               # Your actual configuration files
│   ├── bash/             # Bash shell configuration
│   ├── nvim/             # Neovim configuration
│   ├── vscode/           # VS Code settings
│   └── ...               # Other tool configurations
├── bootstrap/            # Setup scripts
```

When you run the setup scripts, they will:

1. Map your config files to their appropriate locations in chezmoi's source state
2. Install chezmoi if it's not already installed
3. Add chezmoi to your PATH
4. Configure chezmoi to work with your dotfiles repository

## Templates and Variables

Chezmoi supports Go templates to customize configuration based on the system. The `.chezmoi.toml` file defines variables used in templates.

### Example Template

```toml
# .chezmoi.toml
[data]
    email = "your.email@example.com"
    name = "Your Name"
```

Then in a file (like `.gitconfig`), you can use:

```gitconfig
# dot_gitconfig.tmpl
[user]
    name = {{ .name }}
    email = {{ .email }}
```

### OS-Specific Templates

You can create templates that apply different configurations based on the operating system:

```bash
# Template example with OS-specific configuration
{{- if eq .chezmoi.os "darwin" }}
# macOS specific settings
export PATH="/opt/homebrew/bin:$PATH"
{{- else if eq .chezmoi.os "linux" }}
# Linux specific settings
export PATH="$HOME/.local/bin:$PATH" 
{{- else if eq .chezmoi.os "windows" }}
# Windows specific settings
{{- end }}
```

## OS-Specific Configuration

The setup scripts handle OS detection and apply the appropriate configurations:

- **Windows**: Uses the bootstrap/setup-chezmoi.ps1 script
- **macOS/Linux**: Uses the bootstrap/setup-chezmoi.sh script
- **Arch Linux**: Uses the bootstrap/setup-chezmoi-arch.sh script

## Advanced Usage

### Using .chezmoiignore

You can create a `.chezmoiignore` file to specify files that chezmoi should ignore:

```
# Ignore these files
README.md
LICENSE
*.swp
```

### Using .chezmoiremove

Files listed in `.chezmoiremove` will be removed when running `chezmoi apply`:

```
# Remove these files when applying changes
.old_config
.deprecated_tool_config
```

### External Tools Integration

Chezmoi can integrate with:

- **Pass/Bitwarden/1Password**: For managing secrets
- **Git**: For version control
- **GPG**: For encryption

## Secret Management

You can securely manage secrets using age encryption:

```bash
# Generate a key
chezmoi age generate --output ~/.config/chezmoi/key.txt

# Encrypt a file
chezmoi age encrypt --output ~/.local/share/chezmoi/encrypted_file.txt.age /path/to/secret/file.txt
```

Then in your `.chezmoi.toml`:

```toml
encryption = "age"
[age]
    identity = "~/.config/chezmoi/key.txt"
    recipient = "age1..."
```

## Troubleshooting

### Common Issues

1. **Changes not applying**: Run `chezmoi diff` to see what would change, then `chezmoi apply -v` for verbose output.
2. **Conflicts with existing files**: Use `chezmoi merge` to resolve conflicts.
3. **Command not found**: Make sure chezmoi is in your PATH. The setup scripts should add it automatically.
4. **Template errors**: Check your template syntax and ensure variables are defined in `.chezmoi.toml`.

### Getting Help

If you encounter issues:

```bash
# Get help for any command
chezmoi help [command]

# Check version
chezmoi --version

# Get verbose output
chezmoi [command] -v
```

## Resources

- [Chezmoi Documentation](https://www.chezmoi.io/user-guide/command-overview/)
- [Chezmoi Template Guide](https://www.chezmoi.io/user-guide/templating/)
- [Chezmoi GitHub Repo](https://github.com/twpayne/chezmoi)

## 2025 SOTA CLI Tools (Recommended)

This dotfiles repo includes config stubs and aliases for the following SOTA tools:

- **Ghostty**: GPU-accelerated terminal (`~/.config/ghostty/config`)
- **mise**: Universal version manager (`~/.config/mise/config.toml`)
- **Jujutsu**: Next-gen VCS, Git-compatible (`~/.config/jj/config.toml`)
- **code2**: AI-powered CLI workflows (`~/.config/code2/config.toml`)
- **BashBuddy**: Natural language shell helper (`~/.config/bashbuddy/config.toml`)
- **lsd**: Modern `ls` replacement (`~/.config/lsd/config.yaml`)
- **trash-cli**: Safe `rm` alternative (no config needed)

All are integrated for zsh/oh-my-zsh and Powerlevel10k. See `config/zsh/zshrc` for details.

---

With this guide and the setup scripts, you can manage your dotfiles efficiently across multiple machines and operating systems with chezmoi.
