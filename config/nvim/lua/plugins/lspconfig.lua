-- LSP Configuration
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    
    -- Add cmp-nvim-lsp as a dependency to fix errors
    'hrsh7th/cmp-nvim-lsp',

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

    -- Additional lua configuration, makes nvim stuff amazing!
    'folke/neodev.nvim',
  },
  config = function()
    -- Setup mason first to ensure it's properly initialized
    require('mason').setup({
      ui = {
        border = vim.g.transparent_enabled and "rounded" or "none",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })
    
    -- Setup neovim lua configuration
    require('neodev').setup()

    -- Try loading cmp_nvim_lsp with error handling
    local has_cmp_lsp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    
    if has_cmp_lsp then
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    else
      vim.notify('Warning: cmp_nvim_lsp not available', vim.log.levels.WARN)
    end

    -- Setup mason-lspconfig after mason is configured
    local mason_lspconfig = require('mason-lspconfig')
    mason_lspconfig.setup({
      ensure_installed = {
        'tsserver',
        'eslint',
        'lua_ls',
        'pyright',
      },
    })

    -- Function to set up common LSP keymaps and capabilities
    local on_attach = function(_, bufnr)
      local nmap = function(keys, func, desc)
        if desc then
          desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
      end

      nmap('<leader>rn', vim.lsp.buf.rename, 'Rename')
      nmap('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
      nmap('gd', vim.lsp.buf.definition, 'Goto Definition')
      nmap('gr', require('telescope.builtin').lsp_references, 'Goto References')
      nmap('gI', vim.lsp.buf.implementation, 'Goto Implementation')
      nmap('<leader>D', vim.lsp.buf.type_definition, 'Type Definition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
      nmap('gD', vim.lsp.buf.declaration, 'Goto Declaration')

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })
      
      nmap('<leader>lf', vim.lsp.buf.format, 'Format')
    end

    -- Ensure handlers are set up before configuring servers
    if vim.g.transparent_enabled then
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded",
        }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help, {
          border = "rounded",
        }
      )
      
      -- Diagnostic configuration
      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
      })
    end

    -- Set up servers after everything else is configured
    mason_lspconfig.setup_handlers({
      function(server_name)
        require('lspconfig')[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = {
            -- Configure server-specific settings
            Lua = {
              diagnostics = {
                globals = { 'vim' }
              },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
            -- Add other server-specific settings here
          },
        })
      end,
    })
  end,
}