-- hlargs.nvim: Highlight function arguments
return {
  "m-demare/hlargs.nvim",
  event = "VeryLazy",
  config = function()
    require("hlargs").setup {
      color = "#e5c07b",
      use_colorpalette = true,
      paint_arg_declarations = true,
      paint_arg_usages = true,
      extras = {
        named_parameters = true,
      },
    }
  end,
} 