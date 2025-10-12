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
    -- Keymaps for terminals (moved to <leader>T to avoid conflict with neotest)
    vim.keymap.set("n", "<leader>Tt", ":ToggleTerm direction=horizontal<CR>", { desc = "Terminal horizontal" })
    vim.keymap.set("n", "<leader>Tf", ":ToggleTerm direction=float<CR>", { desc = "Terminal floating" })
    vim.keymap.set("n", "<leader>Tv", ":ToggleTerm direction=vertical size=80<CR>", { desc = "Terminal vertical" })
  end,
} 