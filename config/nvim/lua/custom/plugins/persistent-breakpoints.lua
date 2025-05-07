-- Persistent breakpoints for nvim-dap
return {
  "Weissle/persistent-breakpoints.nvim",
  dependencies = {
    "mfussenegger/nvim-dap",
  },
  opts = {
    -- Load breakpoints when opening files
    load_breakpoints_event = { "BufReadPost" },
    -- Save breakpoints automatically
    save_dir = vim.fn.stdpath("data") .. "/breakpoints",
  },
  config = function(_, opts)
    -- Load the plugin
    require("persistent-breakpoints").setup(opts)
    
    -- Add keymaps for managing breakpoints
    -- (Removed: now in keymaps.lua)
  end,
}