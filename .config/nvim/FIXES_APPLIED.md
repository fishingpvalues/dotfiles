# Neovim Configuration Fixes Applied

## Date: 2025-10-11

### Issues Fixed

#### 1. ✅ nvim-notify Background Color Warning
**Issue**: `Highlight group 'NotifyBackground' has no background highlight`

**Fix**: Created `/home/daniel/.config/nvim/lua/plugins/nvim_notify.lua` with:
```lua
return {
  "rcarriga/nvim-notify",
  opts = {
    background_colour = "#000000",
  },
}
```

#### 2. ✅ Deprecated lspconfig Framework Warning
**Issue**: `The require('lspconfig') "framework" is deprecated, use vim.lsp.config`

**Fix**: Migrated `/home/daniel/.config/nvim/lua/plugins/lspconfig.lua` to use Neovim 0.11+ native APIs:
- Replaced `require('lspconfig')[server].setup()` with `vim.lsp.config()` and `vim.lsp.enable()`
- Restructured server configurations from key-value table to array format
- All existing settings (capabilities, on_attach, server configs) preserved

#### 3. ✅ which-key.nvim Invalid Key Position Error
**Issue**: `invalid key: position` error in which-key configuration

**Fix**: Updated `/home/daniel/.config/nvim/lua/plugins/which_key_fix.lua`:
- Removed `position` field from `win` configuration (deprecated in newer which-key)
- Removed `layout` configuration (incompatible with current which-key version)
- Kept `border` and `padding` options which are supported

#### 4. ✅ vim.notify Overwrite Conflict
**Issue**: `vim.notify has been overwritten by another plugin` warning from Noice

**Fix**: Removed vim.notify override from `/home/daniel/.config/nvim/lua/plugins/none_ls.lua`:
- Deleted the custom vim.notify wrapper that was filtering messages
- Let nvim-notify and noice handle notifications natively

#### 5. ✅ Failed LSP Installations (r_language_server, solargraph)
**Issue**: Installation failures due to missing R and Ruby dependencies

**Fix**:
- Removed `r_language_server` from mason.lua (requires R to be installed)
- Removed `solargraph` from mason.lua (requires Ruby to be installed)
- Removed corresponding configurations from lspconfig.lua
- Removed R formatter from conform.lua

**Note**: To use these LSPs in the future:
- For R: Install R (`pacman -S r`), then install languageserver package in R: `install.packages("languageserver")`
- For Ruby: Install Ruby (`pacman -S ruby`), then install solargraph: `gem install solargraph`

### Enhancements Added

#### Additional LSPs
- **emmet_language_server**: HTML/CSS abbreviation expansion for faster web development

#### Additional Tools in Mason
- **cbfmt**: Format code blocks in markdown files
- **luacheck**: Lua linter for better Lua code quality

### Your Current Stack

Based on your configuration, your development environment supports:

**Systems Programming:**
- Go (gopls + gofumpt, goimports, golangci-lint, staticcheck, delve debugger)
- Rust (rust_analyzer via rustaceanvim)
- C/C++ (clangd)
- Zig (zls)

**Python (Data Science):**
- LSPs: pyright, pylsp, ruff
- Formatters: black, isort, ruff_format
- Linters: mypy, bandit, pylint
- Tools: autopep8, jupyter-lsp

**Web Development:**
- TypeScript/JavaScript (ts_ls, eslint_d, prettier)
- HTML/CSS (html, cssls, emmet_language_server)
- Frameworks: Tailwind CSS, Svelte, Vue

**JVM Languages:**
- Java (jdtls)
- Kotlin (kotlin_language_server)

**DevOps & Infrastructure:**
- Docker (dockerls, docker_compose_language_service, hadolint)
- Kubernetes (helm_ls)
- Terraform (terraformls, tflint)
- Ansible (ansiblels, ansible-lint)
- YAML (yamlls, yamllint, yamlfmt)

**Data Formats:**
- JSON (jsonls, jsonlint)
- YAML (yamlls, yamllint)
- TOML (taplo)
- XML (lemminx)
- SQL (sqls, sqlfluff)
- Protocol Buffers (buf_ls, protolint)
- GraphQL (graphql)

**Scripting:**
- Bash (bashls, shellcheck, shfmt)
- Lua (lua_ls, stylua, luacheck)

**Documentation:**
- Markdown (marksman, markdownlint, prettier, cbfmt)

### Next Steps

1. Restart Neovim to apply all changes
2. Run `:Mason` to verify all LSPs, formatters, and linters install successfully
3. Run `:checkhealth` to verify everything is working correctly
4. Test LSP functionality with `:LspInfo` in a code file

### Optional: Install R and Ruby Support

If you need R or Ruby support later:

```bash
# Install R
sudo pacman -S r
R -e 'install.packages("languageserver")'

# Install Ruby
sudo pacman -S ruby
gem install solargraph

# Then add them back to mason.lua ensure_installed list
```
