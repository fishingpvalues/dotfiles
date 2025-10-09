-- fidget.nvim: LSP progress notifications
return {
  "j-hui/fidget.nvim",
  tag = "legacy",
  event = "LspAttach",
  config = function()
    require("fidget").setup {
      text = {
        spinner = "dots",
        done = "✔",
      },
      win = {
        relative = "editor",
        blend = 0,
      },
      fmt = {
        stack_upwards = false,
      },
    }
  end,
} 