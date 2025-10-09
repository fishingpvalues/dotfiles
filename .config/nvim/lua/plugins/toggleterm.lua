-- toggleterm.nvim: Modern terminal integration
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  event = "VeryLazy",
  opts = {
    size = 20,
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 3,
      highlights = { border = "Normal", background = "Normal" },
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    -- Keymaps for horizontal and floating terminals
    vim.keymap.set("n", "<leader>tt", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
    vim.keymap.set("n", "<leader>tf", ":ToggleTerm direction=float<CR>", { desc = "Toggle floating terminal" })
  end,
} 