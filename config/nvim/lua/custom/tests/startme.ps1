#!/usr/bin/env pwsh
# Run all Neovim config tests in this folder using plenary.nvim

$ErrorActionPreference = "Stop"

Set-Location $PSScriptRoot

$minimalInit = Join-Path $PSScriptRoot "..\..\minimal_init.lua"
if (Test-Path $minimalInit) {
    nvim --headless -c "PlenaryBustedDirectory . {minimal_init = '../../minimal_init.lua'}"
} else {
    nvim --headless -c "PlenaryBustedDirectory ."
} 