-- Module for toggling UI icons

local M = {}

function M.setup()
  -- This module provides commands to toggle UI elements like icons
  -- Command to toggle Neovim's icons
  vim.api.nvim_create_user_command("ToggleIcons", function()
    vim.g.have_nerd_font = not vim.g.have_nerd_font
    print("Icons " .. (vim.g.have_nerd_font and "enabled" or "disabled") .. ". Restart Neovim for full effect.")
  end, { desc = "Toggle Nerd Font icons" })
end

return M