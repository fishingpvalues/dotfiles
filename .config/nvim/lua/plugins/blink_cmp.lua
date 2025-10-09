-- blink.cmp: SOTA async completion engine for Neovim
return {
  "Saghen/blink.cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "rafamadriz/friendly-snippets",
    {
      "mikavilpas/blink-ripgrep.nvim",
      version = "*",
    },
  },
  version = "1.*",
  opts = {
    keymap = { preset = "default" },
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = { documentation = { auto_show = false } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
      providers = {
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          -- The opts should be at the provider level, not nested
          -- Use git grep if available, fallback to ripgrep
          search_backend = "gitgrep-or-ripgrep",
          -- Only trigger on 3+ characters to avoid performance issues
          prefix_min_len = 3,
          -- Exclude large files
          max_filesize = "1M",
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
  opts_extend = { "sources.default" },
  config = function(_, opts)
    require("blink.cmp").setup(opts)
  end,
} 