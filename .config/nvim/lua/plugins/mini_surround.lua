-- mini.surround: Modern surround editing
return {
  "echasnovski/mini.surround",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup()
  end,
} 