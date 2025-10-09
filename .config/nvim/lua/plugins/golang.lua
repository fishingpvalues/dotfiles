-- Comprehensive Golang development setup
return {
  {
    -- Go.nvim: Advanced Go development features
    'ray-x/go.nvim',
    dependencies = {
      'ray-x/guihua.lua',
      'neovim/nvim-lspconfig',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('go').setup({
        goimport = 'gopls', -- goimport command
        gofmt = 'gofumpt', -- stricter formatting
        max_line_len = 120,
        tag_transform = false,
        test_dir = '',
        comment_placeholder = '   ',
        lsp_cfg = false, -- we handle LSP in lspconfig.lua
        lsp_gofumpt = true,
        lsp_on_attach = false, -- we handle this in lspconfig.lua
        dap_debug = true,
        dap_debug_gui = true,
        dap_debug_keymap = false, -- we set our own keymaps
        textobjects = true,
        test_runner = 'go', -- or 'gotestsum', 'ginkgo', 'richgo'
        verbose_tests = true,
        run_in_floaterm = false,
        trouble = true,
        test_efm = false,
        luasnip = true,
      })

      -- Auto commands for Go files
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require('go.format').goimport()
        end,
        group = format_sync_grp,
      })
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },

  {
    -- Go test coverage visualization
    'andythigpen/nvim-coverage',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('coverage').setup({
        commands = true, -- create commands
        highlights = {
          covered = { fg = '#C3E88D' },   -- green
          uncovered = { fg = '#F07178' }, -- red
        },
        signs = {
          covered = { hl = 'CoverageCovered', text = '▎' },
          uncovered = { hl = 'CoverageUncovered', text = '▎' },
        },
        summary = {
          min_coverage = 80.0,
        },
        lang = {
          go = {
            coverage_file = '/tmp/coverage.out',
            coverage_command = 'go test -v -coverprofile=/tmp/coverage.out ./...',
          },
        },
      })

      -- Keymaps for coverage
      vim.keymap.set('n', '<leader>gcv', function()
        require('coverage').load(true)
      end, { desc = 'Load and show coverage' })

      vim.keymap.set('n', '<leader>gch', function()
        require('coverage').hide()
      end, { desc = 'Hide coverage' })

      vim.keymap.set('n', '<leader>gcs', function()
        require('coverage').summary()
      end, { desc = 'Coverage summary' })
    end,
    ft = 'go',
  },

  {
    -- Improved Go struct tags
    'fatih/vim-go',
    ft = 'go',
    config = function()
      -- Disable most vim-go features since we use go.nvim
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_textobj_enabled = 0
      vim.g.go_list_type = "quickfix"

      -- Only enable specific features we want
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_generate_tags = 1
    end,
  },

  {
    -- Enhanced Go debugging with DAP
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = {
      'mfussenegger/nvim-dap',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      require('dap-go').setup({
        dap_configurations = {
          {
            type = "go",
            name = "Attach remote",
            mode = "remote",
            request = "attach",
          },
        },
        delve = {
          path = "dlv",
          initialize_timeout_sec = 20,
          port = "${port}",
          args = {},
          build_flags = "",
          detached = vim.fn.has("win32") == 0,
        },
      })

      -- Debug keymaps for Go
      vim.keymap.set('n', '<leader>gdt', function()
        require('dap-go').debug_test()
      end, { desc = 'Debug Go test' })

      vim.keymap.set('n', '<leader>gdl', function()
        require('dap-go').debug_last_test()
      end, { desc = 'Debug last Go test' })
    end,
  },

  {
    -- Gopher: Go tooling integration
    'olexsmir/gopher.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('gopher').setup({
        commands = {
          go = "go",
          gomodifytags = "gomodifytags",
          gotests = "gotests",
          impl = "impl",
          iferr = "iferr",
        },
      })
    end,
    ft = 'go',
    build = function()
      vim.cmd [[silent! GoInstallDeps]]
    end,
  },
}