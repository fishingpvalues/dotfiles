-- markview.nvim: Beautiful markdown rendering for Neovim
-- Required dependency for store.nvim's README preview feature
return {
  "OXY2DEV/markview.nvim",
  lazy = false, -- Load immediately to support store.nvim
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- SOTA configuration for beautiful markdown rendering (2025 API)
    preview = {
      modes = { "n", "i", "no", "c" }, -- Render in all modes
      hybrid_modes = { "i" }, -- Hybrid mode for insert

      -- Callbacks for better integration
      callbacks = {
        on_enable = function(_, win)
          vim.wo[win].conceallevel = 2
          vim.wo[win].concealcursor = "nc"
        end,
      },
    },
  },
}
