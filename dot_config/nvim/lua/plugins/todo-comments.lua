-- Todo comments highlighting
return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = true,
    keywords = {
      FIX = {
        icon = " ", -- icon used for the sign, and in search results
        color = "error", -- can be a hex color, or a named color (see below)
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
        -- signs = false, -- configure signs for some keywords individually
      },
      TODO = { icon = " ", color = "info" },
      HACK = { icon = " ", color = "warning" },
      WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    },
    highlight = {
      -- Highlight the line containing the todo
      before = "", -- "fg" or "bg" or empty
      keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty
      after = "fg", -- "fg" or "bg" or empty
      
      -- Updated pattern to be more compatible
      pattern = [[.*<?(KEYWORDS)\s*:?]], -- simplified pattern
      comments_only = true, -- this applies the pattern only inside comments
      max_line_len = 400, -- ignore lines longer than this
      exclude = {}, -- list of file types to exclude highlighting
    },
    search = {
      -- Updated search pattern to make it more compatible
      pattern = [[\b(KEYWORDS)(?::|)\b]], -- simplified ripgrep regex
    },
  },
  config = function(_, opts)
    require("todo-comments").setup(opts)
  end,
}