-- Web devicons with transparency support
return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  config = function()
    require("nvim-web-devicons").setup({
      -- Override icon settings to work well with transparency
      override = {
        -- You can customize specific file icons here if needed
      },
      -- Enable folder icons
      default = true,
    })
  end,
}