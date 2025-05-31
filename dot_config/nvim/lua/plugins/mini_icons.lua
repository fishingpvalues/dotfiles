-- File icons and dev icons for mini.nvim
return {
  'echasnovski/mini.nvim',
  config = function()
    -- Add dev icons support
    require('mini.icons').setup({
      -- Customize icons and groups based on preferences
      groups = {
        -- Default icons for various file types
        file_type = {
          default = { icon = "📄" },
          lua = { icon = "🌙" },
          python = { icon = "🐍" },
          javascript = { icon = "JS", highlight = "Yellow" },
          typescript = { icon = "TS", highlight = "Blue" },
          html = { icon = "🌐" },
          css = { icon = "🎨" },
          json = { icon = "{}" },
          markdown = { icon = "📝" },
          -- Add more file types as needed
        },
        -- Icons for version control status
        git = {
          added = { icon = "+", highlight = "GitSignsAdd" },
          deleted = { icon = "-", highlight = "GitSignsDelete" },
          modified = { icon = "~", highlight = "GitSignsChange" },
          renamed = { icon = "➜", highlight = "GitSignsChange" },
        },
        -- UI component icons
        ui = {
          folder = { icon = "📁" },
          folder_open = { icon = "📂" },
          error = { icon = "❌" },
          warning = { icon = "⚠️" },
          info = { icon = "ℹ️" },
          hint = { icon = "💡" },
        },
        -- Apply transparency to icons if enabled
        apply_transparency = vim.g.transparent_enabled,
      },
    })
  end,
}