-- Trouble plugin configuration (diagnostics UI)
return {
  "folke/trouble.nvim",
  cmd = { "TroubleToggle", "Trouble" },
  opts = {
    position = "bottom",
    height = 10,
    icons = true,
    mode = "workspace_diagnostics",
    group = true,
    padding = true,
    indent_lines = true,
    auto_preview = true,
    auto_jump = { "lsp_definitions" },
    use_diagnostic_signs = false,
  },
  keys = {
    { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
    { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
  },
  config = function(_, opts)
    require("trouble").setup(opts)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "TroubleNormal", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "TroubleText", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "TroubleHeader", { fg = "#61afef", bold = true })
        vim.api.nvim_set_hl(0, "TroubleIndent", { fg = "#4b5263" })
      end,
    })
  end,
} 