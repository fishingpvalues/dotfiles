-- LuaSnip configuration for snippets
return {
  "L3MON4D3/LuaSnip",
  lazy = true,
  -- build = "make install_jsregexp", -- Disabled build step to avoid compilation
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local ls = require("luasnip")
    local types = require("luasnip.util.types")

    ls.config.set_config({
      -- Enable autotriggered snippets
      enable_autosnippets = true,
      -- Use treesitter for getting the current scope/environment
      use_treesitter = true,
      -- Setup nice visual appearance
      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { "●", "DiagnosticInfo" } },
          },
        },
        [types.insertNode] = {
          active = {
            virt_text = { { "●", "DiagnosticHint" } },
          },
        },
      },
      -- Make history persist across sessions
      history = true,
      -- Update dynamic snippets as you type
      updateevents = "TextChanged,TextChangedI",
      -- Delete snippet when text changes
      delete_check_events = "TextChanged,InsertLeave",
    })

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Create snippet paths
    local snippet_path = vim.fn.stdpath("config") .. "/snippets"
    vim.fn.mkdir(snippet_path, "p")

    -- Also load snippets from the snippets folder
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { snippet_path } })
    
    -- Keymap for jumping to previous/next snippet position
    -- (Removed: now in keymaps.lua)
    
    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      end
    end, { silent = true, desc = "LuaSnip jump back" })
    
    vim.keymap.set({ "i", "s" }, "<C-l>", function()
      if ls.choice_active() then
        ls.change_choice(1)
      end
    end, { silent = true, desc = "LuaSnip next choice" })
  end,
}