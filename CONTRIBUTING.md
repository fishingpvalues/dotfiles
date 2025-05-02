# Contributing to Dotfiles & Bootstrap Scripts

Thank you for your interest in contributing! This project separates dotfiles/configs from installation/bootstrap logic for clarity and maintainability.

## How to Contribute

### 1. **Adding or Updating Dotfiles**

- Place new or updated configuration files in the appropriate subdirectory under `config/`.
- Use `chezmoi add <file>` to add files to chezmoi management.
- Test changes locally with `chezmoi apply --dry-run` and `chezmoi verify`.
- Update documentation if you add new tools or configs.

### 2. **Adding or Updating Bootstrap/Install Scripts**

- Place new install/bootstrap scripts in the appropriate subdirectory under `bootstrap/`:
  - `bootstrap/scripts/unix/` for macOS/Linux/Unix scripts
  - `bootstrap/scripts/windows/` for Windows scripts
  - `bootstrap/.macos/` for macOS system/app tweaks
- If adding a new platform or major script, update `bootstrap/README.md`.
- Ensure scripts are idempotent and safe to re-run.
- Use clear, descriptive names and comments.

### 3. **Testing & Linting**

- All scripts are automatically linted and tested via GitHub Actions CI.
- Run `shellcheck` on bash scripts and `Invoke-ScriptAnalyzer` on PowerShell scripts locally if possible.
- Test scripts in a clean environment (VM, container, or fresh user account) before submitting.

### 4. **Pull Requests**

- Fork the repository and create a new branch for your changes.
- Ensure your branch is up to date with `main`.
- Open a pull request with a clear description of your changes and why they are needed.
- Reference any related issues or discussions.

### 5. **Best Practices**

- Keep install/bootstrap logic out of the main dotfiles/configs.
- Do not store secrets or machine-specific config in the repo.
- Keep scripts modular, maintainable, and well-documented.
- Update relevant documentation (`README.md`, `bootstrap/README.md`, etc.) as needed.

## Directory Structure

```
dotfiles/
  config/           # All dotfiles/configs
  bootstrap/        # All install/bootstrap scripts
    scripts/
      unix/         # macOS/Linux/Unix scripts
      windows/      # Windows scripts
    .macos/         # macOS system/app scripts
    dot_Brewfile    # Homebrew bundle (macOS)
```

## Questions or Issues?

- Open an issue or discussion in the repository.
- For security or sensitive topics, contact the maintainer directly.

---

Thank you for helping keep this project clean, maintainable, and extensible!
