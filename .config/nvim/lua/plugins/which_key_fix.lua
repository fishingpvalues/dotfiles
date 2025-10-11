-- Configuration for which-key with transparency support

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = true,
        motions = true,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      border = "rounded", -- none, single, double, shadow, rounded
      position = "bottom", -- bottom, top
      -- margin removed - not supported in newer which-key versions
      -- Use padding instead for spacing control
      padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
    },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = "➜", -- symbol used between a key and its label
      group = "+", -- symbol prepended to a group
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    -- Register SOTA and lspsaga keymaps for discoverability
    wk.add({
      { "<leader>e", group = "explorer" },
      { "<leader>ee", desc = "Toggle file explorer" },
      { "<leader>fe", desc = "Find file in explorer" },
      { "<leader>t", group = "terminal" },
      { "<leader>tt", desc = "Toggle horizontal terminal" },
      { "<leader>tf", desc = "Toggle floating terminal" },
      { "<leader>q", group = "session" },
      { "<leader>qs", desc = "Restore session for current dir" },
      { "<leader>ql", desc = "Restore last session" },
      { "<leader>qd", desc = "Don't save session" },
      { "<leader>m", group = "markdown" },
      { "<leader>mp", desc = "Open Markdown Preview" },
      { "<leader>ms", desc = "Stop Markdown Preview" },
      { "<leader>c", group = "code" },
      { "<leader>ca", desc = "LSP Code Action (lspsaga)" },
      { "<leader>rn", desc = "LSP Rename (lspsaga)" },
      { "<leader>o", desc = "LSP Outline (lspsaga)" },
      { "<leader>f", group = "find" },
      { "<leader>fd", desc = "LSP Finder (lspsaga)" },
      { "<leader>s", group = "search/show" },
      { "<leader>sd", desc = "Show Line Diagnostics (lspsaga)" },
      { "K", desc = "LSP Hover Doc (lspsaga)" },
      { "<leader>n", desc = "Toggle line numbers" },
      { "<leader>w", desc = "Toggle word wrap" },
      { "<leader>d", group = "debug" },
      { "<F5>", desc = "Debug: Start/Continue" },
      { "<F1>", desc = "Debug: Step Into" },
      { "<F2>", desc = "Debug: Step Over" },
      { "<F3>", desc = "Debug: Step Out" },
      { "<F7>", desc = "Debug: Toggle DAP UI" },
      { "<leader>b", desc = "Debug: Toggle Breakpoint" },
      { "<leader>B", desc = "Debug: Set Conditional Breakpoint" },
      { "<leader>db", desc = "Persistent: Toggle Breakpoint" },
      { "<leader>dB", desc = "Persistent: Set Conditional Breakpoint" },
      { "<leader>dc", desc = "Persistent: Clear All Breakpoints" },
      { "<leader>S", desc = "Open Spectre (Project Search/Replace)" },
      { "<leader>fy", desc = "Yazi: Open at current file" },
      { "<C-Up>", desc = "Yazi: Toggle file manager" },
      { "\\", desc = "Neo-tree: Reveal/Close" },
      { "zR", desc = "UFO: Open all folds" },
      { "zM", desc = "UFO: Close all folds" },
      { "<leader>g", group = "golang" },
      { "<leader>gt", desc = "Go: Run tests" },
      { "<leader>gT", desc = "Go: Run test file" },
      { "<leader>gc", desc = "Go: Test coverage" },
      { "<leader>gd", desc = "Go: Debug test" },
      { "<leader>gb", desc = "Go: Build" },
      { "<leader>gr", desc = "Go: Run" },
      { "<leader>gi", desc = "Go: Install deps" },
      { "<leader>gm", desc = "Go: Tidy modules" },
      { "<leader>gf", desc = "Go: Format" },
      { "<leader>gl", desc = "Go: Lint" },
      { "<leader>gv", desc = "Go: Vet" },

      -- Flash.nvim navigation
      { "s", desc = "Flash: Jump", mode = { "n", "x", "o" } },
      { "S", desc = "Flash: Treesitter", mode = { "n", "x", "o" } },
      { "r", desc = "Flash: Remote", mode = "o" },
      { "R", desc = "Flash: Treesitter Search", mode = { "o", "x" } },

      -- Neotest
      { "<leader>t", group = "test" },
      { "<leader>tt", desc = "Test: Run File" },
      { "<leader>tT", desc = "Test: Run All Files" },
      { "<leader>tr", desc = "Test: Run Nearest" },
      { "<leader>tl", desc = "Test: Run Last" },
      { "<leader>ts", desc = "Test: Toggle Summary" },
      { "<leader>to", desc = "Test: Show Output" },
      { "<leader>tO", desc = "Test: Toggle Output Panel" },
      { "<leader>tS", desc = "Test: Stop" },
      { "<leader>td", desc = "Test: Debug Nearest" },
      { "<leader>tw", desc = "Test: Toggle Watch" },

      -- Refactoring.nvim
      { "<leader>r", group = "refactor/rust" },
      { "<leader>re", desc = "Refactor: Extract Function", mode = "x" },
      { "<leader>rf", desc = "Refactor: Extract Function To File", mode = "x" },
      { "<leader>rv", desc = "Refactor: Extract Variable", mode = "x" },
      { "<leader>rI", desc = "Refactor: Inline Function", mode = "n" },
      { "<leader>ri", desc = "Refactor: Inline Variable", mode = { "n", "x" } },
      { "<leader>rb", desc = "Refactor: Extract Block", mode = "n" },
      { "<leader>rbf", desc = "Refactor: Extract Block To File", mode = "n" },
      { "<leader>rr", desc = "Refactor: Select Refactor", mode = { "n", "x" } },
      { "<leader>rc", desc = "Refactor: Debug Cleanup", mode = "n" },
      { "<leader>rp", desc = "Refactor: Debug Printf", mode = "n" },

      -- Rustaceanvim (overlaps with refactor prefix)
      { "<leader>rh", desc = "Rust: Hover Actions", mode = "n" },
      { "<leader>ra", desc = "Rust: Code Action", mode = "n" },
      { "<leader>re", desc = "Rust: Explain Error", mode = "n" },
      { "<leader>rd", desc = "Rust: Render Diagnostic", mode = "n" },
      { "<leader>rc", desc = "Rust: Open Cargo.toml", mode = "n" },
      { "<leader>rp", desc = "Rust: Parent Module", mode = "n" },
      { "<leader>rj", desc = "Rust: Join Lines", mode = "n" },
      { "<leader>rs", desc = "Rust: Structural Search Replace", mode = "n" },
      { "<leader>rg", desc = "Rust: View Crate Graph", mode = "n" },
      { "<leader>rm", desc = "Rust: Expand Macro", mode = "n" },
      { "<leader>rK", desc = "Rust: Move Item Up", mode = "n" },
      { "<leader>rJ", desc = "Rust: Move Item Down", mode = "n" },
      { "<leader>rr", desc = "Rust: Runnables", mode = "n" },
      { "<leader>rD", desc = "Rust: Debuggables", mode = "n" },
      { "<leader>rt", desc = "Rust: Testables", mode = "n" },

      -- Gitsigns hunks
      { "<leader>h", group = "git hunk", mode = { "n", "v" } },
      { "<leader>hs", desc = "Git: Stage Hunk" },
      { "<leader>hr", desc = "Git: Reset Hunk" },
      { "<leader>hS", desc = "Git: Stage Buffer" },
      { "<leader>hu", desc = "Git: Undo Stage Hunk" },
      { "<leader>hR", desc = "Git: Reset Buffer" },
      { "<leader>hp", desc = "Git: Preview Hunk" },
      { "<leader>hb", desc = "Git: Blame Line" },
      { "<leader>hd", desc = "Git: Diff This" },
      { "<leader>hD", desc = "Git: Diff This ~" },
      { "]c", desc = "Git: Next Hunk" },
      { "[c", desc = "Git: Prev Hunk" },
    })
  end,
} 