-- Rainbow CSV with transparency-friendly colors
return {
  "cameron-wags/rainbow_csv.nvim",
  config = true,
  ft = {
    "csv",
    "tsv",
    "csv_semicolon",
    "csv_whitespace",
    "csv_pipe",
    "rfc_csv",
    "rfc_semicolon"
  },
  cmd = {
    "RainbowDelim",
    "RainbowDelimSimple",
    "RainbowDelimQuoted",
    "RainbowMultiDelim"
  },
  init = function()
    -- Register a colorscheme hook to ensure our Rainbow CSV highlights work with transparency
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        -- Create rainbow colors that work well with transparency
        vim.api.nvim_set_hl(0, "rainbowcol1", { fg = "#e06c75", bold = true })
        vim.api.nvim_set_hl(0, "rainbowcol2", { fg = "#e5c07b", bold = true })
        vim.api.nvim_set_hl(0, "rainbowcol3", { fg = "#98c379", bold = true })
        vim.api.nvim_set_hl(0, "rainbowcol4", { fg = "#61afef", bold = true })
        vim.api.nvim_set_hl(0, "rainbowcol5", { fg = "#c678dd", bold = true })
        vim.api.nvim_set_hl(0, "rainbowcol6", { fg = "#56b6c2", bold = true })
        vim.api.nvim_set_hl(0, "rainbowcol7", { fg = "#d19a66", bold = true })
      end,
    })
  end,
} 