#!/usr/bin/env bash
# Run all Neovim config tests in this folder using plenary.nvim

set -e

cd "$(dirname "$0")"

if [ -f "../../minimal_init.lua" ]; then
  nvim --headless -c "PlenaryBustedDirectory . {minimal_init = '../../minimal_init.lua'}"
else
  nvim --headless -c "PlenaryBustedDirectory ."
fi 