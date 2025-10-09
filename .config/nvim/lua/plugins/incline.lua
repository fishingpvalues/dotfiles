-- incline.nvim: Modern buffer/tabline
return {
  "b0o/incline.nvim",
  event = "BufReadPre",
  config = function()
    require("incline").setup {
      highlight = {
        groups = {
          InclineNormal = { guibg = "#232136", guifg = "#e0def4" },
          InclineNormalNC = { guibg = "#2a273f", guifg = "#6e6a86" },
        },
      },
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = 1,
        placement = { horizontal = "right", vertical = "top" },
      },
      render = "basic",
    }
  end,
} 