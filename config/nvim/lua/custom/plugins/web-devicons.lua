-- Web devicons config
return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  config = function()
    require("nvim-web-devicons").setup({
      -- You can customize specific file icons here if needed
      override = {},
      -- Enable folder icons
      default = true,
    })
  end,
}