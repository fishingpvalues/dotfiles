-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
-- SOTA Neovim plugin setup: minimal, modern, modular
return {
  require('plugins.region_folding'),
  require('plugins.lualine'),
  require('plugins.github_dark'),
  require('plugins.trouble'),
  require('plugins.indent_blankline'),
  require('plugins.lspkind'),
  require('plugins.luasnip'),
  require('plugins.web_devicons'),
  -- Add mini.icons for icon support
  {
    "echasnovski/mini.icons",
    version = false,
    config = function()
      require("mini.icons").setup()
    end,
  },
  require('plugins.illuminate'),
  require('plugins.yazi'),
  require('plugins.pickme'),
  require('plugins.noice'),
  require('plugins.dap_ui'),
  require('plugins.dap_virtual_text'),
  require('plugins.flash'),
  require('plugins.diffview'),
  require('plugins.rainbow_csv'),
  require('plugins.neoscroll'),
  require('plugins.referencer'),
  require('plugins.which_key_fix'),
  require('plugins.persistent_breakpoints'),
  require('plugins.hodur'),
  require('plugins.comment'),
  require('plugins.autopairs'),
  require('plugins.toggleterm'),
  require('plugins.session'),
  require('plugins.markdown_preview'),
  require('plugins.lspsaga'),
  require('plugins.blink_cmp'),
  require('plugins.mason'),
  require('plugins.debug'),
  require('plugins.indent_line'),
  require('plugins.neo-tree'),
  -- SOTA plugins added 2024:
  require('plugins.treesitter_textobjects'),
  require('plugins.treesitter_context'),
  require('plugins.treesitter_playground'),
  require('plugins.mini_surround'),
  require('plugins.fidget'),
  require('plugins.todo_comments'),
  require('plugins.hlargs'),
  require('plugins.incline'),
  require('plugins.ufo'),
  require('plugins.bqf'),
  require('plugins.spectre'),
  -- Core plugins from kickstart (already present):
  -- blink.cmp, nvim-treesitter, nvim-lspconfig, mason, telescope, gitsigns, autopairs, which-key, conform
  require('plugins.json_graph_view'),
  require('plugins.coach'),
  require('plugins.sort'),
  -- Language support and development
  require('plugins.neotest'),
  require('plugins.refactoring'),
  require('plugins.rustaceanvim'),
  require('plugins.lspconfig'),
  require('plugins.schemastore'),
  require('plugins.golang'),
  require('plugins.conform'),
  require('plugins.none_ls'),

  -- Data Science & DevOps
  require('plugins.jupynium'),
  require('plugins.kubernetes'),
}
