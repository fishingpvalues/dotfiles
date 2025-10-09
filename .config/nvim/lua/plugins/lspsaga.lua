-- lspsaga.nvim: Enhanced LSP UI for Neovim
return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- for better UI
    "nvim-tree/nvim-web-devicons",     -- for icons
  },
  opts = {
    ui = {
      border = "rounded",
      code_action = "",
      colors = {
        normal_bg = "#1a1b26",
        title_bg = "#16161e",
      },
    },
    finder = {
      max_height = 0.6,
      default = "def+ref+imp",
      keys = {
        shuttle = "[w",
        toggle_or_open = "o",
        vsplit = "v",
        split = "i",
        tabe = "t",
        tabnew = "r",
        quit = "q",
        close = "<C-c>k",
      },
    },
    lightbulb = {
      enable = true,
      sign = true,
      virtual_text = false,
    },
    outline = {
      win_position = "right",
      win_width = 32,
      auto_preview = true,
      auto_close = true,
    },
    symbol_in_winbar = {
      enable = true,
      separator = "  ",
      show_file = true,
      hide_keyword = true,
      folder_level = 2,
    },
    diagnostic = {
      show_code_action = true,
      show_source = true,
      jump_num_shortcut = true,
      max_width = 0.7,
      max_height = 0.6,
      keys = {
        exec_action = "o",
        quit = "q",
        go_action = "g",
      },
    },
    rename = {
      in_select = false,
      auto_save = true,
      keys = {
        quit = "<Esc>",
        exec = "<CR>",
      },
    },
    hover = {
      max_width = 0.7,
      max_height = 0.6,
      open_link = "gx",
      open_browser = "!chrome",
    },
  },
  config = function(_, opts)
    require("lspsaga").setup(opts)
    -- Keymaps for quick access to SAGA features
    local map = vim.keymap.set
    map("n", "<leader>ca", ":Lspsaga code_action<CR>", { desc = "LSP Code Action" })
    map("n", "<leader>rn", ":Lspsaga rename<CR>", { desc = "LSP Rename" })
    map("n", "<leader>o", ":Lspsaga outline<CR>", { desc = "LSP Outline" })
    map("n", "<leader>fd", ":Lspsaga finder<CR>", { desc = "LSP Finder" })
    map("n", "<leader>sd", ":Lspsaga show_line_diagnostics<CR>", { desc = "Show Line Diagnostics" })
    map("n", "K", ":Lspsaga hover_doc<CR>", { desc = "LSP Hover Doc" })
  end,
} 