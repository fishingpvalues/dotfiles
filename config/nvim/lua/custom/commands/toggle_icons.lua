-- Module for toggling UI icons and transparency

local M = {}

function M.setup()
  -- This module provides commands to toggle UI elements like icons and transparency
  
  -- Command to toggle Neovim's icons
  vim.api.nvim_create_user_command("ToggleIcons", function()
    vim.g.have_nerd_font = not vim.g.have_nerd_font
    print("Icons " .. (vim.g.have_nerd_font and "enabled" or "disabled") .. ". Restart Neovim for full effect.")
  end, { desc = "Toggle Nerd Font icons" })

  -- Force enable transparency when requested
  vim.api.nvim_create_user_command("TransparencyOn", function()
    vim.g.transparent_enabled = true
    vim.cmd("TransparentEnable")
    vim.cmd("redraw!")
    print("Transparency enabled.")
  end, { desc = "Enable transparency mode" })

  -- Force disable transparency when requested  
  vim.api.nvim_create_user_command("TransparencyOff", function()
    vim.g.transparent_enabled = false
    vim.cmd("TransparentDisable")
    vim.cmd("redraw!")
    print("Transparency disabled.")
  end, { desc = "Disable transparency mode" })
end

return M