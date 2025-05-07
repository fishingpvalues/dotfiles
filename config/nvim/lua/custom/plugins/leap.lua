-- Leap.nvim configuration - enhanced motions that work with transparency
return {
  "ggandor/leap.nvim",
  event = "VeryLazy",
  dependencies = { 
    "tpope/vim-repeat"
  },
  config = function()
    -- Setup leap with transparency-friendly highlight colors
    require("leap").add_default_mappings()
    
    -- Customize highlights for better visibility with transparency
    vim.api.nvim_set_hl(0, "LeapMatch", { fg = "#ff007c", bold = true, nocombine = true })
    vim.api.nvim_set_hl(0, "LeapLabelPrimary", { fg = "#ff007c", bold = true, nocombine = true })
    vim.api.nvim_set_hl(0, "LeapLabelSecondary", { fg = "#00dfff", bold = true, nocombine = true })
    
    -- Set up cross-window jumping with transparent UI
    -- (Removed: now in keymaps.lua)
  end,
}