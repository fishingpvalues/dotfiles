-- persistence.nvim: Fast, reliable session management
return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {
    dir = vim.fn.stdpath("state") .. "/sessions/",
    options = { "buffers", "curdir", "tabpages", "winsize" },
    pre_save = nil,
  },
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session for current dir" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session" },
  },
} 