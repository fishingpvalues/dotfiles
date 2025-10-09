-- nvim-spectre: Project-wide search/replace
return {
  "nvim-pack/nvim-spectre",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("spectre").setup {
      open_cmd = 'noswapfile vnew',
      live_update = true, -- auto execute search after typing
      line_sep_start = '┌-----------------------------------------',
      result_padding = '│ ',
      line_sep = '└-----------------------------------------',
      highlight = {
        ui = "String",
        search = "DiffChange",
        replace = "DiffDelete",
      },
    }
    -- Keymap for project search
    vim.keymap.set('n', '<leader>S', require('spectre').open, { desc = 'Open Spectre' })
  end,
} 