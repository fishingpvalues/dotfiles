-- Neovim, from scratch. Targets 0.11+: LSP servers are configured with
-- vim.lsp.config / vim.lsp.enable, not lspconfig's setup(), because that API is
-- now built in and nvim-lspconfig is only a bag of default server definitions.
--
-- Layout:
--   lua/options.lua    editor settings
--   lua/keymaps.lua    keys that do not belong to a plugin
--   lua/lsp.lua        server definitions + on-attach keys
--   lua/plugins/*.lua  one file per concern, imported by lazy
require("options")
require("keymaps")

-- lazy.nvim, bootstrapped on first start.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { "lazy.nvim clone failed:\n", "ErrorMsg" }, { out, "WarningMsg" } }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  -- No plugin here needs luarocks, and lazy's own health check says so. Left
  -- on, it reports a hard ERROR for a hererocks install that will never exist.
  rocks = { enabled = false },
  performance = {
    rtp = {
      -- Startup time is mostly spent sourcing these. None is wanted.
      disabled_plugins = {
        "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin",
      },
    },
  },
})

require("lsp")
