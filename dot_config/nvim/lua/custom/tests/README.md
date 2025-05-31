# Neovim Config Testing with Plenary.nvim

This directory contains **Neovim-specific tests** for your configuration, using [plenary.nvim](https://github.com/nvim-lua/plenary.nvim).

- These tests are for plugins, keymaps, and Neovim Lua config only.
- They are run automatically as part of the full system test suite (see the main [README.md](../../../../../README.md) for general test instructions), but can also be run directly inside Neovim for development.

## What is tested?

- Each plugin module in `custom/plugins/` and `plugins/` is checked to ensure it loads without error.
- You can add more tests for keymaps, config options, or plugin-specific features.

## How to Run the Tests (Neovim only)

1. **Install plenary.nvim** (if not already):
   - Add to your plugin manager:

     ```lua
     { "nvim-lua/plenary.nvim" }
     ```

2. **Run the tests from your Neovim config root:**

   ```sh
   nvim --headless -c "PlenaryBustedDirectory lua/custom/tests/ {minimal_init = 'lua/minimal_init.lua'}"
   ```

   - You can create a `lua/minimal_init.lua` to load only the plugins/configs you want for isolated testing.
   - If you want to test with your full config, you can omit the `minimal_init` argument or point it to your main `init.lua`.

3. **Integration with System Tests:**
   - These tests are also run automatically as part of the full system test suite using act (see the main [README.md](../../../../../README.md)).

## Adding More Tests

- Create new files in this folder (e.g., `test_gitsigns.lua`).
- Use Plenary's [busted](https://olivinelabs.com/busted/) style:

  ```lua
  describe("gitsigns", function()
    it("should be loaded", function()
      local gitsigns = require("gitsigns")
      assert.are.same(type(gitsigns), "table")
    end)
  end)
  ```

- See [plenary.nvim test docs](https://github.com/nvim-lua/plenary.nvim#plenarytest) for more examples.

## Why Test?

- Catch errors and missing dependencies early.
- Ensure all plugins and configs load as expected after updates.
- Make your Neovim setup more robust and maintainable.
