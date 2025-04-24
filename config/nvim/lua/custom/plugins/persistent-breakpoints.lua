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
    vim.keymap.set("n", "<leader>db", 
      function() require("persistent-breakpoints.api").toggle_breakpoint() end,
      { desc = "Toggle Breakpoint" })
    
    vim.keymap.set("n", "<leader>dB", 
      function() require("persistent-breakpoints.api").set_conditional_breakpoint() end,
      { desc = "Set Conditional Breakpoint" })
      
    vim.keymap.set("n", "<leader>dc", 
      function() require("persistent-breakpoints.api").clear_all_breakpoints() end,
      { desc = "Clear All Breakpoints" })
  end,
}