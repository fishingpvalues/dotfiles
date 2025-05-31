-- Leap.nvim configuration
return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = { 
    "tpope/vim-repeat"
  },
  config = function()
    require("leap").add_default_mappings()
    -- Removed transparency highlight customization
  end,
}