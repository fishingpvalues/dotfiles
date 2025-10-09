-- GitHub Dark theme setup
return {
  "projekt0n/github-nvim-theme",
  priority = 1000,
  config = function()
    require('github-theme').setup({
      options = {
        styles = {
          comments = "NONE",
          keywords = "NONE",
          functions = "NONE",
          variables = "NONE",
        },
      },
    })
    vim.cmd.colorscheme('github_dark_default')
  end,
} 