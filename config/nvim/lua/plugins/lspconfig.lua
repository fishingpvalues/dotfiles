-- LSP Configuration
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Automatically install LSPs to stdpath for neovim
    'mason-org/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    
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

    -- Setup mason-lspconfig after mason is configured
    local mason_lspconfig = require('mason-lspconfig')
    mason_lspconfig.setup({
      ensure_installed = {
        'tsserver',    -- TypeScript/JavaScript
        'eslint',      -- JavaScript/TypeScript linting
        'lua_ls',      -- Lua
        'pyright',     -- Python
        'bashls',      -- Bash
        'jsonls',      -- JSON
        'html',        -- HTML
        'cssls',       -- CSS
        'yamlls',      -- YAML
        'marksman',    -- Markdown
        'rust_analyzer', -- Rust
        'intelephense',   -- PHP
        'phpactor',       -- PHP alternative
        'twiggy_language_server', -- Twig (if available)
        'sqlls',          -- SQL
        'dockerls',       -- Docker
        'ansiblels',      -- Ansible
        'clangd',         -- C/C++
        'tailwindcss',    -- Tailwind CSS
        'yaml-language-server', -- YAML
        ''

        -- Add more servers as needed
      },
    })

    -- Function to set up common LSP keymaps and capabilities
    local on_attach = function(_, bufnr)
      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })

      -- SOTA LSP keymaps (buffer-local)
      local opts = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'Goto Definition' }))
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'Goto Declaration' }))
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'Goto Implementation' }))
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'Goto References' }))
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'Hover Documentation' }))
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'Signature Help' }))
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'Rename Symbol' }))
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'Code Action' }))
      vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, vim.tbl_extend('force', opts, { desc = 'Format Buffer' }))
      vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Add Workspace Folder' }))
      vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, vim.tbl_extend('force', opts, { desc = 'Remove Workspace Folder' }))
      vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, vim.tbl_extend('force', opts, { desc = 'List Workspace Folders' }))
    end

    -- Set up servers after everything else is configured
    for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
      require('lspconfig')[server_name].setup({
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }
            },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })
    end
  end,
}