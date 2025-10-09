-- refactoring.nvim: The Refactoring library based off the Refactoring book by Martin Fowler
-- SOTA configuration by ThePrimeagen (2025)
return {
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  lazy = false,
  config = function()
    require("refactoring").setup({
      -- Prompt for return type on extract function
      prompt_func_return_type = {
        go = true,
        java = true,
        cpp = true,
        c = true,
        h = true,
        hpp = true,
        cxx = true,
      },
      -- Prompt for function parameters
      prompt_func_param_type = {
        go = true,
        java = true,
        cpp = true,
        c = true,
        h = true,
        hpp = true,
        cxx = true,
      },
      -- Printf statement configuration for each language
      printf_statements = {},
      -- Print var statement configuration for each language
      print_var_statements = {},
      -- Show success message after refactor
      show_success_message = true,
    })

    -- Refactoring keymaps
    -- Extract function supports only visual mode
    vim.keymap.set("x", "<leader>re", function()
      require("refactoring").refactor("Extract Function")
    end, { desc = "Extract Function" })
    vim.keymap.set("x", "<leader>rf", function()
      require("refactoring").refactor("Extract Function To File")
    end, { desc = "Extract Function To File" })

    -- Extract variable supports only visual mode
    vim.keymap.set("x", "<leader>rv", function()
      require("refactoring").refactor("Extract Variable")
    end, { desc = "Extract Variable" })

    -- Inline func supports only normal mode
    vim.keymap.set("n", "<leader>rI", function()
      require("refactoring").refactor("Inline Function")
    end, { desc = "Inline Function" })

    -- Inline var supports both normal and visual mode
    vim.keymap.set({ "n", "x" }, "<leader>ri", function()
      require("refactoring").refactor("Inline Variable")
    end, { desc = "Inline Variable" })

    -- Extract block supports only normal mode
    vim.keymap.set("n", "<leader>rb", function()
      require("refactoring").refactor("Extract Block")
    end, { desc = "Extract Block" })
    vim.keymap.set("n", "<leader>rbf", function()
      require("refactoring").refactor("Extract Block To File")
    end, { desc = "Extract Block To File" })

    -- Prompt for a refactor to apply when the remap is triggered
    vim.keymap.set({ "n", "x" }, "<leader>rr", function()
      require("refactoring").select_refactor({
        show_success_message = true,
      })
    end, { desc = "Select Refactor" })

    -- Debug operations
    -- Print var
    vim.keymap.set({ "x", "n" }, "<leader>rv", function()
      require("refactoring").debug.print_var()
    end, { desc = "Debug: Print var" })

    -- Print var below
    vim.keymap.set("n", "<leader>rc", function()
      require("refactoring").debug.cleanup({})
    end, { desc = "Debug: Cleanup" })

    -- Supports both visual and normal mode
    vim.keymap.set("n", "<leader>rp", function()
      require("refactoring").debug.printf({ below = false })
    end, { desc = "Debug: Printf" })
  end,
}
