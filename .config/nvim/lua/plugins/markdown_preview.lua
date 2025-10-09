-- markdown-preview.nvim: Fast markdown preview in browser
return {
  "iamcco/markdown-preview.nvim",
  build = function() vim.fn["mkdp#util#install"]() end,
  ft = { "markdown" },
  cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
  keys = {
    { "<leader>mp", ":MarkdownPreview<CR>", desc = "Open Markdown Preview" },
    { "<leader>ms", ":MarkdownPreviewStop<CR>", desc = "Stop Markdown Preview" },
  },
  config = function()
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_refresh_slow = 0
    vim.g.mkdp_command_for_global = 0
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_open_ip = ""
    vim.g.mkdp_browser = ""
    vim.g.mkdp_echo_preview_url = 1
    vim.g.mkdp_browserfunc = ""
    vim.g.mkdp_port = ""
    vim.g.mkdp_page_title = "Preview ${name}"
    vim.g.mkdp_filetypes = { "markdown" }
  end,
} 