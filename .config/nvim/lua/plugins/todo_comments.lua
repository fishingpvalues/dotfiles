-- todo-comments.nvim: Highlight and search TODO/FIXME/NOTE comments
return {
  "folke/todo-comments.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("todo-comments").setup {
      signs = true, -- show icons in the sign column
      keywords = {
        FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
        TODO = { icon = " ", color = "info" },
        HACK = { icon = " ", color = "warning" },
        WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      },
      highlight = {
        before = "fg",
        keyword = "bg",
        after = "fg",
        pattern = ".*<(KEYWORDS)[:%(%[]",
        comments_only = true,
        max_line_len = 400,
        exclude = {}
      },
      search = {
        command = "rg",
        args = {
          "--color=never", "--no-heading", "--with-filename", "--line-number", "--column"
        },
        pattern = [[\b(KEYWORDS):]],
      },
    }
  end,
} 