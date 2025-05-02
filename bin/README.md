# bin/

This directory is intended for custom binaries and utility scripts that are used by your dotfiles or bootstrap process.

## Usage

- Place custom executables, compiled binaries, or utility scripts here.
- The `bin/` directory is added to your PATH by the setup scripts for easy access.
- For cross-platform compatibility, prefer scripts that work on multiple OSes or provide platform-specific versions as needed.

## Best Practices

- **Do not store large or third-party binaries** in this directory; use package managers or document install steps in `bootstrap/`.
- **Document any custom tools** you add here in this README.
- **Scripts should be executable** (`chmod +x script.sh` or equivalent).
- **Avoid secrets or sensitive data** in this directory.

## Example

- `chezmoi.exe` — The chezmoi binary for Windows (auto-installed by setup scripts)
- `my-custom-tool.sh` — Example custom script (document usage here)

---

If you add new tools, update this README with a brief description and usage instructions.
