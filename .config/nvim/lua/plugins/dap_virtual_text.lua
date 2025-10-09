-- DAP Virtual Text configuration
return {
  "theHamsta/nvim-dap-virtual-text",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    enabled = true,
    enabled_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    virt_text_pos = "eol",
    all_frames = false,
    virt_lines = false,
    virt_text_win_col = nil,
    display_callback = function(variable, buf, stackframe, node, options)
      if options.virt_text_pos == "inline" then
        return { "", variable.name .. " = " .. variable.value }
      else
        return { " " .. variable.name .. " = " .. variable.value, "" }
      end
    end,
  },
  config = function(_, opts)
    require("nvim-dap-virtual-text").setup(opts)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "NvimDapVirtualText", { fg = "#98c379", bold = true })
        vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { fg = "#e5c07b", bold = true })
        vim.api.nvim_set_hl(0, "NvimDapVirtualTextError", { fg = "#e06c75", bold = true })
      end,
    })
  end,
} 