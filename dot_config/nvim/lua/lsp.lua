-- LSP, using the built-in 0.11+ API.
--
-- vim.lsp.config("name", {...}) merges onto the defaults that nvim-lspconfig
-- ships as data, and vim.lsp.enable starts them. There is no setup() call and
-- no per-server require - that is the old pattern and it is gone.

vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  virtual_text = { spacing = 2, source = "if_many", prefix = "*" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

-- Keys are bound on attach, not globally, so gd in a buffer with no server
-- still does the built-in thing instead of erroring.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
  callback = function(ev)
    local map = function(keys, fn, desc)
      vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
    end
    map("grn", vim.lsp.buf.rename, "Rename")
    map("gra", vim.lsp.buf.code_action, "Code action")
    map("grr", vim.lsp.buf.references, "References")
    map("gri", vim.lsp.buf.implementation, "Implementation")
    map("grd", vim.lsp.buf.definition, "Definition")
    map("grt", vim.lsp.buf.type_definition, "Type definition")
    map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")

    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    -- Inlay hints are genuinely useful in Rust and Go and mostly noise in
    -- Python, so they start off and toggle.
    if client and client:supports_method("textDocument/inlayHint") then
      map("<leader>th", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
      end, "Toggle inlay hints")
    end
  end,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false },
      -- Without this every `vim.` in this config is an undefined-global warning.
      diagnostics = { globals = { "vim" } },
      telemetry = { enable = false },
      hint = { enable = true },
    },
  },
})

vim.lsp.config("bashls", { filetypes = { "sh", "bash" } })

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      keyOrdering = false,   -- alphabetical key order is not a real error
      schemaStore = { enable = true },
    },
  },
})

-- Servers that need no tuning beyond the packaged defaults.
vim.lsp.enable({
  "lua_ls", "bashls", "yamlls", "pyright", "ruff",
  "rust_analyzer", "gopls", "ts_ls", "jsonls", "taplo", "dockerls", "marksman",
})
