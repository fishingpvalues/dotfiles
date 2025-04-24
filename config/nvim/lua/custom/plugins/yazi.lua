-- Yazi.nvim file manager integration
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    "folke/snacks.nvim",
    "nvim-lua/plenary.nvim"
  },
  keys = {
    {
      "<leader>fy",
      mode = { "n", "v" },
      "<cmd>Yazi<cr>",
      desc = "Open yazi at the current file"
    },
    {
      "<leader>fd",
      "<cmd>Yazi cwd<cr>",
      desc = "Open yazi in current directory"
    },
    {
      "<C-Up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Toggle yazi file manager"
    },
  },
  opts = {
    -- Open yazi instead of netrw for directories
    open_for_directories = true,
    
    -- Open visible splits as yazi tabs for easy navigation
    open_multiple_tabs = true,
    
    -- Highlight groups to match your transparency theme
    highlight_groups = {
      hovered_buffer = "CursorLine",
      hovered_buffer_in_same_directory = "Visual",
    },
    
    -- Set the floating window to match your transparency settings
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = vim.g.transparent_enabled and 0 or 0,
    
    -- Use rounded border for the floating window to match other UI elements
    yazi_floating_window_border = "rounded",
    
    hooks = {
      -- Add any additional actions when yazi opens
      yazi_opened = function(preselected_path, yazi_buffer_id, config)
        -- Apply transparency to yazi window if transparency is enabled
        if vim.g.transparent_enabled then
          vim.defer_fn(function()
            vim.api.nvim_set_hl(0, "YaziFloat", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "YaziFloatBorder", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "YaziNormal", { bg = "NONE" })
          end, 10)
        end
      end,
    },
    
    -- Enable highlighting of buffers in the same directory as the hovered buffer
    highlight_hovered_buffers_in_same_directory = true,
    
    future_features = {
      -- Process events live for better responsiveness
      process_events_live = true,
    },
  },
  init = function()
    -- Disable netrw in favor of yazi
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
  end,
}