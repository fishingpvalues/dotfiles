-- Yazi.nvim integration for Neovim (SOTA config)
return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  dependencies = {
    "folke/snacks.nvim", -- recommended for buffer deletion and picker integration
  },
  keys = {
    { "<leader>-", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file" },
    { "<leader>cw", "<cmd>Yazi cwd<cr>", desc = "Open yazi in nvim's working directory" },
    { "<c-up>", "<cmd>Yazi toggle<cr>", desc = "Resume last yazi session" },
  },
  init = function()
    -- Recommended: disable netrw plugin if using open_for_directories
    vim.g.loaded_netrwPlugin = 1
  end,
  opts = {
    open_for_directories = true, -- replace netrw for directories
    open_multiple_tabs = true,   -- open visible splits as yazi tabs
    floating_window_scaling_factor = 0.95,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = "rounded",
    clipboard_register = "*",
    highlight_hovered_buffers_in_same_directory = true,
    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
      change_working_directory = "<c-\\>",
    },
    integrations = {
      bufdelete_implementation = "snacks-if-available",
      picker_add_copy_relative_path_action = "snacks.picker",
    },
    future_features = {
      process_events_live = true,
    },
  },
} 