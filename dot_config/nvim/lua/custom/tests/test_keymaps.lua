local keymaps = {
  { mode = "n", lhs = "<leader>tt", desc = "Toggle transparency" },
  { mode = "n", lhs = "<leader>hs", desc = "Git stage hunk" },
  { mode = "n", lhs = "<leader>sf", desc = "Search Files" },
  { mode = "n", lhs = "<leader>tb", desc = "Toggle git blame line" },
  { mode = "n", lhs = "<leader>xx", desc = "Document Diagnostics (Trouble)" },
  { mode = "n", lhs = "<leader>gd", desc = "Open Diffview" },
  { mode = "n", lhs = "<leader>p", desc = "Open PickMe Menu" },
  { mode = "n", lhs = "<leader>du", desc = "Toggle Debug UI" },
}

describe("keymaps", function()
  for _, km in ipairs(keymaps) do
    it("should have keymap " .. km.lhs .. " in mode " .. km.mode, function()
      local found = false
      for _, map in ipairs(vim.api.nvim_get_keymap(km.mode)) do
        if map.lhs == km.lhs then
          found = true
          break
        end
      end
      assert.is_true(found, "Keymap " .. km.lhs .. " not found in mode " .. km.mode)
    end)
  end
end) 