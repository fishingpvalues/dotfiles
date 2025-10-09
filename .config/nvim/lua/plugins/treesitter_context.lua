-- nvim-treesitter-context: Sticky context window
return {
  "nvim-treesitter/nvim-treesitter-context",
  event = "BufReadPre",
  config = function()
    require("treesitter-context").setup {
      enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
      max_lines = 3,            -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0,    -- Minimum editor window height to enable context. 0 = always enabled.
      line_numbers = true,      -- Show line numbers
      multiline_threshold = 20, -- Maximum number of lines to collapse for a single context line
      trim_scope = 'outer',     -- Which context lines to discard if max_lines is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
      separator = nil,          -- Separator between context and content. nil = no separator
      zindex = 20,              -- The Z-index of the context window
      on_attach = nil,          -- (fun(buf: integer): boolean) return false to disable attaching
    }
  end,
} 