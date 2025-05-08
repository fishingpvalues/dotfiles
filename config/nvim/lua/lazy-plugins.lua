-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

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
      
      -- Cat ASCII art header with fixed formatting (reduced blank lines)
      local cat_header = {
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
        "                        '  `+.;  ;  '      :   ",
        "                        :  '  |    ;       ;-. ",
        "                        ; '   : :`-:     _.`* ;",
        "               [bug] .*' /  .*' ; .*`- +'  `*' ",
        "                     `*-*   `*-*  `*-*'        ",
        '                         Meow vim ฅ^•ﻌ•^ฅ             ',
        '',
      }

      -- Digital clock and date with weekday (German) and icons
      local function get_datetime_line()
        local have_nerd = vim.g.have_nerd_font
        local clock_icon = have_nerd and '󰥔' or '🕒'
        local cal_icon = have_nerd and '󰃰' or '📅'
        local weekdays = {
          'Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'
        }
        local now = os.date('*t')
        local weekday = weekdays[now.wday]
        local date_str = string.format('%s %s, %02d.%02d.%04d', cal_icon, weekday, now.day, now.month, now.year)
        local time_str = string.format('%s %02d:%02d:%02d', clock_icon, now.hour, now.min, now.sec)
        return { '', date_str .. '   ' .. time_str, '' }
      end

      -- Weather info using wttr.in
      local function get_weather_line()
        local have_nerd = vim.g.have_nerd_font
        local weather_icon = have_nerd and '' or '☀️'
        local location = os.getenv('WTTR_LOCATION') or '' -- User can set WTTR_LOCATION, else auto
        local url = 'wttr.in/' .. location .. '?format=%C+%t+%w'
        local weather = ''
        -- Try to cache for session
        if not vim.g._dashboard_weather then
          local handle = io.popen('curl -s "' .. url .. '"')
          if handle then
            weather = handle:read('*a') or ''
            handle:close()
            if weather and #weather > 0 then
              vim.g._dashboard_weather = weather
            else
              vim.g._dashboard_weather = 'Wetter nicht verfügbar'
            end
          else
            vim.g._dashboard_weather = 'Wetter nicht verfügbar'
          end
        end
        weather = vim.g._dashboard_weather or 'Wetter nicht verfügbar'
        return { weather_icon .. ' ' .. weather }
      end

      -- Git status/branch info
      local function get_git_line()
        local have_nerd = vim.g.have_nerd_font
        local git_icon = have_nerd and '' or ''
        local branch = ''
        local status = ''
        local git_dir = vim.fn.finddir('.git', '.;')
        if git_dir ~= '' then
          branch = vim.fn.system('git rev-parse --abbrev-ref HEAD 2>NUL'):gsub('\n', '')
          local stat = vim.fn.system('git status --porcelain=2 --branch 2>NUL')
          local ahead, behind = stat:match('ahead (%d+)'), stat:match('behind (%d+)')
          local dirty = stat:find('1 .') and '✗' or ''
          status = string.format('%s%s%s', ahead and (' ↑'..ahead) or '', behind and (' ↓'..behind) or '', dirty)
          if branch == '' then branch = 'No branch' end
          return { string.format('%s %s%s', git_icon, branch, status) }
        else
          return { git_icon .. ' Kein Git-Repo' }
        end
      end
      -- Network status: WiFi/Ethernet and IP
      local function get_network_line()
        local have_nerd = vim.g.have_nerd_font
        local wifi_icon = have_nerd and '󰤨' or '📶'
        local eth_icon = have_nerd and '󰈀' or '🔌'
        local ip_icon = have_nerd and '󰩟' or '🌐'
        local ip = vim.fn.system('hostname -I 2>NUL'):match('%d+%.%d+%.%d+%.%d+') or vim.fn.system('ipconfig 2>NUL'):match('IPv4.-: ([%d%.]+)') or ''
        if not ip or ip == '' then ip = 'IP nicht verfügbar' end
        -- Try to detect WiFi/Ethernet (Windows/Unix)
        local net = ''
        if vim.fn.has('win32') == 1 then
          local wifi = vim.fn.system('netsh wlan show interfaces 2>NUL')
          if wifi:find('SSID') then
            net = wifi_icon .. ' WLAN'
          else
            net = eth_icon .. ' LAN'
          end
        else
          local iw = vim.fn.system('iwgetid -r 2>/dev/null')
          if iw and #iw > 0 then
            net = wifi_icon .. ' WLAN'
          else
            net = eth_icon .. ' LAN'
          end
        end
        return { string.format('%s %s %s %s', net, ip_icon, ip, '') }
      end
      -- Battery status
      local function get_battery_line()
        local have_nerd = vim.g.have_nerd_font
        local bat_icon = have_nerd and '󰁹' or '🔋'
        local bat = ''
        if vim.fn.has('win32') == 1 then
          local wmic = vim.fn.system('wmic path Win32_Battery get EstimatedChargeRemaining 2>NUL')
          local percent = wmic:match('(%d+)')
          if percent then
            bat = percent .. '%%'
          else
            bat = 'Nicht verfügbar'
          end
        else
          local acpi = vim.fn.system('acpi -b 2>/dev/null')
          local percent = acpi:match('(%d?%d?%d)%%')
          if percent then
            bat = percent .. '%%'
          else
            bat = 'Nicht verfügbar'
          end
        end
        return { string.format('%s %s', bat_icon, bat) }
      end

      -- Dune quote for footer (reduced blank lines)
      local dune_footer = {
        '', '', -- Add more space before the quote
        'I must not fear.',
        'Fear is the mind-killer.',
        'Fear is the little-death that brings total obliteration.',
        'I will face my fear.',
        'I will permit it to pass over me and through me.',
        'And when it has gone past, I will turn the inner eye to see its path.',
        'Where the fear has gone there will be nothing. Only I will remain.',
        '— Bene Gesserit Litany Against Fear',
        '', '', -- Add more space after the quote
      }

      -- Data Science Info (condensed to one line)
      local function get_data_science_info()
        local have_nerd = vim.g.have_nerd_font
        local icons = {
          python = have_nerd and '󰌠' or '🐍',
          conda = have_nerd and '󱔎' or '🅒',
          cuda = have_nerd and '󰢮' or '🖥️',
          jupyter = have_nerd and '󰠮' or '📒',
          yazi = have_nerd and '󰙅' or '🗂️',
        }
        local py = vim.fn.system('python --version 2>&1'):gsub('\n', '')
        if py == '' or py:match('not found') then
          py = icons.python .. ' Python: Not found'
        else
          py = icons.python .. ' ' .. py
        end
        local conda_env = os.getenv('CONDA_DEFAULT_ENV')
        local conda = conda_env and #conda_env > 0 and (icons.conda .. ' ' .. conda_env) or (icons.conda .. ' No Conda')
        local cuda = vim.fn.system('nvidia-smi --query-gpu=name,driver_version --format=csv,noheader 2>/dev/null | head -n1'):gsub('\n', '')
        if cuda == '' or cuda:match('not found') then
          cuda = icons.cuda .. ' No CUDA'
        else
          cuda = icons.cuda .. ' ' .. cuda
        end
        local jupyter = vim.fn.system('jupyter --version 2>&1 | head -n1'):gsub('\n', '')
        if jupyter == '' or jupyter:match('not found') then
          jupyter = icons.jupyter .. ' No Jupyter'
        else
          jupyter = icons.jupyter .. ' ' .. jupyter
        end
        local yazi_path = vim.fn.exepath('yazi')
        local yazi = yazi_path and #yazi_path > 0 and (icons.yazi .. ' Yazi') or (icons.yazi .. ' No Yazi')
        return {
          string.format('󰅩  %s   %s   %s   %s   %s', py, conda, cuda, jupyter, yazi)
        }
      end
      -- Insert condensed Data Science Info at the end of the footer
      for _, line in ipairs(get_data_science_info()) do
        table.insert(dune_footer, line)
      end

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

      -- Helper to check if a command exists
      local function has_cmd(cmd)
        return vim.fn.exepath(cmd) ~= ''
      end
      -- Helper to check if a directory exists
      local function dir_exists(path)
        return vim.fn.isdirectory(vim.fn.expand(path)) == 1
      end
      -- Helper to show a notification
      local function notify_missing(what, icon, extra)
        vim.schedule(function()
          vim.notify(icon .. ' ' .. what .. ' is not available.' .. (extra or ''), vim.log.levels.WARN, {title = 'Dashboard'})
        end)
      end
      -- Files shortcut: needs ripgrep
      local function files_shortcut_action()
        if not has_cmd('rg') then
          notify_missing('ripgrep (rg)', icons.files, ' Please install ripgrep to use file search.')
          return
        end
        vim.cmd('Telescope find_files')
      end
      -- Dotfiles shortcut: needs chezmoi and ~/dotfiles
      local function dotfiles_shortcut_action()
        if not dir_exists('~/dotfiles') then
          notify_missing('dotfiles directory', icons.dotfiles, ' ~/dotfiles not found.')
          return
        end
        if not has_cmd('chezmoi') then
          notify_missing('chezmoi', icons.dotfiles, ' Please install chezmoi to manage dotfiles.')
          return
        end
        vim.cmd('Telescope find_files cwd=~/dotfiles')
      end
      -- Yazi shortcut: needs yazi in PATH
      local function yazi_shortcut_action()
        if not has_cmd('yazi') then
          notify_missing('Yazi file manager', '󰙅', ' Please install yazi and add to PATH.')
          return
        end
        vim.cmd('Yazi')
      end
      -- Apps shortcut: always visible, warn if missing
      local function apps_shortcut_action()
        if not has_cmd('rg') then
          notify_missing('ripgrep (rg)', icons.app, ' Please install ripgrep to use this shortcut.')
          return
        end
        if not apps_dir or not dir_exists(apps_dir) then
          notify_missing('Apps directory', icons.app, ' Not found for this OS.')
          return
        end
        vim.cmd('Telescope find_files cwd=' .. vim.fn.expand(apps_dir))
      end

      -- Fallback for apps_label if nil
      local safe_apps_label = (apps_label ~= nil and tostring(apps_label) ~= '' and apps_label) or (icons.app or 'Apps')

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
              action = 'lua require("custom.commands.dashboard_actions").files_shortcut_action()',
              key = 'f',
            },
            {
              desc = safe_apps_label,
              group = 'DiagnosticHint',
              action = 'lua require("custom.commands.dashboard_actions").apps_shortcut_action()',
              key = 'a',
            },
            {
              desc = icons.dotfiles .. " dotfiles",
              group = 'Number',
              action = 'lua require("custom.commands.dashboard_actions").dotfiles_shortcut_action()',
              key = 'd',
            },
            {
              desc = '󰙅 Yazi',
              group = 'Label',
              action = 'lua require("custom.commands.dashboard_actions").yazi_shortcut_action()',
              key = 'y',
            },
            {
              desc = '󰝰 New Project',
              group = 'Label',
              key = 'n',
              action = 'lua require("custom.commands.dashboard_actions").new_project_action()',
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
            cwd_only = false,
            action = 'lua require("custom.commands.dashboard_actions").mru_action()',
          },
          footer = dune_footer,
        },
      })

      -- Set an attractive color palette that matches your terminal theme
      vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#56C7D0', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#6c7086', italic = true })

      -- Compose status block (single wide line, compact)
      local function get_status_block_plain()
        local dt = get_datetime_line()[2] or ''
        local weather = get_weather_line()[1] or ''
        local git = get_git_line()[1] or ''
        local net = get_network_line()[1] or ''
        local bat = get_battery_line()[1] or ''
        -- Join all status info into one wide line
        return {
          string.format('  %s   %s   %s   %s   %s  ', dt, weather, git, net, bat),
          '', -- Add blank line after status/info
        }
      end
      -- Insert status block below cat ASCII art
      local cat_end = #cat_header
      for i, v in ipairs(get_status_block_plain()) do
        table.insert(cat_header, cat_end + i, v)
      end
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
  },
  
  require 'plugins/autopairs',
  require 'custom/plugins/indent-blankline',
  
  -- Neo-tree file explorer
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
        enable_git_status = true,
        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
        },
      })
    end,
  },
  
  require 'custom/plugins/diffview',
  
  -- Bufferline
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
          always_show_bufferline = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          color_icons = true,
          diagnostics = "nvim_lsp",
          hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
          },
        },
      })
    end,
  },
  
  require 'custom/plugins/trouble',
  require 'custom/plugins/dap-ui',
  require 'custom/plugins/dap-virtual-text',
  
  -- Fancy notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#1a1b26", -- Use a solid background color
        render = "wrapped-compact",
        stages = "fade",
        timeout = 3000,
        -- Removed transparency logic
      })
      vim.notify = require("notify")
    end,
  },
  
  require 'custom/plugins/persistent-breakpoints',
  
 
  require 'custom/plugins/luasnip',
  require 'custom/plugins/web-devicons',
  require 'custom/plugins/neoscroll',
  require 'custom/plugins/rainbow-csv',
  require 'custom/plugins/pickme',
  require 'custom/plugins/lualine',
  
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
    build = "cargo build --release",
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

  -- Ensure yazi.nvim is in the plugin list
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
      "nvim-lua/plenary.nvim"
    },
    config = function()
      -- Optional: custom config for yazi
    end,
  },
}, {
  ui = {
    -- Use Nerd Font icons if available 
    icons = vim.g.have_nerd_font and {} or {
      config = '🛠',
      cmd = '⌘',
      event = '��',
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