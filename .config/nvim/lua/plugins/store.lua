-- store.nvim: Plugin discovery and installation with 5500+ plugin database
-- Provides an intuitive UI for browsing, searching, and installing Neovim plugins
return {
  "alex-popov-tech/store.nvim",
  dependencies = {
    "OXY2DEV/markview.nvim", -- Required for markdown README preview
  },
  cmd = "Store", -- Lazy load on :Store command
  opts = {
    -- All configuration is handled by the plugin defaults
    -- The plugin provides smart defaults for filtering, sorting, and caching
  },
  keys = {
    {
      "<leader>ps",
      "<cmd>Store<cr>",
      desc = "Open Plugin Store",
    },
  },
}
