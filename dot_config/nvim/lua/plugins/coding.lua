return {
  {
    -- Completion. blink.cmp over nvim-cmp: it is a fraction of the config and
    -- its fuzzy matcher is in Rust, so it stays responsive in a big buffer.
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    opts = {
      keymap = { preset = "default" },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
      },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      fuzzy = { implementation = "prefer_rust_with_warning" },
      signature = { enabled = true },
    },
  },

  { "neovim/nvim-lspconfig" },   -- server DEFINITIONS only; vim.lsp.config drives them

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = { ui = { border = "rounded" } },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        go = { "goimports", "gofmt" },
        sh = { "shfmt" },
        fish = { "fish_indent" },
        yaml = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        ["_"] = { "trim_whitespace" },
      },
      -- Format on save, but never block for longer than half a second, and
      -- never on a file the LSP is not sure about.
      format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
    },
  },

  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
      { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Find TODOs" },
    },
  },
}
