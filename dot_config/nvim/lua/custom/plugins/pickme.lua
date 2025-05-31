-- PickMe alternative using mini.pick for unified menu interface with transparency support
return {
  "echasnovski/mini.pick",
  version = false,
  dependencies = {
    "echasnovski/mini.extra",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local mini_pick = require("mini.pick")
    local mini_extra = require("mini.extra")
    
    mini_pick.setup({
      -- Configure with transparency-friendly options
      window = {
        config = function()
          local columns = vim.o.columns
          local lines = vim.o.lines
          local width = math.floor(columns * 0.8)
          local height = math.floor(lines * 0.4)
          return {
            border = "rounded",
            width = width,
            height = height,
          }
        end,
      },
      -- Customize appearance
      options = {
        use_cache = true,
      },
    })

    -- Create commands that mimic original PickMe functionality
    vim.api.nvim_create_user_command("PickMe", function()
      -- Create a custom picker with theme options
      mini_pick.builtin.cli({
        source = {
          items = {
            { text = "Toggle Line Numbers", value = "toggle_line_numbers" },
            { text = "Theme: GitHub Dark", value = "github_dark" },
            { text = "Theme: GitHub Light", value = "github_light" },
          },
          name = "Theme Options",
        },
        mappings = {
          choose = "<CR>",
          cancel = "<Esc>",
        },
        choose = function(item)
          if item.value == "toggle_line_numbers" then
            vim.o.number = not vim.o.number
          elseif item.value == "github_dark" then
            vim.cmd("colorscheme github_dark")
          elseif item.value == "github_light" then
            vim.cmd("colorscheme github_light")
          end
        end,
      })
    end, {})

    -- Create keymapping for quick access
    -- (Removed: now in keymaps.lua)
  end,
}