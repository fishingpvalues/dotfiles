-- Configuration for which-key with transparency support

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    window = {
      border = "rounded", -- none, single, double, shadow, rounded
      position = "bottom", -- bottom, top
      margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
      padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
      -- Set background to "none" for transparency
      winblend = vim.g.transparent_enabled and 15 or 0, -- value between 0-100, for transparency
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and its label
      group = "+", -- symbol prepended to a group
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- Register key mappings for transparency and UI handling
    wk.register({
      ["<leader>T"] = { ':split | terminal<CR>', "Open terminal in split" },
      ["<leader>u"] = {
        name = "Transparency",
        t = { "<cmd>lua vim.g.transparent_enabled = not vim.g.transparent_enabled; if vim.g.transparent_enabled then vim.cmd('TransparentEnable') else vim.cmd('TransparentDisable') end<cr>", "Toggle Transparency" },
        e = { "<cmd>TransparentEnable<cr>", "Enable Transparency" },
        d = { "<cmd>TransparentDisable<cr>", "Disable Transparency" },
      },
      ["<leader>"] = {
        -- Other groups and mappings
        f = { name = "Find/Telescope" },
        e = { name = "Explorer" },
        g = { name = "Git" },
        c = { name = "Code/LSP" },
        d = { name = "Debug" },
        b = { name = "Buffers" },
      },
    })

    -- Register all additional which-key mappings from centralized keymaps
    -- pcall(require, 'keymaps')
  end,
}