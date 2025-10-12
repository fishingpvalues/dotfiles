-- conform.nvim: Modern formatter plugin (SOTA replacement for null-ls formatting)
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true })
      end,
      mode = { 'n', 'v' },
      desc = 'Format buffer',
    },
  },
  opts = {
    formatters_by_ft = {
      -- Go
      go = { 'gofumpt', 'goimports' },

      -- Python (data science)
      python = { 'ruff_format', 'black' },

      -- JavaScript/TypeScript
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },

      -- Web
      html = { 'prettier' },
      css = { 'prettier' },
      scss = { 'prettier' },
      json = { 'prettier' },
      jsonc = { 'prettier' },

      -- DevOps & Infrastructure
      yaml = { 'yamlfmt', 'prettier' },
      toml = { 'taplo' },
      terraform = { 'terraform_fmt' },
      hcl = { 'terraform_fmt' },

      -- Shell
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      zsh = { 'shfmt' },

      -- Documentation
      markdown = { 'prettier' },

      -- Config
      lua = { 'stylua' },

      -- Data formats
      sql = { 'sqlfluff' },
      proto = { 'buf' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    formatters = {
      -- Go formatters
      gofumpt = {
        prepend_args = { '-extra' },
      },

      -- Python formatters
      ruff_format = {
        args = { 'format', '--stdin-filename', '$FILENAME', '-' },
      },
      black = {
        prepend_args = { '--line-length', '88' },
      },

      -- Shell formatter
      shfmt = {
        prepend_args = { '-i', '2', '-ci' },
      },

      -- YAML formatter
      yamlfmt = {
        args = { '-in' },
      },

      -- SQL formatter
      sqlfluff = {
        args = { 'format', '--dialect=postgres', '-' },
      },

      -- Protocol Buffers
      buf = {
        args = { 'format', '$FILENAME' },
      },
    },
  },
}