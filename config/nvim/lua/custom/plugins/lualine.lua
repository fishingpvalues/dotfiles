-- Lualine configuration with transparency support
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    -- Get the current mode
    local function mode()
      local mode_map = {
        ['n'] = 'NORMAL',
        ['no'] = 'NORMAL',
        ['nov'] = 'NORMAL',
        ['noV'] = 'NORMAL',
        ['no\22'] = 'NORMAL',
        ['niI'] = 'NORMAL',
        ['niR'] = 'NORMAL',
        ['niV'] = 'NORMAL',
        ['nt'] = 'NORMAL',
        ['ntT'] = 'NORMAL',
        ['v'] = 'VISUAL',
        ['vs'] = 'VISUAL',
        ['V'] = 'V-LINE',
        ['Vs'] = 'V-LINE',
        ['\22'] = 'V-BLOCK',
        ['\22s'] = 'V-BLOCK',
        ['s'] = 'SELECT',
        ['S'] = 'S-LINE',
        ['\19'] = 'S-BLOCK',
        ['i'] = 'INSERT',
        ['ic'] = 'INSERT',
        ['ix'] = 'INSERT',
        ['R'] = 'REPLACE',
        ['Rc'] = 'REPLACE',
        ['Rx'] = 'REPLACE',
        ['Rv'] = 'V-REPLACE',
        ['Rvc'] = 'V-REPLACE',
        ['Rvx'] = 'V-REPLACE',
        ['c'] = 'COMMAND',
        ['cv'] = 'EX',
        ['ce'] = 'EX',
        ['r'] = 'PROMPT',
        ['rm'] = 'MORE',
        ['r?'] = 'CONFIRM',
        ['!'] = 'SHELL',
        ['t'] = 'TERMINAL',
      }
      local m = vim.api.nvim_get_mode().mode
      return ' ' .. (mode_map[m] or m)
    end

    -- Custom filename component
    local function filename()
      local fname = vim.fn.expand('%:t')
      if fname == '' then
        return '[No Name]'
      end
      return fname
    end

    -- LSP progress indicator
    local function lsp_progress()
      local messages = vim.lsp.util.get_progress_messages()
      if #messages == 0 then
        return ''
      end
      local status = {}
      for _, msg in pairs(messages) do
        table.insert(status, (msg.percentage or 0) .. '%% ' .. (msg.title or ''))
      end
      return table.concat(status, ' | ')
    end

    -- Initialize lualine with transparency-friendly configuration
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = { 'dashboard', 'alpha' },
          winbar = { 'dashboard', 'alpha', 'neo-tree', 'Trouble' },
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = {
          { mode, separator = { left = '', right = '' }, padding = { left = 1, right = 1 } },
        },
        lualine_b = {
          { 'branch', icon = '' },
          {
            'diff',
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed
                }
              end
            end,
          },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
          },
        },
        lualine_c = {
          { filename, path = 1 },
          { lsp_progress },
        },
        lualine_x = {
          'filetype',
          'encoding',
          'fileformat',
        },
        lualine_y = {
          { 'progress', separator = { left = '', right = '' }, padding = { left = 1, right = 1 } },
        },
        lualine_z = {
          { 'location', separator = { left = '', right = '' }, padding = { left = 1, right = 1 } },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { filename },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { 'neo-tree', 'lazy', 'trouble' },
    })

    -- Make lualine highlights work well with transparency
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- Set transparent background for lualine
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        if normal_bg then
          -- Adjust normal section (a/c) backgrounds to be more transparent
          vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = normal_bg, fg = "#abb2bf" })
          vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = normal_bg, fg = "#6f737b" })
        end
      end,
    })
  end,
}