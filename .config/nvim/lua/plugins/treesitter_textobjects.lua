-- nvim-treesitter-textobjects: Advanced text objects for Treesitter
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    -- No explicit setup needed; config is in nvim-treesitter setup
    -- Ensure textobjects are enabled in nvim-treesitter config
  end,
} 