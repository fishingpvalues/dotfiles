-- Diffview.nvim configuration for Git diffs with transparency
return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles",
    "DiffviewFileHistory", "DiffviewRefresh"
  },
  opts = {
    diff_binaries = false,
    enhanced_diff_hl = true,
    use_icons = true,
    icons = {
      folder_closed = "",
      folder_open = "",
    },
    signs = {
      fold_closed = "",
      fold_open = "",
      done = "✓",
    },
    view = {
      merge_tool = {
        layout = "diff3_mixed",
        disable_diagnostics = true,
      },
    },
    file_panel = {
      win_config = {
        position = "left",
        width = 35,
        height = 16,
      },
    },
    file_history_panel = {
      win_config = {
        position = "bottom",
        height = 16,
      },
      log_options = {
        git = {
          single_file = {
            max_count = 256,
            follow = true,
          },
          multi_file = {
            max_count = 128,
          },
        },
      },
    },
    hooks = {
      -- Make UI elements compatible with transparency
      diff_buf_read = function(bufnr)
        -- Fix for transparency when viewing diffs
        vim.opt_local.winblend = 0
      end,
      view_opened = function()
        -- Set highlight groups for better visibility with transparency
        vim.cmd([[
          hi! link DiffviewDiffAddAsDelete DiffDelete
          hi! link DiffviewDiffDelete DiffDelete
        ]])
      end,
    },
  },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Open Diffview" },
    { "<leader>gD", "<cmd>DiffviewClose<CR>", desc = "Close Diffview" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "File History (Current)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<CR>", desc = "File History (Repository)" },
  },
}