-- nvim-treesitter-playground: Treesitter playground for debugging
return {
  "nvim-treesitter/playground",
  cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  config = function()
    require("nvim-treesitter.configs").setup {
      playground = {
        enable = true,
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
      },
    }
  end,
} 