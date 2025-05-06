-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Transparency and blur support
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
    priority = 150,
    config = function()
      -- Set global transparency flag for plugins to reference
      vim.g.transparent_enabled = true
      
      require("transparent").setup({
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
          'EndOfBuffer',
        },
        extra_groups = {
          -- For floating windows and panels
          "NormalFloat", "FloatBorder", "TelescopeNormal", "TelescopeBorder",
          "LspInfoBorder", "WhichKeyFloat", "DashboardHeader", "DashboardCenter",
          "NeoTreeNormal", "NeoTreeNormalNC",
          
          -- For Bufferline and Lualine
          "BufferLineTabClose", "BufferLineBuffer", "BufferLineBufferSelected",
          "BufferLineBackground", "BufferLineFill",
          
          -- For diagnostic related highlights
          "DiagnosticVirtualTextError", "DiagnosticVirtualTextWarn",
          "DiagnosticVirtualTextInfo", "DiagnosticVirtualTextHint",
          
          -- For all other UI elements
          "MsgArea", "FloatShadow", "FloatShadowThrough",
          
          -- Notification transparency
          "NotifyBackground", "NotifyERRORBody", "NotifyWARNBody", 
          "NotifyINFOBody", "NotifyDEBUGBody", "NotifyTRACEBody",
          
          -- LSP and completion floating windows
          "LspFloatWinNormal", "LspFloatWinBorder", 
          "CmpDocumentationNormal", "CmpDocumentationBorder",
          "CmpCompletion", "CmpCompletionBorder",

          -- Yazi file manager integration
          "YaziFloat", "YaziFloatBorder", "YaziNormal",
          
          -- Lazy.nvim UI
          "LazyNormal", "LazyButton", "LazyButtonActive", "LazyH1", 
          "LazySpecial", "LazyProp", "LazyValue", "LazyDir",
          
          -- Mason UI
          "MasonNormal", "MasonHeader", "MasonHighlight",
          
          -- Trouble UI
          "TroubleNormal", "TroubleIndent", "TroubleCount",
          
          -- Popup menus
          "Pmenu", "PmenuSel", "PmenuSbar", "PmenuThumb",
        },
        exclude_groups = {}, -- table: groups you don't want to clear
        on_clear = function() 
          -- Use defer_fn for better startup performance
          vim.defer_fn(function()
            -- Clear plugin prefixes for dynamically created highlights
            require('transparent').clear_prefix('BufferLine')
            require('transparent').clear_prefix('NeoTree')
            require('transparent').clear_prefix('lualine')
            require('transparent').clear_prefix('Telescope')
            require('transparent').clear_prefix('WhichKey')
            require('transparent').clear_prefix('Navic')
            require('transparent').clear_prefix('Dashboard')
            require('transparent').clear_prefix('Lazy')
            require('transparent').clear_prefix('Mason')
            require('transparent').clear_prefix('Notify')
            require('transparent').clear_prefix('Cmp')
            require('transparent').clear_prefix('Trouble')
            require('transparent').clear_prefix('Diagnostic')
            require('transparent').clear_prefix('Diff')
            require('transparent').clear_prefix('Git')
            
            -- Add lualine specific transparent groups
            vim.g.transparent_groups = vim.list_extend(
              vim.g.transparent_groups or {},
              vim.tbl_map(function(v) return "lualine_" .. v .. "_normal" end, {"a", "b", "c"})
            )
            
            -- Create an autocommand to handle new highlight groups created after initialization
            vim.api.nvim_create_autocmd("ColorScheme", {
              callback = function()
                vim.defer_fn(function()
                  -- Re-apply transparency to common plugin prefixes
                  require('transparent').clear_prefix('BufferLine')
                  require('transparent').clear_prefix('NeoTree')
                  require('transparent').clear_prefix('lualine')
                  require('transparent').clear_prefix('Telescope')
                end, 10)
              end,
              group = vim.api.nvim_create_augroup("TransparencyFix", { clear = true }),
            })
          end, 10) -- Short delay to avoid blocking startup
        end,
      })
      
      -- Create a command to fix transparency issues at runtime
      vim.api.nvim_create_user_command('FixTransparency', function()
        vim.cmd('TransparentEnable')
        require('transparent').clear_prefix('BufferLine')
        require('transparent').clear_prefix('NeoTree')
        require('transparent').clear_prefix('lualine')
        require('transparent').clear_prefix('Telescope')
        require('transparent').clear_prefix('WhichKey')
        require('transparent').clear_prefix('Navic')
        require('transparent').clear_prefix('Dashboard')
      end, { desc = 'Fix transparency issues' })
      
      -- Enable transparency on startup
      if vim.g.transparent_enabled then
        vim.cmd("TransparentEnable")
      end
    end,
  },

  -- Import modules from plugins directory
  require 'plugins/gitsigns',
  require 'custom/plugins/which-key-fix',
  require 'plugins/telescope',
  require 'plugins/lspconfig',
  require 'plugins/conform',
  -- require 'plugins/cmp',  -- nvim-cmp removed in favor of blink.cmp
  require 'custom/plugins/lspkind-config',
  
  -- Theme configuration with transparency support
  {
    'projekt0n/github-nvim-theme',
    version = "v0.0.7", -- Pin to a known stable version
    priority = 1000, -- load first to avoid colorscheme flickering
    lazy = false,
    config = function()
      -- Use simplest config possible to avoid highlight.lua issues
      pcall(vim.cmd, "colorscheme github_dark")
    end,
  },

  require 'plugins/todo-comments',
  require 'plugins/mini',
  require 'plugins/mini_icons',
  require 'plugins/treesitter',
  require 'plugins/dap-python',
  require 'custom/plugins/illuminate',
  require 'custom/plugins/navic',
  require 'custom/plugins/leap',
  
  -- Dashboard plugin with blurred background
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      local db = require('dashboard')
      
      -- Cat ASCII art header with fixed formatting
      local cat_header = {
        '',
        '                       _                        ',
        '                      \\`*-.                    ',
        '                       )  _`-.                 ',
        '                      .  : `. .                ',
        '                      : _   \'  \\               ',
        '                      ; *` _.   `*-._          ',
        '                      `-.-\'          `-.       ',
        '                        ;       `       `.     ',
        '                        :.       .        \\    ',
        '                        . \\  .   :   .-\'   .   ',
        '                        \'  `+.;  ;  \'      :   ',
        '                        :  \'  |    ;       ;-. ',
        "                        ; '   : :`-:     _.`* ;",
        "               [bug] .*' /  .*' ; .*`- +'  `*' ",
        "                     `*-*   `*-*  `*-*'        ",
        '',
        '                         Meow vim ฅ^•ﻌ•^ฅ             ',
        '',
      }

      -- Dune quote for footer
      local dune_footer = {
        '',
        'I must not fear.',
        'Fear is the mind-killer.',
        'Fear is the little-death that brings total obliteration.',
        'I will face my fear.',
        'I will permit it to pass over me and through me.',
        'And when it has gone past, I will turn the inner eye to see its path.',
        'Where the fear has gone there will be nothing. Only I will remain.',
        '',
        '— Bene Gesserit Litany Against Fear',
        '',
      }

      -- Use appropriate icons based on nerd font availability
      local icons = {
        update = vim.g.have_nerd_font and "󰚰 " or "Update",
        files = vim.g.have_nerd_font and "󰥨 " or "Files",
        app = vim.g.have_nerd_font and "󱓞 " or "Apps",
        dotfiles = vim.g.have_nerd_font and "󱁿 " or "Dotfiles",
        project_icon = vim.g.have_nerd_font and "󰲋" or "P",
        mru_icon = vim.g.have_nerd_font and "󰋚" or "R",
        debug_icon = vim.g.have_nerd_font and "󱄑" or "D",
      }

      db.setup({
        theme = 'hyper',
        config = {
          header = cat_header,
          week_header = {
            enable = false,
          },
          shortcut = {
            { desc = icons.update .. " Update", group = '@property', action = 'Lazy update', key = 'u' },
            {
              icon_hl = '@variable',
              desc = icons.files .. " Files",
              group = 'Label',
              action = 'Telescope find_files',
              key = 'f',
            },
            {
              desc = icons.app .. " Apps",
              group = 'DiagnosticHint',
              action = 'Telescope app',
              key = 'a',
            },
            {
              desc = icons.dotfiles .. " dotfiles",
              group = 'Number',
              action = 'Telescope dotfiles',
              key = 'd',
            },
          },
          packages = { enable = true },
          project = { 
            enable = true, 
            limit = 8, 
            icon = icons.project_icon, 
            label = '', 
            action = 'Telescope find_files cwd=' 
          },
          mru = { 
            enable = true, 
            limit = 10, 
            icon = icons.mru_icon, 
            label = '', 
            cwd_only = false 
          },
          footer = dune_footer,
        },
      })

      -- Set an attractive color palette that matches your terminal theme
      vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#56C7D0', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#D7A752', italic = true })

      -- Create an autocmd to preserve highlight colors when colorscheme changes
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#56C7D0', bold = true })
          vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#D7A752', italic = true })
        end,
      })
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },
  
  require 'plugins/autopairs',
  require 'custom/plugins/indent-blankline',
  
  -- Neo-tree file explorer with transparency
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          position = "left",
          width = 30,
          mappings = {
            ["<space>"] = "none",
          },
        },
        filesystem = {
          follow_current_file = {
            enabled = true,
          },
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = {
            enabled = true,
          },
        },
        -- Enable transparency for neo-tree
        enable_git_status = true,
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
        },
        -- Set up event handler for transparency consistency
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function()
              if vim.g.transparent_enabled then
                -- Ensure NeoTree components are transparent when entering the buffer
                vim.defer_fn(function()
                  require('transparent').clear_prefix('NeoTree')
                end, 10)
              end
            end
          }
        },
      })
      
      -- Add NeoTree-specific highlight groups to transparent groups list
      vim.g.transparent_groups = vim.list_extend(
        vim.g.transparent_groups or {},
        { "NeoTreeNormal", "NeoTreeEndOfBuffer", "NeoTreeVertSplit" }
      )
    end,
  },
  
  require 'custom/plugins/diffview',
  
  -- Bufferline with transparency
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      local bufferline = require("bufferline")
      bufferline.setup({
        options = {
          mode = "tabs",
          separator_style = "thin",
          always_show_bufferline = false,
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
          diagnostics = "nvim_lsp",
          -- Adapt to transparent background
          highlights = {
            background = {
              bg = { attribute = "bg", highlight = "Normal" },
            },
            fill = {
              bg = { attribute = "bg", highlight = "TabLineFill" },
            },
          },
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
        },
      })
      
      -- Add all bufferline highlights to transparent groups for consistent appearance
      if vim.g.transparent_enabled then
        vim.defer_fn(function()
          -- Add all BufferLine highlights to transparent groups
          if bufferline and bufferline.highlights then
            local highlights = vim.tbl_values(bufferline.highlights)
            if highlights then
              vim.g.transparent_groups = vim.list_extend(
                vim.g.transparent_groups or {},
                vim.tbl_map(function(v)
                  return v and v.hl_group or nil
                end, highlights)
              )
            end
          end
          
          -- Apply transparency
          require('transparent').clear_prefix('BufferLine')
        end, 100) -- Add a delay to ensure BufferLine has fully initialized
      end
    end,
  },
  
  require 'custom/plugins/trouble',
  require 'custom/plugins/dap-ui',
  require 'custom/plugins/dap-virtual-text',
  
  -- Fancy notifications with transparency
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#00000000", -- For transparency
        render = "wrapped-compact",
        stages = "fade",
        timeout = 3000,
        on_open = function(win)
          -- Apply transparency to notification windows
          if vim.g.transparent_enabled then
            local win_config = vim.api.nvim_win_get_config(win)
            win_config.zindex = 100
            vim.api.nvim_win_set_config(win, win_config)
            
            -- Make sure highlight groups for notifications are transparent
            vim.defer_fn(function()
              require('transparent').clear_prefix('Notify')
            end, 10)
          end
        end
      })
      vim.notify = require("notify")
    end,
  },
  
  require 'custom/plugins/persistent-breakpoints',
  
  -- Lualine with transparent background
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = vim.g.transparent_enabled and "auto" or "auto", -- Use auto theme regardless of transparency
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { "dashboard", "alpha" },
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        -- Transparent background
        extensions = { "neo-tree", "lazy" },
      })
      
      -- Ensure lualine highlights are transparent
      if vim.g.transparent_enabled then
        vim.defer_fn(function()
          require('transparent').clear_prefix('lualine')
        end, 50) -- Slightly longer delay to ensure lualine has initialized
      end
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  
  require 'custom/plugins/luasnip',
  require 'custom/plugins/web-devicons',
  require 'custom/plugins/neoscroll',
  require 'custom/plugins/rainbow-csv',
  require 'custom/plugins/pickme',
  
  -- Blur background plugin (only works in certain environments that support it)
  {
    "f-person/auto-dark-mode.nvim",
    config = function()
      require("auto-dark-mode").setup({
        update_interval = 1000,
        set_dark_mode = function()
          vim.cmd("colorscheme github_dark")
          vim.opt.background = "dark"
        end,
        set_light_mode = function()
          vim.cmd("colorscheme github_light")
          vim.opt.background = "light"
        end,
      })
    end,
  },

  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "L3MON4D3/LuaSnip", -- for snippet support
      "rafamadriz/friendly-snippets", -- optional, for more snippets
    },
    config = function()
      require("blink.cmp").setup({
        -- Add custom config here if needed
      })
    end,
  },

  -- Satellite (minimap/scrollbar)
  {
    'lewis6991/satellite.nvim',
    event = 'VeryLazy',
    config = function()
      require('satellite').setup({})
    end,
  },

  -- YAML Companion
  {
    'someone-stole-my-name/yaml-companion.nvim',
    ft = { 'yaml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('yaml-companion').setup({})
    end,
  },

  -- nvim-jqx (JSON explorer)
  {
    'gennaro-tedesco/nvim-jqx',
    ft = { 'json', 'yaml' },
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- ToggleTerm (terminal integration)
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup({})
    end,
  },

  -- persisted.nvim (session management)
  {
    'olimorris/persisted.nvim',
    config = function()
      require('persisted').setup({})
    end,
  },

  -- Comment.nvim (commenting)
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({})
    end,
    event = 'VeryLazy',
  },

  -- diffview.nvim (diff UI)
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
    dependencies = { 'nvim-lua/plenary.nvim' },
  },

  -- neogit (Magit-like Git UI)
  {
    'NeogitOrg/neogit',
    cmd = 'Neogit',
    dependencies = { 'nvim-lua/plenary.nvim', 'sindrets/diffview.nvim' },
    config = function()
      require('neogit').setup({})
    end,
  },

  -- Keep gitsigns.nvim as it is SOTA for inline git signs

  -- telescope-zoxide (directory switching)
  {
    'jvgrootveld/telescope-zoxide',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      require('telescope').load_extension('zoxide')
    end,
  },

  -- fidget.nvim (LSP progress)
  {
    'j-hui/fidget.nvim',
    tag = 'legacy',
    event = 'LspAttach',
    config = function()
      require('fidget').setup({})
    end,
  },

  -- nvim-lightbulb (LSP code action indicator)
  {
    'kosayoda/nvim-lightbulb',
    event = 'LspAttach',
    config = function()
      require('nvim-lightbulb').setup({
        autocmd = { enabled = true },
      })
    end,
  },

  -- lspsaga.nvim (LSP UI)
  {
    'nvimdev/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  },

  -- actions-preview.nvim (LSP code action preview)
  {
    'aznhe21/actions-preview.nvim',
    event = 'LspAttach',
    config = function()
      require('actions-preview').setup({})
    end,
  },
}, {
  ui = {
    -- Use Nerd Font icons if available 
    icons = vim.g.have_nerd_font and {} or {
      config = '🛠',
      cmd = '⌘',
      event = '📅',
      ft = '📂',
      init = '⚙',
      plugin = '🔌',
      runtime = '💻',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- vim: ts=2 sts=2 sw=2 et