-- none-ls.nvim: SOTA replacement for null-ls (diagnostics, code actions)
return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'mason.nvim' },
  opts = function()
    local nls = require('null-ls')
    return {
      root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
      sources = {
        -- Go
        nls.builtins.diagnostics.golangci_lint,
        nls.builtins.diagnostics.staticcheck,
        nls.builtins.code_actions.gomodifytags,
        nls.builtins.code_actions.impl,

        -- Python (data science)
        -- nls.builtins.diagnostics.ruff, -- not available in none-ls
        -- nls.builtins.diagnostics.mypy,
        -- nls.builtins.diagnostics.bandit, -- not available in none-ls
        -- nls.builtins.code_actions.ruff, -- not available in none-ls

        -- JavaScript/TypeScript
        -- nls.builtins.diagnostics.eslint_d, -- not available in none-ls
        -- nls.builtins.code_actions.eslint_d, -- not available in none-ls

        -- Shell
        -- nls.builtins.diagnostics.shellcheck, -- not available in none-ls

        -- Docker
        nls.builtins.diagnostics.hadolint,

        -- YAML
        nls.builtins.diagnostics.yamllint,

        -- Ansible
        -- nls.builtins.diagnostics.ansible_lint, -- not available in none-ls

        -- Terraform
        -- nls.builtins.diagnostics.tflint, -- not available in none-ls

        -- Protocol Buffers
        nls.builtins.diagnostics.protolint,

        -- SQL
        nls.builtins.diagnostics.sqlfluff.with({
          extra_args = { '--dialect', 'postgres' },
        }),

        -- Markdown
        nls.builtins.diagnostics.markdownlint,

        -- General
        nls.builtins.diagnostics.trail_space,
        nls.builtins.code_actions.gitsigns,
      },
    }
  end,
}