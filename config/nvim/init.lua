--[[
=====================================================================
==================== INTEGRATED NEOVIM CONFIG =======================
=====================================================================
Based on nvim basis with transparency and blur effects added
to match the dotfiles theme aesthetic
=====================================================================
]]

-- Set <space> as the leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- Enable transparency and blur effects to match dotfiles theme
vim.g.transparent_enabled = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- [[ Load custom commands and custom modules ]]
require('custom.init')

-- The line beneath this is called `modeline`. See `