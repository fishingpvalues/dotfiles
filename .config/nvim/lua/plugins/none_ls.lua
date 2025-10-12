-- none-ls.nvim: SOTA replacement for null-ls (diagnostics, code actions)
return {
  'nvimtools/none-ls.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'mason.nvim' },
  config = function()
    local nls = require('null-ls')

    nls.setup({
      -- Disable all update messages
      update_in_insert = false,
      debug = false,
      -- Suppress error notifications
      on_init = function(client, _)
        client.notify = function() end
      end,
      on_attach = function(client, bufnr)
        -- Disable document formatting to avoid conflicts
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        -- Disable code actions that cause spam
        client.server_capabilities.codeActionProvider = false
      end,
      root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', 'Makefile', '.git'),
      sources = {
        -- Go (conditional - only if tools are available)
        nls.builtins.diagnostics.golangci_lint.with({
          condition = function(utils)
            return utils.root_has_file("go.mod")
          end,
        }),
        nls.builtins.diagnostics.staticcheck.with({
          condition = function(utils)
            return utils.root_has_file("go.mod")
          end,
        }),

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

        -- Docker (conditional)
        nls.builtins.diagnostics.hadolint.with({
          condition = function(utils)
            return utils.root_has_file("Dockerfile")
          end,
        }),

        -- YAML (conditional)
        nls.builtins.diagnostics.yamllint.with({
          condition = function(utils)
            return utils.root_has_file(".yamllint") or utils.root_has_file(".yamllint.yaml")
          end,
        }),

        -- Protocol Buffers (conditional)
        nls.builtins.diagnostics.protolint.with({
          condition = function(utils)
            return utils.root_has_file(".protolint.yaml")
          end,
        }),

        -- SQL (conditional)
        nls.builtins.diagnostics.sqlfluff.with({
          extra_args = { '--dialect', 'postgres' },
          condition = function(utils)
            return utils.root_has_file(".sqlfluff")
          end,
        }),

        -- Markdown (conditional)
        nls.builtins.diagnostics.markdownlint.with({
          condition = function(utils)
            return utils.root_has_file(".markdownlint.json") or utils.root_has_file(".markdownlintrc")
          end,
        }),

        -- General (always enabled, lightweight)
        nls.builtins.diagnostics.trail_space,
      },
    })
  end,
}