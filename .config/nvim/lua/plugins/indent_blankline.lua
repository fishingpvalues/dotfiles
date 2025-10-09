-- Indent-blankline configuration
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│", -- Subtle vertical line
      tab_char = "│",
    },
    scope = { enabled = true },
    exclude = {
      filetypes = {
        "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble", "lazy",
        "mason", "notify", "toggleterm", "lazyterm",
      },
      buftypes = {
        "terminal", "nofile", "quickfix", "prompt",
      },
    },
  },
  config = function(_, opts)
    -- Load the plugin
    local ibl = require("ibl")
    ibl.setup(opts)
    -- Removed transparency highlight hooks
  end,
} 