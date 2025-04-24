-- Indent-blankline configuration with transparency-friendly settings
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

    -- Set up hooks for transparency compatibility
    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      -- Make indent lines subtle and compatible with transparency
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#393f4a", nocombine = true })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#4e5666", nocombine = true })
    end)
  end,
}