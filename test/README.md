# Dotfiles System & Integration Tests

This directory contains system-level and environment tests for your dotfiles setup. All tests can be run locally/offline using [act](https://github.com/nektos/act), which runs GitHub Actions workflows in Docker containers on your machine.

## What is tested?

- **System/Environment:**
  - Dotfiles bootstrap scripts (install, setup, chezmoi, etc.)
  - Shell configs (bash, zsh, PowerShell, etc.)
  - Key CLI tools and aliases
  - OS-level compatibility (Ubuntu, Fedora, Arch, Alpine, macOS, Windows)
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
     act -j test-linux
     act -j test-macos
     act -j test-windows
     ```

   - Or just `act` to run all jobs. This will use the Dockerfiles in `test/` and run the same tests as CI, but locally and offline.

3. **What happens?**
   - act will build Docker containers for each OS, run the bootstrap scripts, and execute all system and Neovim tests.
   - Neovim tests are run as part of the system test scripts (see below).

## Directory Structure

- `test.sh`, `test.ps1`: Main test scripts for Linux/macOS and Windows
- `Dockerfile.*`: Dockerfiles for each OS
- `run-all.sh`: Helper to run all Docker-based tests
- `config/nvim/lua/custom/tests/`: Neovim-specific tests (run inside Neovim)

## See Also

- For Neovim-specific test details, see `config/nvim/lua/custom/tests/README.md`.
