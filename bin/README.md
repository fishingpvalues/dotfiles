# bin/

This directory is for custom binaries and utility scripts used by your dotfiles or bootstrap process.

- The `bin/` directory is added to your PATH by the setup scripts for easy access.
- For general installation, usage, and troubleshooting, see [README.md](../README.md).
- For cross-platform compatibility, prefer scripts that work on multiple OSes or provide platform-specific versions as needed.

## Best Practices

- **Do not store large or third-party binaries** here; use package managers or document install steps in `bootstrap/`.
- **Document any custom tools** you add here in this README.
- **Scripts should be executable** (`chmod +x script.sh` or equivalent).
- **Avoid secrets or sensitive data** in this directory.

## Example

- `chezmoi.exe` — The chezmoi binary for Windows (auto-installed by setup scripts)
- `my-custom-tool.sh` — Example custom script (document usage here)

---

If you add new tools, update this README with a brief description and usage instructions.
