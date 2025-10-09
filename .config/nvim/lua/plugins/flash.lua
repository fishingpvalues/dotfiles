-- flash.nvim: Navigate your code with search labels, enhanced character motions and Treesitter integration
-- SOTA configuration for 2025
return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- Labels to use for search results
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      -- Search behavior configuration
      multi_window = true,
      forward = true,
      wrap = true,
      -- Can be "exact", "search" (regex), or "fuzzy"
      mode = "exact",
      -- Behave like `incsearch`
      incremental = false,
    },
    jump = {
      -- Save location in the jumplist
      jumplist = true,
      -- Jump position
      pos = "start",
      -- Add pattern to search history
      history = false,
      -- Add pattern to search register
      register = false,
      -- Clear highlight after jump
      nohlsearch = false,
      -- Automatically jump when there is only one match
      autojump = false,
    },
    label = {
      -- Allow uppercase labels
      uppercase = true,
      -- Add any labels with the correct case here that you want to exclude from auto-generating
      exclude = "",
      -- Add a label for the first match in the current window
      current = true,
      -- Show the label after the match
      after = true,
      -- Show the label before the match
      before = false,
      -- Position of the label relative to the match
      style = "overlay",
      -- Flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default, only lowercase labels are re-used.
      reuse = "lowercase",
      -- For the current window, label targets closer to the cursor first
      distance = true,
    },
    highlight = {
      -- Show a backdrop with hl FlashBackdrop
      backdrop = true,
      -- Highlight matches
      matches = true,
      -- Extmark priority
      priority = 5000,
      -- Use label groups to improve performance
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    -- Action to perform when picking a label
    action = nil,
    -- Initial pattern to use when opening flash
    pattern = "",
    -- When `true`, flash will try to continue the last search
    continue = false,
    -- You can override the default options for a specific mode
    modes = {
      -- Options used when flash is activated through `f`, `F`, `t`, `T`, `;` and `,` motions
      char = {
        enabled = true,
        -- Dynamic configuration for ftFT motions
        config = function(opts)
          -- Autohide flash when in operator-pending mode
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

          -- Disable jump labels when not after an operator, only for ftFT
          opts.jump_labels = opts.jump_labels and vim.v.count == 0

          -- Show jump labels only in operator-pending mode
          -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
        end,
        -- Hide after jump when not using jump labels
        autohide = false,
        -- Show jump labels
        jump_labels = false,
        -- Set to `false` to use the current line only
        multi_line = true,
        -- When using jump labels, don't use these keys
        -- This allows using those keys directly after the motion
        label = { exclude = "hjkliardc" },
        -- By default all keymaps are enabled, but you can disable some of them
        keys = { "f", "F", "t", "T", ";", "," },
        -- The direction for `prev` and `next` is determined by the motion
        -- For motion `f`, `prev` will go left and `next` will go right
        char_actions = function(motion)
          return {
            [";"] = "next", -- set to `right` to always go right
            [","] = "prev", -- set to `left` to always go left
            -- clever-f style
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
            -- jump2d style: same case goes next, opposite case goes prev
            -- [motion] = "next",
            -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = { register = false },
      },
      -- Options used for Treesitter selections
      -- `require("flash").treesitter()`
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },
      -- Options used for remote flash
      remote = {
        remote_op = { restore = true, motion = true },
      },
      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },
    },
    -- Options for the floating window that shows the prompt
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1,
        height = 1,
        row = -1,
        col = 0,
        zindex = 1000,
      },
    },
  },
  -- Keybindings
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },
}
