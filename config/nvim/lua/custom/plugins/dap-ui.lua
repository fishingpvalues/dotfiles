-- DAP UI configuration with transparency support
return {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    
    -- Configure DAP UI with transparency-compatible settings
    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      -- Layouts define sections of the screen to place windows.
      -- Position can be "left", "right", "top" or "bottom".
      -- Make sure these work well with transparency
      layouts = {
        {
          elements = {
            -- Elements can be strings or table with id and size keys.
            { id = "scopes", size = 0.25 },
            "breakpoints",
            "stacks",
            "watches",
          },
          size = 40, -- 40 columns
          position = "left",
        },
        {
          elements = {
            "repl",
            "console",
          },
          size = 0.25, -- 25% of total lines
          position = "bottom",
        },
      },
      controls = {
        -- Requires Neovim nightly (or 0.8 when released)
        enabled = true,
        -- Display controls in this element
        element = "repl",
        icons = {
          pause = "",
          play = "",
          step_into = "",
          step_over = "",
          step_out = "",
          step_back = "",
          run_last = "↻",
          terminate = "□",
        },
      },
      floating = {
        max_height = nil, -- These can be integers or a float between 0 and 1.
        max_width = nil, -- Floats will be treated as percentage of your screen.
        border = "single", -- Border style. Can be "single", "double" or "rounded"
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      windows = { indent = 1 },
      render = { 
        max_type_length = nil, -- Can be integer or nil.
        max_value_lines = 100, -- Can be integer or nil.
      }
    })

    -- Add transparency-compatible colors for DAP UI
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- Ensure the DAP UI elements work well with transparency
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

    -- Setup DAP events to open and close UI automatically
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Add keymaps for debugging
    -- (Removed: now in keymaps.lua)
  end,
}