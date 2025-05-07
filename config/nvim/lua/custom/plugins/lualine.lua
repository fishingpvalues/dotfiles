-- Lualine configuration with transparency support
return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
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

    local function lsp_status()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients > 0 then
        return ' ' .. clients[1].name
      end
      return ''
    end

    local function filetype_icon()
      local devicons = require('nvim-web-devicons')
      local fname = vim.fn.expand('%:t')
      local ext = vim.fn.expand('%:e')
      local icon, _ = devicons.get_icon(fname, ext, { default = true })
      return icon or ''
    end

    local function readonly_modified()
      if vim.bo.readonly then
        return ''
      elseif vim.bo.modified then
        return '●'
      end
      return ''
    end

    local function short_path()
      local path = vim.fn.expand('%:~:.')
      if path == '' then return '[No Name]' end
      return path
    end

    local function session_name()
      if vim.v.this_session ~= '' then
        return ' ' .. vim.fn.fnamemodify(vim.v.this_session, ':t:r')
      end
      return ''
    end

    local function search_count()
      if vim.v.hlsearch == 1 and vim.fn.searchcount then
        local sc = vim.fn.searchcount({ maxcount = 999, timeout = 50 })
        if sc.total and sc.total > 0 then
          return string.format(' %d/%d', sc.current, sc.total)
        end
      end
      return ''
    end

    -- Custom component for conda environment
    local function conda_env()
      local env = vim.env.CONDA_DEFAULT_ENV
      if env and env ~= '' then
        return ' ' .. env
      end
      -- Try virtualenv
      local venv = vim.env.VIRTUAL_ENV
      if venv and venv ~= '' then
        return ' ' .. vim.fn.fnamemodify(venv, ':t')
      end
      return ''
    end

    -- Initialize lualine with transparency-friendly configuration
    require('lualine').setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = { statusline = { 'dashboard', 'alpha' }, winbar = {} },
        globalstatus = true,
        always_divide_middle = true,
        always_show_tabline = true,
      },
      sections = {
        lualine_a = {
          {
            'mode',
            icon = '',
            padding = { left = 1, right = 1 },
            color = function()
              -- Mode colors inspired by github_dark and popular themes
              local mode_color = {
                n = { fg = '#1a1b26', bg = '#61afef', gui = 'bold' },      -- NORMAL: blue
                i = { fg = '#1a1b26', bg = '#98c379', gui = 'bold' },      -- INSERT: green
                v = { fg = '#1a1b26', bg = '#e06c75', gui = 'bold' },      -- VISUAL: red
                V = { fg = '#1a1b26', bg = '#e06c75', gui = 'bold' },      -- VISUAL LINE: red
                ['\22'] = { fg = '#1a1b26', bg = '#e06c75', gui = 'bold' },-- VISUAL BLOCK: red
                c = { fg = '#1a1b26', bg = '#e5c07b', gui = 'bold' },      -- COMMAND: yellow
                R = { fg = '#1a1b26', bg = '#c678dd', gui = 'bold' },      -- REPLACE: magenta
                s = { fg = '#1a1b26', bg = '#56b6c2', gui = 'bold' },      -- SELECT: cyan
                S = { fg = '#1a1b26', bg = '#56b6c2', gui = 'bold' },      -- SELECT LINE: cyan
                ['\19'] = { fg = '#1a1b26', bg = '#56b6c2', gui = 'bold' },-- SELECT BLOCK: cyan
                t = { fg = '#1a1b26', bg = '#d19a66', gui = 'bold' },      -- TERMINAL: orange
              }
              local mode = vim.fn.mode()
              return mode_color[mode] or { fg = '#1a1b26', bg = '#61afef', gui = 'bold' }
            end,
          }
        },
        lualine_b = {
          { 'branch', icon = '' },
          { 'diff' },
          { 'diagnostics', sources = { 'nvim_diagnostic' }, symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } },
        },
        lualine_c = {
          { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 } },
          { 'filename', path = 1, symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]', newfile = '[New]' } },
          { function() return vim.v.this_session ~= '' and ' ' .. vim.fn.fnamemodify(vim.v.this_session, ':t:r') or '' end, cond = function() return vim.v.this_session ~= '' end },
        },
        lualine_x = {
          { function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients > 0 then
                return ' ' .. clients[1].name
              end
              return ''
            end, icon = '', color = { fg = '#98be65' } },
          'encoding',
          { 'fileformat', symbols = { unix = '', dos = '', mac = '' } },
          'filetype',
        },
        lualine_y = {
          'progress',
          { function()
              if vim.v.hlsearch == 1 and vim.fn.searchcount then
                local sc = vim.fn.searchcount({ maxcount = 999, timeout = 50 })
                if sc.total and sc.total > 0 then
                  return string.format(' %d/%d', sc.current, sc.total)
                end
              end
              return ''
            end },
        },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { 'buffers' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' },
      },
      winbar = {},
      inactive_winbar = {},
      extensions = { 'neo-tree', 'lazy', 'trouble', 'toggleterm', 'nvim-dap-ui' },
    })

    -- Make lualine highlights work well with transparency
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local normal_bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
        if normal_bg then
          vim.api.nvim_set_hl(0, "lualine_c_normal", { bg = normal_bg, fg = "#abb2bf" })
          vim.api.nvim_set_hl(0, "lualine_c_inactive", { bg = normal_bg, fg = "#6f737b" })
        end
      end,
    })

    -- Force lualine mode highlights for all modes (fixes invisible mode text)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local mode_hl = {
          n = { bg = "#61afef" },      -- NORMAL: blue
          i = { bg = "#98c379" },      -- INSERT: green
          v = { bg = "#e06c75" },      -- VISUAL: red
          c = { bg = "#e5c07b" },      -- COMMAND: yellow
          R = { bg = "#c678dd" },      -- REPLACE: magenta
          s = { bg = "#56b6c2" },      -- SELECT: cyan
          t = { bg = "#d19a66" },      -- TERMINAL: orange
        }
        local mode_map = {
          n = "normal", i = "insert", v = "visual", c = "command",
          R = "replace", s = "select", t = "terminal"
        }
        for mode, color in pairs(mode_hl) do
          local group = "lualine_a_" .. mode_map[mode]
          if group then
            vim.api.nvim_set_hl(0, group, { fg = "#1a1b26", bg = color.bg, bold = true })
          end
        end
      end,
    })
  end,
}