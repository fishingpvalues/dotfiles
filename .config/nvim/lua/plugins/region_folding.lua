-- region_folding.lua
-- Plugin: nicolas-martin/region-folding.nvim
-- Custom region folding with best settings for your workflow

return {
    "nicolas-martin/region-folding.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        region_text = { start = "#region", ending = "#endregion" },
        fold_indicator = "▼", -- visually clear indicator
    },
}
