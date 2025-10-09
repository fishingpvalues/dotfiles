-- LuaSnip configuration for snippets
return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    local ls = require("luasnip")
    local types = require("luasnip.util.types")
    ls.config.set_config({
      enable_autosnippets = true,
      use_treesitter = true,
      ext_opts = {
        [types.choiceNode] = { active = { virt_text = { { "●", "DiagnosticInfo" } } } },
        [types.insertNode] = { active = { virt_text = { { "●", "DiagnosticHint" } } } },
      },
      history = true,
      updateevents = "TextChanged,TextChangedI",
      delete_check_events = "TextChanged,InsertLeave",
    })
    require("luasnip.loaders.from_vscode").lazy_load()
    local snippet_path = vim.fn.stdpath("config") .. "/snippets"
    vim.fn.mkdir(snippet_path, "p")
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if ls.jumpable(-1) then ls.jump(-1) end
    end, { silent = true, desc = "LuaSnip jump back" })
    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      if ls.choice_active() then ls.change_choice(1) end
    end, { silent = true, desc = "LuaSnip next choice" })
  end,
} 