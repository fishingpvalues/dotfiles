-- persistent-breakpoints.nvim: Save and restore breakpoints across sessions
return {
  "Weissle/persistent-breakpoints.nvim",
  event = { "BufReadPost", "BufWritePost" },
  dependencies = { "mfussenegger/nvim-dap" },
  opts = {
    load_breakpoints_event = { "BufReadPost" },
    save_dir = vim.fn.stdpath("data") .. "/breakpoints/",
    -- Optionally, auto-save breakpoints on buffer write
    save_on_change = true,
    -- Optionally, auto-load breakpoints on DAP attach
    load_on_dap_attach = true,
  },
  config = function(_, opts)
    local ok, pb = pcall(require, "persistent-breakpoints")
    if ok then
      pb.setup(opts)
      -- Keymaps for managing breakpoints
      vim.keymap.set("n", "<leader>db", function() require("persistent-breakpoints.api").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function() require("persistent-breakpoints.api").set_conditional_breakpoint() end, { desc = "Set Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>dc", function() require("persistent-breakpoints.api").clear_all_breakpoints() end, { desc = "Clear All Breakpoints" })
    end
  end,
} 