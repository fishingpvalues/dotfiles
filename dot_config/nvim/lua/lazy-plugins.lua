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
          py = icons.python .. ' ¬ Python'
        else
          py = icons.python .. ' ⊢ ' .. py
        end
        local conda_env = os.getenv('CONDA_DEFAULT_ENV')
        local conda = conda_env and #conda_env > 0 and (icons.conda .. ' ∈ ' .. conda_env) or (icons.conda .. ' ∉ Conda')
        -- CUDA: check for nvcc
        local nvcc_path = vim.fn.exepath('nvcc')
        local cuda
        if not nvcc_path or nvcc_path == '' then
          cuda = icons.cuda .. ' ¬ CUDA'
        else
          local cuda_version = vim.fn.system('nvcc --version 2>&1'):match('release ([%d%.]+)')
          if cuda_version then
            cuda = icons.cuda .. ' ⊢ CUDA ' .. cuda_version
          else
            cuda = icons.cuda .. ' ⊢ CUDA (∄ version)'
          end
        end
        local jupyter = vim.fn.system('jupyter --version 2>&1 | head -n1'):gsub('\n', '')
        if jupyter == '' or jupyter:match('not found') then
          jupyter = icons.jupyter .. ' ∄ Jupyter'
        else
          jupyter = icons.jupyter .. ' ∃ ' .. jupyter
        end
        local yazi_path = vim.fn.exepath('yazi')
        local yazi = yazi_path and #yazi_path > 0 and (icons.yazi .. ' ⊢ Yazi') or (icons.yazi .. ' ¬ Yazi')
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
          packages = { enable = false }, -- disable plugin count
          -- Remove the 'project' section (recent folders)
          -- project = { 
          --   enable = true, 
          --   limit = 8, 
          --   icon = icons.project_icon, 
          --   label = '', 
          --   action = 'Telescope find_files cwd=' 
          -- },
          -- Add a 'recent sessions' section above recent files, using persisted.nvim
          recent_sessions = {
            enable = true,
            limit = 5,
            icon = icons.project_icon or (vim.g.have_nerd_font and '󰄉' or 'Sessions'),
            label = 'Sessions',
            group = 'Label',
            action = 'lua require("custom.commands.dashboard_actions").recent_sessions_action()',
          },
          mru = {
            enable = true,
            limit = 10,
            icon = (icons.mru_icon or (vim.g.have_nerd_font and '󰋚' or 'Recent')) .. '  ',
            label = '  Recent Files',
            group = 'Label',
            cwd_only = false,
            action = 'lua require("custom.commands.dashboard_actions").mru_action()',
          },
          footer = dune_footer,
        },
      })

      -- Set an attractive color palette that matches your terminal theme
      -- Header: vibrant cyan
      vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#56C7D0', bold = true })
      -- Shortcuts: purple
      vim.api.nvim_set_hl(0, 'DashboardShortcut', { fg = '#c678dd', bold = true })
      -- Sessions: blue
      vim.api.nvim_set_hl(0, 'DashboardSessions', { fg = '#61afef', bold = true })
      -- Recent Files: green
      vim.api.nvim_set_hl(0, 'DashboardRecent', { fg = '#98c379', bold = true })
      -- Footer/Quote: subtle grey
      vim.api.nvim_set_hl(0, 'DashboardFooter', { fg = '#5c6370', italic = true })
      -- Bottom line: brand colors (GitHub, Python, Conda, CUDA, Jupyter, Yazi)
      -- Compose a rainbow bar using highlight groups
      vim.api.nvim_set_hl(0, 'DashboardBrandGitHub', { fg = '#24292f', bg = '#ffffff', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardBrandPython', { fg = '#3776ab', bg = '#ffd43b', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardBrandConda', { fg = '#44a833', bg = '#ffffff', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardBrandCUDA', { fg = '#76b900', bg = '#000000', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardBrandJupyter', { fg = '#f37626', bg = '#ffffff', bold = true })
      vim.api.nvim_set_hl(0, 'DashboardBrandYazi', { fg = '#ffb86c', bg = '#282a36', bold = true })
      -- Optionally, you can draw a colored bar at the bottom using virtual text or a custom footer line.

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

      -- Timer to refresh the dashboard time every 10 minutes (600000 ms)
      local function refresh_dashboard_time()
        -- Remove old status block
        for _ = 1, 2 do table.remove(cat_header, cat_end + 1) end
        -- Insert new status block
        for i, v in ipairs(get_status_block_plain()) do
          table.insert(cat_header, cat_end + i, v)
        end
        -- Redraw dashboard
        if vim.api.nvim_get_var and pcall(vim.api.nvim_command, 'echo') then
          pcall(vim.cmd, 'redraw')
        end
      end
      if vim.fn.has('nvim') == 1 and vim.loop then
        vim.defer_fn(function()
          refresh_dashboard_time()
          vim.defer_fn(refresh_dashboard_time, 600000) -- 10 minutes
        end, 600000)
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
    version = "*",
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
      require('toggleterm').setup({
        size = function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = { [[<C-\\>]], [[<leader>tt]] },
        insert_mappings = true,
        terminal_mappings = true,
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        persist_size = true,
        persist_mode = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = 'curved',
          winblend = 3,
        },
        winbar = { enabled = false },
      })
      -- SOTA commands
      local Terminal = require('toggleterm.terminal').Terminal
      local lazygit = Terminal:new({ cmd = 'lazygit', hidden = true, direction = 'float' })
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end
      vim.api.nvim_set_keymap('n', '<leader>tg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', { noremap = true, silent = true, desc = 'Toggle Lazygit' })
      local htop = Terminal:new({ cmd = 'htop', hidden = true, direction = 'float' })
      function _HTOP_TOGGLE()
        htop:toggle()
      end
      vim.api.nvim_set_keymap('n', '<leader>th', '<cmd>lua _HTOP_TOGGLE()<CR>', { noremap = true, silent = true, desc = 'Toggle htop' })
      local python = Terminal:new({ cmd = 'python', hidden = true, direction = 'float' })
      function _PYTHON_TOGGLE()
        python:toggle()
      end
      vim.api.nvim_set_keymap('n', '<leader>tp', '<cmd>lua _PYTHON_TOGGLE()<CR>', { noremap = true, silent = true, desc = 'Toggle Python REPL' })
    end,
  },

  -- persisted.nvim (session management)
  {
    'olimorris/persisted.nvim',
    config = function()
      require('persisted').setup({
        dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
        use_git_branch = true, -- use git branch to save session
        autosave = true, -- automatically save session on exit
        autoload = false, -- do not autoload session
        follow_cwd = true, -- update session file name on cwd change
        allowed_dirs = nil, -- allow all dirs
        ignored_dirs = { vim.fn.stdpath("config") }, -- ignore config dir
        telescope = {
          enabled = true,
        },
      })
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

  {
    "nelnn/bear.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {
      cache_dir = "~/.cache/nvim/bear",
      file_name = "df_debug_" .. os.time() .. ".csv",
      window = {
        width = 0.9,
        height = 0.8,
        border = "rounded"
      },
      keymap = {
        visualise = "<Leader>df"
      }
    },
    config = function(_, opts)
      local ok, df_visidata = pcall(require, "bear")
      if not ok then
        vim.schedule(function()
          vim.notify("bear.nvim failed to load!", vim.log.levels.ERROR, {title = "bear.nvim"})
        end)
        return
      end
      df_visidata.setup(opts)
    end,
    ft = { "python" },
  },

  {
    'FredeHoey/tardis.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local ok, tardis = pcall(require, 'tardis-nvim')
      if not ok then
        vim.schedule(function()
          vim.notify('tardis.nvim failed to load!', vim.log.levels.ERROR, {title = 'tardis.nvim'})
        end)
        return
      end
      tardis.setup {
        keymap = {
          ["next"] = '<C-j>',
          ["prev"] = '<C-k>',
          ["quit"] = 'q',
          ["revision_message"] = '<C-m>',
          ["commit"] = '<C-g>',
        },
        initial_revisions = 10,
        max_revisions = 256,
      }
    end,
    cmd = { 'Tardis' },
    keys = {
      { '<leader>ut', '<cmd>Tardis git<cr>', desc = '[Tardis] Git Timetravel' },
    },
  },

  {
    "typicode/bg.nvim",
    lazy = false,
    config = function()
      local ok, bg = pcall(require, "bg")
      if not ok then
        vim.schedule(function()
          vim.notify("bg.nvim failed to load!", vim.log.levels.ERROR, {title = "bg.nvim"})
        end)
        return
      end
      bg.setup({})
    end,
  },

  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    priority = 10,
    config = function()
      local ok, glimmer = pcall(require, "tiny-glimmer")
      if not ok then
        vim.schedule(function()
          vim.notify("tiny-glimmer.nvim failed to load!", vim.log.levels.ERROR, {title = "tiny-glimmer.nvim"})
        end)
        return
      end
      glimmer.setup({
        enabled = true,
        disable_warnings = true,
        refresh_interval_ms = 8,
        transparency_color = "#181a1b", -- subtle, nearly transparent dark
        overwrite = {
          auto_map = true,
          yank = {
            enabled = true,
            default_animation = "fade",
          },
          search = {
            enabled = false,
            default_animation = "pulse",
            next_mapping = "n",
            prev_mapping = "N",
          },
          paste = {
            enabled = true,
            default_animation = "reverse_fade",
            paste_mapping = "p",
            Paste_mapping = "P",
          },
          undo = {
            enabled = false,
          },
          redo = {
            enabled = false,
          },
        },
        animations = {
          fade = {
            max_duration = 350,
            min_duration = 250,
            easing = "outQuad",
            chars_for_max_duration = 10,
            from_color = "#23272e", -- github dark subtle selection
            to_color = "Normal",
          },
          reverse_fade = {
            max_duration = 320,
            min_duration = 220,
            easing = "outBack",
            chars_for_max_duration = 10,
            from_color = "#23272e",
            to_color = "Normal",
          },
          pulse = {
            max_duration = 400,
            min_duration = 300,
            chars_for_max_duration = 15,
            pulse_count = 2,
            intensity = 1.1,
            from_color = "#23272e",
            to_color = "Normal",
          },
        },
      })
    end,
  },

  {
    "xzbdmw/colorful-menu.nvim",
    event = "VeryLazy",
    config = function()
      local ok, cmenu = pcall(require, "colorful-menu")
      if not ok then
        vim.schedule(function()
          vim.notify("colorful-menu.nvim failed to load!", vim.log.levels.ERROR, {title = "colorful-menu.nvim"})
        end)
        return
      end
      cmenu.setup({
        ls = {
          pylsp = {
            extra_info_hl = "@comment",
            arguments_hl = "@comment",
          },
          pyright = {
            extra_info_hl = "@comment",
          },
          basedpyright = {
            extra_info_hl = "@comment",
          },
          lua_ls = {
            arguments_hl = "@comment",
          },
          rust_analyzer = {
            extra_info_hl = "@comment",
            align_type_to_right = true,
            preserve_type_when_truncate = true,
          },
          ["rust-analyzer"] = {
            extra_info_hl = "@comment",
            align_type_to_right = true,
            preserve_type_when_truncate = true,
          },
          gopls = {
            align_type_to_right = true,
            preserve_type_when_truncate = true,
          },
          tsserver = {
            extra_info_hl = "@comment",
          },
          ts_ls = {
            extra_info_hl = "@comment",
          },
          vtsls = {
            extra_info_hl = "@comment",
          },
          clangd = {
            extra_info_hl = "@comment",
            align_type_to_right = true,
            import_dot_hl = "@comment",
            preserve_type_when_truncate = true,
          },
          zls = {
            align_type_to_right = true,
          },
          roslyn = {
            extra_info_hl = "@comment",
          },
          dartls = {
            extra_info_hl = "@comment",
          },
          intelephense = {
            extra_info_hl = "@comment",
          },
          fallback = true,
          fallback_extra_info_hl = "@comment",
        },
        fallback_highlight = "@variable",
        max_width = 60,
      })
      -- Integrate with blink.cmp if present
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink and blink.setup then
        blink.setup({
          completion = {
            menu = {
              draw = {
                columns = { { "kind_icon" }, { "label", gap = 1 } },
                components = {
                  label = {
                    text = function(ctx)
                      return require("colorful-menu").blink_components_text(ctx)
                    end,
                    highlight = function(ctx)
                      return require("colorful-menu").blink_components_highlight(ctx)
                    end,
                  },
                },
              },
            },
          },
        })
      end
    end,
  },

  {
    "ya2s/nvim-cursorline",
    event = "VeryLazy",
    config = function()
      local ok, cursorline = pcall(require, "nvim-cursorline")
      if not ok then
        vim.schedule(function()
          vim.notify("nvim-cursorline failed to load!", vim.log.levels.ERROR, {title = "nvim-cursorline"})
        end)
        return
      end
      cursorline.setup {
        cursorline = {
          enable = true,
          timeout = 1000,
          number = false,
        },
        cursorword = {
          enable = true,
          min_length = 3,
          hl = { underline = true },
        },
      }
    end,
  },

  -- Clipboard provider: richclip.nvim (preferred)
  {
    "beeender/richclip.nvim",
    event = "VeryLazy",
    config = function()
      require("richclip").setup({
        -- richclip_path = nil, -- auto-downloads if not set
        set_g_clipboard = true,
        enable_debug = false,
      })
    end,
  },

  {
    "wurli/visimatch.nvim",
    event = "VeryLazy",
    config = function()
      local ok, visimatch = pcall(require, "visimatch")
      if not ok then
        vim.schedule(function()
          vim.notify("visimatch.nvim failed to load!", vim.log.levels.ERROR, {title = "visimatch.nvim"})
        end)
        return
      end
      visimatch.setup({
        -- Use defaults: highlights with 'Search', case-insensitive for markdown/text/help
      })
    end,
  },

  {
    'aaronik/treewalker.nvim',
    event = 'VeryLazy',
    config = function()
      local ok, treewalker = pcall(require, 'treewalker')
      if not ok then
        vim.schedule(function()
          vim.notify('treewalker.nvim failed to load!', vim.log.levels.ERROR, {title = 'treewalker.nvim'})
        end)
        return
      end
      treewalker.setup({
        highlight = true,
        highlight_duration = 250,
        highlight_group = 'CursorLine',
      })
    end,
  },

  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    config = function()
      local ok, mc = pcall(require, "multicursor-nvim")
      if not ok then
        vim.schedule(function()
          vim.notify("multicursor.nvim failed to load!", vim.log.levels.ERROR, {title = "multicursor.nvim"})
        end)
        return
      end
      mc.setup()
      local set = vim.keymap.set
      -- Add or skip cursor above/below the main cursor.
      set({"n", "x"}, "<up>", function() mc.lineAddCursor(-1) end, { desc = "Add cursor above" })
      set({"n", "x"}, "<down>", function() mc.lineAddCursor(1) end, { desc = "Add cursor below" })
      set({"n", "x"}, "<leader><up>", function() mc.lineSkipCursor(-1) end, { desc = "Skip cursor above" })
      set({"n", "x"}, "<leader><down>", function() mc.lineSkipCursor(1) end, { desc = "Skip cursor below" })
      -- Add or skip adding a new cursor by matching word/selection
      set({"n", "x"}, "<leader>n", function() mc.matchAddCursor(1) end, { desc = "Add cursor to next match" })
      set({"n", "x"}, "<leader>s", function() mc.matchSkipCursor(1) end, { desc = "Skip next match" })
      set({"n", "x"}, "<leader>N", function() mc.matchAddCursor(-1) end, { desc = "Add cursor to prev match" })
      set({"n", "x"}, "<leader>S", function() mc.matchSkipCursor(-1) end, { desc = "Skip prev match" })
      -- Add and remove cursors with control + left click.
      set("n", "<c-leftmouse>", mc.handleMouse, { desc = "Add/remove cursor (mouse)" })
      set("n", "<c-leftdrag>", mc.handleMouseDrag, { desc = "Drag cursor (mouse)" })
      set("n", "<c-leftrelease>", mc.handleMouseRelease, { desc = "Release cursor (mouse)" })
      -- Disable and enable cursors.
      set({"n", "x"}, "<c-q>", mc.toggleCursor, { desc = "Toggle multicursor mode" })
      -- Mappings defined in a keymap layer only apply when there are multiple cursors.
      mc.addKeymapLayer(function(layerSet)
        layerSet({"n", "x"}, "<left>", mc.prevCursor)
        layerSet({"n", "x"}, "<right>", mc.nextCursor)
        layerSet({"n", "x"}, "<leader>x", mc.deleteCursor)
        layerSet("n", "<esc>", function()
          if not mc.cursorsEnabled() then
            mc.enableCursors()
          else
            mc.clearCursors()
          end
        end)
      end)
      -- Highlight groups for subtle, modern look
      local hl = vim.api.nvim_set_hl
      hl(0, "MultiCursorCursor", { reverse = true })
      hl(0, "MultiCursorVisual", { link = "Visual" })
      hl(0, "MultiCursorSign", { link = "SignColumn" })
      hl(0, "MultiCursorMatchPreview", { link = "Search" })
      hl(0, "MultiCursorDisabledCursor", { reverse = true })
      hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
      hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
    end,
  },

  {
    "sphamba/smear-cursor.nvim",
    opts = {
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
      cursor_color = "#d3cdc3", -- Subtle, soft beige for GitHub Dark
    },
    config = function(_, opts)
      local ok, smear = pcall(require, "smear_cursor")
      if not ok then
        vim.schedule(function()
          vim.notify("smear-cursor.nvim failed to load!", vim.log.levels.ERROR, {title = "smear-cursor.nvim"})
        end)
        return
      end
      smear.setup(opts)
    end,
  },

  {
    "hat0uma/csvview.nvim",
    opts = {
      parser = { comments = { "#", "//" } },
      view = {
        display_mode = "highlight", -- subtle, modern delimiter highlight
        header_lnum = 1, -- sticky header for first line
      },
      keymaps = {
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    config = function(_, opts)
      local ok, csvview = pcall(require, "csvview")
      if not ok then
        vim.schedule(function()
          vim.notify("csvview.nvim failed to load!", vim.log.levels.ERROR, {title = "csvview.nvim"})
        end)
        return
      end
      csvview.setup(opts)
    end,
    ft = { "csv", "tsv" },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },

  {
    "mrjones2014/smart-splits.nvim",
    priority = 1001,
    lazy = false,
    config = function()
      local ok, smart_splits = pcall(require, "smart-splits")
      if not ok then
        vim.schedule(function()
          vim.notify("smart-splits.nvim failed to load!", vim.log.levels.ERROR, {title = "smart-splits.nvim"})
        end)
        return
      end
      local multiplexer = nil
      if vim.env.TERM_PROGRAM == "WezTerm" and vim.fn.executable("wezterm") == 1 then
        multiplexer = "wezterm"
      elseif vim.fn.executable("tmux") == 1 then
        multiplexer = "tmux"
      end
      smart_splits.setup({
        at_edge = "wrap",
        multiplexer_integration = multiplexer,
        log_level = "warn",
      })
    end,
  },

  require 'custom/plugins/hardtime',

  -- Code Runner (VSCode-like code execution for many languages)
  {
    'CRAG666/code_runner.nvim',
    event = 'VeryLazy',
    config = function()
      require('code_runner').setup({
        mode = 'toggleterm',
        focus = true,
        startinsert = true,
        filetype = {
          python = 'python3 -u',
          -- Add/override more filetype commands as needed
        },
      })
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