return {
  {
    -- GitHub's own palette, via the theme projekt0n maintains against the
    -- upstream VS Code theme. `github_dark_default` is the one GitHub ships as
    -- "Dark default" - not `github_dark` (the older, higher-contrast one) and
    -- not `github_dark_dimmed` (the muted variant).
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    priority = 1000,   -- must load before anything that sets a highlight
    config = function()
      require("github-theme").setup({
        options = {
          transparent = false,
          hide_end_of_buffer = true,
          hide_nc_statusline = true,
          styles = {
            comments = "italic",
            keywords = "NONE",
            functions = "NONE",
            variables = "NONE",
          },
          inverse = { match_paren = true },
          darken = {
            floats = true,
            sidebars = { enabled = true },
          },
        },
      })
      vim.cmd.colorscheme("github_dark_default")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        theme = "github_dark_default",
        globalstatus = true,
        section_separators = "",
        component_separators = "|",
      },
      sections = {
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "diagnostics", "filetype" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = { preset = "helix" },
  },
}
