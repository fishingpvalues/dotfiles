local commands = {
  "TransparentEnable",
  "TransparentDisable",
  "DiffviewOpen",
  "DiffviewClose",
  "DiffviewFileHistory",
  "TodoTelescope",
  "PickMe",
  "Gitsigns",
  "LazyGit",
  "Telescope",
}

describe("user commands", function()
  local user_cmds = vim.api.nvim_get_commands({})
  for _, cmd in ipairs(commands) do
    it("should have command " .. cmd, function()
      assert.is_not_nil(user_cmds[cmd], "Command " .. cmd .. " not found")
    end)
  end
end) 