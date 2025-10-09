-- Hodur Plugin Configuration
-- https://github.com/vodchella/hodur.nvim
return {
  'vodchella/hodur.nvim',
  config = function()
    require('hodur').setup({
      -- uncomment to override the default key
      -- key = "<C-g>"
    })
  end
} 