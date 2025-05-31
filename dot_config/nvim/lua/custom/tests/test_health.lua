local health_modules = {
  "nvim",
  "lspconfig",
  "mason",
  "nvim-treesitter",
  "telescope",
  "gitsigns",
  "which-key",
  "plenary",
}

describe(":checkhealth", function()
  for _, mod in ipairs(health_modules) do
    it("runs checkhealth for " .. mod, function()
      assert.has_no.errors(function()
        vim.cmd("checkhealth " .. mod)
      end)
    end)
  end
end) 