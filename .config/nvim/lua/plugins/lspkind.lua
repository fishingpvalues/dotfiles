-- LSP Kind configuration for completion menu icons
return {
  "onsails/lspkind.nvim",
  lazy = true,
  config = function()
    require("lspkind").init({
      mode = "symbol_text",
      preset = "codicons",
      symbol_map = {
        Text = "󰉿", Method = "󰆧", Function = "󰊕", Field = "󰜢", Variable = "󰀫", Class = "󰠱",
        Property = "󰜢", Unit = "󰑭", Value = "󰎠", Keyword = "󰌋", Color = "󰏘", File = "󰈙",
        Reference = "󰈇", Folder = "󰉋", Constant = "󰏿", Struct = "󰙅", Operator = "󰆕",
      },
    })
  end,
} 