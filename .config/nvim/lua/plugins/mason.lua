-- mason.nvim: SOTA LSP/DAP/linter/formatter manager with UI
return {
  "williamboman/mason.nvim",
  priority = 1000,
  lazy = false,
  build = ":MasonUpdate", -- Optional: updates registry on install
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    -- Setup mason-lspconfig after mason is ready
    require("mason-lspconfig").setup({
      automatic_installation = true,
      ensure_installed = {
        -- Systems Programming
        "gopls",             -- Go
        "rust_analyzer",     -- Rust (managed by rustaceanvim, but installed via mason)
        "clangd",            -- C/C++
        "zls",               -- Zig

        -- Python (data science stack)
        "pyright", "pylsp", "ruff",

        -- JVM Languages
        "jdtls",             -- Java
        "kotlin_language_server", -- Kotlin

        -- Web Development
        "ts_ls",             -- TypeScript/JavaScript (formerly tsserver)
        "html", "cssls", "jsonls", "eslint",
        "tailwindcss",       -- Tailwind CSS
        "svelte",            -- Svelte
        "vuels",             -- Vue

        -- Scripting & Dynamic Languages
        "bashls",            -- Bash
        "solargraph",        -- Ruby (stable LSP server)
        "elixirls",          -- Elixir

        -- Data & Config
        "r_language_server", -- R for data analysis
        "taplo",             -- TOML
        "lemminx",           -- XML
        "sqls",              -- SQL

        -- DevOps & Infrastructure
        "dockerls", "docker_compose_language_service",
        "yamlls", "helm_ls", "terraformls", "ansiblels",

        -- Protocols & APIs
        "buf_ls",            -- Protocol Buffers (correct name is buf_ls, not buf-language-server)
        "graphql",

        -- Documentation
        "lua_ls",            -- Lua for Neovim config
        "marksman",          -- Markdown
      }
    })
  end,
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      config = function()
        require("mason-tool-installer").setup({
          ensure_installed = {
            -- Go tools (SOTA)
            "gofumpt",       -- Stricter Go formatter
            "goimports",     -- Import management
            "golines",       -- Long line formatter
            "gotests",       -- Test generation
            "impl",          -- Interface implementation generator
            "dlv",           -- Delve debugger
            "staticcheck",   -- Advanced static analysis
            "golangci-lint", -- Comprehensive linter
            "gotestsum",     -- Enhanced test runner
            "govulncheck",   -- Vulnerability checker
            "gomodifytags",  -- Struct tag modifier
            "iferr",         -- Error handling generator

            -- Python tools (Data Science)
            "black",         -- Python formatter
            "isort",         -- Python import sorting
            "ruff",          -- Fast Python linter/formatter
            "mypy",          -- Python type checker
            "bandit",        -- Python security linter
            "pylint",        -- Python linter
            "autopep8",      -- Python formatter

            -- Data Science specific
            "jupyter-lsp",   -- Jupyter notebook support

            -- DevOps & Infrastructure formatters/linters
            "prettier",      -- JS/TS/JSON/YAML/Markdown
            "stylua",        -- Lua
            "shfmt",         -- Shell
            "yamlfmt",       -- YAML formatter
            "terraform-ls",  -- Terraform language server
            "tflint",        -- Terraform linter
            "ansible-lint",  -- Ansible linter

            -- Protocol & Data formats
            "buf",           -- Protocol Buffers
            "protolint",     -- Protocol Buffers linter

            -- General linters
            "eslint_d",      -- JS/TS
            "shellcheck",    -- Shell
            "hadolint",      -- Dockerfile
            "yamllint",      -- YAML
            "jsonlint",      -- JSON
            "markdownlint",  -- Markdown
            "sqlfluff",      -- SQL formatter/linter

            -- DAP adapters
            "delve",         -- Go debugger
            "debugpy",       -- Python debugger
            "node-debug2-adapter", -- Node.js debugger
          },
          auto_update = true,
          run_on_start = false,
        })
      end,
    },
  },
} 