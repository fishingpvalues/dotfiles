-- neotest: Extensible framework for interacting with tests within NeoVim
-- SOTA configuration with Go, Python, and Rust adapters (2025)
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters
    "fredrikaverpil/neotest-golang",  -- Go (modern, reliable)
    "nvim-neotest/neotest-python",    -- Python
    "rouge8/neotest-rust",            -- Rust
  },
  config = function()
    require("neotest").setup({
      adapters = {
        -- Go adapter with comprehensive options
        require("neotest-golang")({
          dap_go_enabled = true,  -- Enable DAP debugging
          dap_go_opts = {
            delve = {
              path = "dlv",
            },
          },
          -- Testify support
          testify_enabled = true,
          -- Warning: passing table tests is not supported
          warn_test_name_dupes = true,
          -- Warning: passing tests by line number is not supported
          warn_test_not_executed = true,
          -- Extra arguments to pass to go test
          go_test_args = {
            "-v",
            "-race",
            "-count=1",
            "-timeout=60s",
          },
        }),
        -- Python adapter
        require("neotest-python")({
          dap = { justMyCode = false },
          -- Command to run pytest
          args = { "--log-level", "DEBUG", "--quiet" },
          runner = "pytest",
        }),
        -- Rust adapter
        require("neotest-rust")({
          args = { "--no-capture" },
          dap_adapter = "lldb",
        }),
      },
      -- General configuration
      discovery = {
        -- Only enable discovery when explicitly requested
        enabled = true,
        concurrent = 1,
      },
      running = {
        -- Run tests concurrently when possible
        concurrent = true,
      },
      summary = {
        -- Enable animated icons in the summary window
        animated = true,
        -- Enable expand markers in the summary window
        expand_errors = true,
        follow = true,
        mappings = {
          attach = "a",
          clear_marked = "M",
          clear_target = "T",
          debug = "d",
          debug_marked = "D",
          expand = { "<CR>", "<2-LeftMouse>" },
          expand_all = "e",
          jumpto = "i",
          mark = "m",
          next_failed = "J",
          output = "o",
          prev_failed = "K",
          run = "r",
          run_marked = "R",
          short = "O",
          stop = "u",
          target = "t",
          watch = "w",
        },
      },
      -- Diagnostic configuration
      diagnostic = {
        enabled = true,
        severity = 1,
      },
      -- Floating window configuration
      floating = {
        border = "rounded",
        max_height = 0.6,
        max_width = 0.6,
        options = {},
      },
      -- Highlight configuration
      highlights = {
        adapter_name = "NeotestAdapterName",
        border = "NeotestBorder",
        dir = "NeotestDir",
        expand_marker = "NeotestExpandMarker",
        failed = "NeotestFailed",
        file = "NeotestFile",
        focused = "NeotestFocused",
        indent = "NeotestIndent",
        marked = "NeotestMarked",
        namespace = "NeotestNamespace",
        passed = "NeotestPassed",
        running = "NeotestRunning",
        select_win = "NeotestWinSelect",
        skipped = "NeotestSkipped",
        target = "NeotestTarget",
        test = "NeotestTest",
        unknown = "NeotestUnknown",
        watching = "NeotestWatching",
      },
      icons = {
        child_indent = "│",
        child_prefix = "├",
        collapsed = "─",
        expanded = "╮",
        failed = "✖",
        final_child_indent = " ",
        final_child_prefix = "╰",
        non_collapsible = "─",
        notify = "",
        passed = "✓",
        running = "",
        running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
        skipped = "↓",
        unknown = "?",
        watching = "",
      },
      -- Output configuration
      output = {
        enabled = true,
        open_on_run = "short",
      },
      output_panel = {
        enabled = true,
        open = "botright split | resize 15",
      },
      -- Quickfix configuration
      quickfix = {
        enabled = true,
        open = false,
      },
      -- Status configuration
      status = {
        enabled = true,
        signs = true,
        virtual_text = false,
      },
      -- Strategies configuration
      strategies = {
        integrated = {
          height = 40,
          width = 120,
        },
      },
      -- Log level
      log_level = vim.log.levels.WARN,
    })
  end,
  keys = {
    {
      "<leader>tt",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run File",
    },
    {
      "<leader>tT",
      function()
        require("neotest").run.run(vim.uv.cwd())
      end,
      desc = "Run All Test Files",
    },
    {
      "<leader>tr",
      function()
        require("neotest").run.run()
      end,
      desc = "Run Nearest",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run Last",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle Summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true, auto_close = true })
      end,
      desc = "Show Output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle Output Panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop",
    },
    {
      "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Debug Nearest",
    },
    {
      "<leader>tw",
      function()
        require("neotest").watch.toggle(vim.fn.expand("%"))
      end,
      desc = "Toggle Watch",
    },
  },
}
