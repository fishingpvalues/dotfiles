-- Module for setting up NavIC winbar for code navigation

local M = {}

function M.setup()
  -- Only setup if navic is available
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  -- Create an autocommand group for winbar
  local augroup = vim.api.nvim_create_augroup("NavicWinbar", { clear = true })
  
  -- Update winbar with navic location
  vim.api.nvim_create_autocmd({"BufWinEnter", "CursorHold", "CursorMoved"}, {
    group = augroup,
    callback = function()
      -- Only show winbar in appropriate buffers
      local bufnr = vim.api.nvim_get_current_buf()
      local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
      local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
      
      -- Exclude special buffers and filetypes
      local excluded_filetypes = {
        "dashboard", "alpha", "neo-tree", "Trouble", "lazy", "mason", "toggleterm",
        "help", "TelescopePrompt"
      }
      
      local show_winbar = buftype == "" and not vim.tbl_contains(excluded_filetypes, filetype)
      
      if show_winbar then
        -- Show winbar with file path and navic location
        local filename = vim.fn.expand("%:t")
        if filename == "" then
          filename = "[No Name]"
        end
        
        if navic.is_available() then
          vim.opt_local.winbar = "%#NavicIconsFile# " .. filename .. " %* " .. 
                               "%{%v:lua.require'nvim-navic'.get_location()%}"
        else
          vim.opt_local.winbar = "%#NavicIconsFile# " .. filename .. " %*"
        end
      else
        -- Clear winbar for excluded buffers
        vim.opt_local.winbar = nil
      end
    end,
  })
  
  -- Create highlight groups for transparent winbar
  vim.cmd([[
    hi! link NavicIconsFile Special
    hi! link NavicText Normal
    hi! link NavicSeparator NonText
  ]])
end

return M