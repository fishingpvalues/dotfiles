-- SOTA configuration for hardtime.nvim
return {
  "m4xshen/hardtime.nvim",
  event = "VeryLazy",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    max_time = 1000,
    max_count = 3,
    disable_mouse = true,
    hint = true,
    notification = true,
    timeout = 3000,
    allow_different_key = true,
    enabled = true,
    restriction_mode = "block",
    -- Example: disable <Up> and <Down> in normal/visual, but allow <Left>/<Right>
    disabled_keys = {
      ["<Up>"] = { "n", "x" },
      ["<Down>"] = { "n", "x" },
      ["<Left>"] = false,
      ["<Right>"] = false,
    },
    disabled_filetypes = {
      lazy = true, -- disable in lazy.nvim UI
      ["dapui*"] = true, -- disable in dapui
      NvimTree = true,
      Trouble = true,
      alpha = true,
      dashboard = true,
    },
    -- Example custom hint
    hints = {
      ["k%^"] = {
        message = function()
          return "Use - instead of k^"
        end,
        length = 2,
      },
      ["d[tTfF].i"] = {
        message = function(keys)
          return "Use c" .. keys:sub(2, 3) .. " instead of " .. keys
        end,
        length = 4,
      },
    },
    -- Use nvim-notify for notifications if available
    callback = function(text)
      local ok, notify = pcall(require, "notify")
      if ok then
        notify(text, vim.log.levels.WARN, { title = "Hardtime" })
      else
        vim.notify(text, vim.log.levels.WARN, { title = "Hardtime" })
      end
    end,
    -- UI customization for report
    ui = {
      border = "rounded",
      width = 60,
      height = 20,
      title = "Hardtime Report",
    },
  },
  config = function(_, opts)
    require("hardtime").setup(opts)
    -- Transparency-friendly highlight for Hardtime popups
    vim.api.nvim_set_hl(0, "HardtimePopup", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "HardtimeBorder", { link = "FloatBorder" })
  end,
} 