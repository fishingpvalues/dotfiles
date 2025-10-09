-- Referencer Plugin Configuration
-- https://github.com/romus204/referencer.nvim
return {
  'romus204/referencer.nvim',
  config = function()
    require('referencer').setup({
      -- All options are optional, showing defaults for reference
      -- enable = false,
      -- format = "  %d reference(s)",
      -- show_no_reference = true,
      -- kinds = { 5, 6, 8, 12, 13, 14, 23, },
      -- hl_group = "Comment",
      -- color = nil,
      -- virt_text_pos = "eol",
      -- pattern = nil,
    })
  end,
} 