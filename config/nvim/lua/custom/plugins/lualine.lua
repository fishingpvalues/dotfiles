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

    local function lsp_status()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
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
        theme = 'codedark',
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
        lualine_a = { { 'mode', icon = '' } },
        lualine_b = {
          { 'branch', icon = '', cond = function() return vim.b.gitsigns_status_dict ~= nil end },
          { 'diff', cond = function() local g = vim.b.gitsigns_status_dict; return g and (g.added > 0 or g.changed > 0 or g.removed > 0) end },
          { 'diagnostics', cond = function() return vim.diagnostic and #vim.diagnostic.get(0) > 0 end },
        },
        lualine_c = {
          { filetype_icon, padding = { left = 0, right = 0 } },
          { short_path },
          { readonly_modified, padding = { left = 0, right = 1 } },
          { session_name, cond = function() return vim.v.this_session ~= '' end },
        },
        lualine_x = {
          { conda_env },
          { lsp_status },
          { 'encoding' },
          { 'fileformat' },
          { 'filetype' },
        },
        lualine_y = {
          { 'progress' },
          { search_count },
        },
        lualine_z = { { 'location' } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
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