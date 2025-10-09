-- vim-illuminate configuration
return {
  "RRethy/vim-illuminate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    delay = 200,
    large_file_cutoff = 2000,
    large_file_overrides = { providers = { "lsp" } },
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
    vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#2c323c", blend = 20 })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#2c323c", blend = 20 })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#2c323c", blend = 20 })
  end,
} 