# Dotfiles System & Integration Tests

This directory contains system-level and environment tests for your dotfiles setup. All tests can be run locally/offline using [act](https://github.com/nektos/act), which runs GitHub Actions workflows in Docker containers on your machine.

## What is tested?

- **System/Environment:**
  - Dotfiles bootstrap scripts (install, setup, chezmoi, etc.)
  - Shell configs (bash, zsh, PowerShell, etc.)
  - Key CLI tools and aliases
  - OS-level compatibility (Ubuntu, Fedora, Arch, Alpine, macOS, Windows)
  - LSP install scripts (using the centralized `.lsp-servers` list)
- **Neovim:**
  - Neovim config and plugins are tested via Plenary.nvim (see `config/nvim/lua/custom/tests/` for details)

## How to Run All Tests Locally

1. **Install act:**
   - [See act install instructions](https://github.com/nektos/act#installation)
   - On macOS/Linux: `brew install act` or download from releases.
   - On Windows: `scoop install act` or download from releases.

2. **Run all tests:**
   - From the repo root, run:

     ```sh
     ./test/run-all.sh
     # or on Windows
     pwsh ./test/run-all.ps1
     ```

   - Or use `act` to run all jobs as in CI. This will use the Dockerfiles in `test/` and run the same tests as CI, but locally and offline.

3. **What happens?**
   - All platform bootstrap scripts, LSP install scripts, and Neovim Plenary tests are run and checked for errors.
   - Neovim tests are run as part of the system test scripts.

## Directory Structure

- `test.sh`, `test.ps1`: Main test scripts for Linux/macOS and Windows
- `run-all.sh`, `run-all.ps1`: Unified entry points for all platforms
- `Dockerfile.*`: Dockerfiles for each OS
- `.lsp-servers`: Centralized list of LSP servers for all platforms
- `config/nvim/lua/custom/tests/`: Neovim-specific tests (run inside Neovim)

## See Also

- For Neovim-specific test details, see `config/nvim/lua/custom/tests/README.md`.
