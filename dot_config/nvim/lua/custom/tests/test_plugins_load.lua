local plugin_modules = {
  -- custom/plugins
  "custom.plugins.which-key-fix",
  "custom.plugins.pickme",
  "custom.plugins.luasnip",
  "custom.plugins.lualine",
  "custom.plugins.yazi",
  "custom.plugins.web-devicons",
  "custom.plugins.trouble",
  "custom.plugins.rainbow-csv",
  "custom.plugins.persistent-breakpoints",
  "custom.plugins.neoscroll",
  "custom.plugins.navic",
  "custom.plugins.leap",
  "custom.plugins.lspkind-config",
  "custom.plugins.indent-blankline",
  "custom.plugins.illuminate",
  "custom.plugins.diffview",
  "custom.plugins.dap-virtual-text",
  "custom.plugins.dap-ui",
  -- plugins
  "plugins.gitsigns",
  "plugins.autopairs",
  "plugins.lspconfig",
  "plugins.todo-comments",
  "plugins.treesitter",
  "plugins.telescope",
  "plugins.mini",
  "plugins.mini_icons",
  "plugins.dap-python",
  "plugins.conform",
}

describe("plugin loading", function()
  for _, mod in ipairs(plugin_modules) do
    it("loads " .. mod, function()
      assert.has_no.errors(function() require(mod) end)
    end)
  end
end) 