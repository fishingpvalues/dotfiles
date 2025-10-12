-- Native LSP configuration using vim.lsp.config (Neovim 0.11+)
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {},
  config = function()

    -- Get capabilities from blink.cmp if available
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok, blink = pcall(require, 'blink.cmp')
    if ok then
      capabilities = blink.get_lsp_capabilities(capabilities)
    end
    capabilities.textDocument.completion.completionItem.snippetSupport = true

    -- Global LSP settings
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      -- LSP Keymaps
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

      -- Golang specific keymaps
      if client.name == 'gopls' then
        vim.keymap.set('n', '<leader>gt', function()
          vim.cmd('!go test ./...')
        end, { desc = 'Run Go tests' })

        vim.keymap.set('n', '<leader>gT', function()
          vim.cmd('!go test ' .. vim.fn.expand('%:p:h'))
        end, { desc = 'Run Go test file' })

        vim.keymap.set('n', '<leader>gc', function()
          vim.cmd('!go test -cover ./...')
        end, { desc = 'Go test coverage' })

        vim.keymap.set('n', '<leader>gb', function()
          vim.cmd('!go build')
        end, { desc = 'Go build' })

        vim.keymap.set('n', '<leader>gr', function()
          vim.cmd('!go run ' .. vim.fn.expand('%'))
        end, { desc = 'Go run current file' })

        vim.keymap.set('n', '<leader>gi', function()
          vim.cmd('!go get -u ./...')
        end, { desc = 'Go install dependencies' })

        vim.keymap.set('n', '<leader>gm', function()
          vim.cmd('!go mod tidy')
        end, { desc = 'Go mod tidy' })

        vim.keymap.set('n', '<leader>gf', function()
          vim.lsp.buf.format({ async = true })
        end, { desc = 'Format Go file' })

        vim.keymap.set('n', '<leader>gl', function()
          vim.cmd('!golangci-lint run')
        end, { desc = 'Run golangci-lint' })

        vim.keymap.set('n', '<leader>gv', function()
          vim.cmd('!go vet ./...')
        end, { desc = 'Go vet' })
      end

      -- Format on save for supported languages
      if client.supports_method('textDocument/formatting') then
        vim.api.nvim_create_autocmd('BufWritePre', {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({
              filter = function(format_client)
                return format_client.name == client.name
              end,
            })
          end,
        })
      end
    end

    -- Configure diagnostic display
    vim.diagnostic.config({
      virtual_text = {
        prefix = '●',
        source = 'if_many',
      },
      float = {
        source = 'always',
        border = 'rounded',
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
    })

    -- Diagnostic signs
    local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- LSP Server configurations using new vim.lsp.config API
    -- NOTE: Rust LSP (rust_analyzer) is handled by rustaceanvim plugin
    local servers = {
      -- C/C++ LSP
      { 'clangd', {
        cmd = {
          'clangd',
          '--background-index',
          '--clang-tidy',
          '--header-insertion=iwyu',
          '--completion-style=detailed',
          '--function-arg-placeholders',
          '--fallback-style=llvm',
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }},

      -- Zig LSP
      { 'zls' },

      -- Java LSP
      { 'jdtls' },

      -- Kotlin LSP
      { 'kotlin_language_server' },

      -- Tailwind CSS
      { 'tailwindcss' },

      -- Svelte
      { 'svelte' },

      -- Vue
      { 'vuels' },

      -- Go LSP with comprehensive configuration
      { 'gopls', {
        settings = {
          gopls = {
            gofumpt = true,
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            analyses = {
              -- fieldalignment removed in gopls v0.17.0
              nilness = true,
              unusedparams = true,
              unusedwrite = true,
              useany = true,
            },
            buildFlags = { "-tags", "integration" },
          },
        },
      }},

      -- Lua LSP for Neovim config
      { 'lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = 'LuaJIT',
            },
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }},

      -- TypeScript/JavaScript
      { 'ts_ls', {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }},

      -- Python (primary)
      { 'pyright', {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = 'strict',
              autoImportCompletions = true,
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      }},

      -- Python (alternative with more features)
      { 'pylsp', {
        settings = {
          pylsp = {
            plugins = {
              pycodestyle = { enabled = false },
              mccabe = { enabled = false },
              pyflakes = { enabled = false },
              flake8 = { enabled = false },
              pylint = { enabled = false },
              ruff = { enabled = true },
              black = { enabled = true },
              isort = { enabled = true },
            },
          },
        },
      }},

      -- Ruff LSP (fast Python linter/formatter)
      { 'ruff', {
        init_options = {
          settings = {
            args = { "--line-length=88" },
          },
        },
      }},

      -- JSON
      { 'jsonls', {
        settings = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
      }},

      -- YAML
      { 'yamlls', {
        settings = {
          yaml = {
            schemaStore = {
              enable = false,
              url = "",
            },
            schemas = require('schemastore').yaml.schemas(),
          },
        },
      }},

      -- DevOps & Infrastructure
      { 'dockerls' },
      { 'docker_compose_language_service' },
      { 'terraformls' },
      { 'helm_ls' },
      { 'ansiblels' },

      -- Protocols & Data Formats
      { 'buf_ls' },  -- Protocol Buffers
      { 'graphql' },
      { 'taplo' },  -- TOML

      -- HTML
      { 'html', {
        filetypes = { 'html', 'templ' },
      }},

      -- Emmet for HTML/CSS
      { 'emmet_language_server', {
        filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
      }},

      -- CSS
      { 'cssls' },

      -- Shell
      { 'bashls' },

      -- Documentation & Config
      { 'marksman' },
      { 'lemminx' },  -- XML

      -- Database
      { 'sqlls' },
    }

    -- Setup each server using new vim.lsp.config API
    for _, lsp in ipairs(servers) do
      local name, config = lsp[1], lsp[2]

      -- Set default configuration with capabilities and on_attach
      local server_config = vim.tbl_deep_extend('force', {
        capabilities = capabilities,
        on_attach = on_attach,
      }, config or {})

      -- Configure and enable the LSP server
      vim.lsp.config(name, server_config)
      vim.lsp.enable(name)
    end
  end,
}