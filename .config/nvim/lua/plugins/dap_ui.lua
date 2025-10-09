-- DAP UI configuration
return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o", remove = "d", edit = "e", repl = "r", toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 }, "breakpoints", "stacks", "watches",
          },
          size = 40, position = "left",
        },
        {
          elements = { "repl", "console" },
          size = 0.25, position = "bottom",
        },
      },
      controls = {
        enabled = true, element = "repl",
        icons = { run_last = "↻", terminate = "□" },
      },
      floating = {
        max_height = nil, max_width = nil, border = "single",
        mappings = { close = { "q", "<Esc>" } },
      },
      windows = { indent = 1 },
      render = { max_value_lines = 100 },
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "DapUIScope", { fg = "#61afef" })
        vim.api.nvim_set_hl(0, "DapUIType", { fg = "#d19a66" })
        vim.api.nvim_set_hl(0, "DapUIValue", { fg = "#98c379" })
        vim.api.nvim_set_hl(0, "DapUIModifiedValue", { fg = "#e5c07b", bold = true })
        vim.api.nvim_set_hl(0, "DapUIDecoration", { fg = "#61afef" })
        vim.api.nvim_set_hl(0, "DapUIThread", { fg = "#98c379" })
        vim.api.nvim_set_hl(0, "DapUIStoppedThread", { fg = "#e5c07b" })
        vim.api.nvim_set_hl(0, "DapUISource", { fg = "#d19a66" })
        vim.api.nvim_set_hl(0, "DapUILineNumber", { fg = "#61afef" })
        vim.api.nvim_set_hl(0, "DapUIFloatBorder", { fg = "#61afef" })
        vim.api.nvim_set_hl(0, "DapUIWatchesEmpty", { fg = "#e06c75" })
        vim.api.nvim_set_hl(0, "DapUIWatchesValue", { fg = "#98c379" })
        vim.api.nvim_set_hl(0, "DapUIWatchesError", { fg = "#e06c75" })
        vim.api.nvim_set_hl(0, "DapUIBreakpointsPath", { fg = "#61afef" })
        vim.api.nvim_set_hl(0, "DapUIBreakpointsInfo", { fg = "#98c379" })
        vim.api.nvim_set_hl(0, "DapUIBreakpointsCurrentLine", { fg = "#98c379", bold = true })
      end,
    })
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  end,
} 