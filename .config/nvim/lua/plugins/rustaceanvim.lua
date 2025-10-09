-- rustaceanvim: Supercharge your Rust experience in Neovim
-- SOTA configuration for 2025
-- NOTE: This is a filetype plugin that works out of the box
-- Do NOT call lspconfig.rust_analyzer.setup() or set up manually
return {
  "mrcjkb/rustaceanvim",
  version = "^5",
  lazy = false, -- This plugin is already lazy
  ft = { "rust" },
  config = function()
    -- Configuration via vim.g.rustaceanvim
    vim.g.rustaceanvim = {
      -- LSP configuration
      server = {
        -- Check if mason has rust-analyzer installed, otherwise use system
        cmd = function()
          local mason_registry = require("mason-registry")
          if mason_registry.is_installed("rust-analyzer") then
            local rust_analyzer = mason_registry.get_package("rust-analyzer")
            return { rust_analyzer:get_install_path() .. "/rust-analyzer" }
          else
            return { "rust-analyzer" }
          end
        end,
        on_attach = function(client, bufnr)
          -- Keybindings
          local opts = { buffer = bufnr, noremap = true, silent = true }

          -- Hover actions
          vim.keymap.set("n", "<leader>rh", function()
            vim.cmd.RustLsp("hover", "actions")
          end, vim.tbl_extend("force", opts, { desc = "Rust Hover Actions" }))

          -- Code action groups
          vim.keymap.set("n", "<leader>ra", function()
            vim.cmd.RustLsp("codeAction")
          end, vim.tbl_extend("force", opts, { desc = "Rust Code Action" }))

          -- Explain error
          vim.keymap.set("n", "<leader>re", function()
            vim.cmd.RustLsp("explainError")
          end, vim.tbl_extend("force", opts, { desc = "Rust Explain Error" }))

          -- Render diagnostic
          vim.keymap.set("n", "<leader>rd", function()
            vim.cmd.RustLsp("renderDiagnostic")
          end, vim.tbl_extend("force", opts, { desc = "Rust Render Diagnostic" }))

          -- Open Cargo.toml
          vim.keymap.set("n", "<leader>rc", function()
            vim.cmd.RustLsp("openCargo")
          end, vim.tbl_extend("force", opts, { desc = "Rust Open Cargo.toml" }))

          -- Parent Module
          vim.keymap.set("n", "<leader>rp", function()
            vim.cmd.RustLsp("parentModule")
          end, vim.tbl_extend("force", opts, { desc = "Rust Parent Module" }))

          -- Join Lines
          vim.keymap.set("n", "<leader>rj", function()
            vim.cmd.RustLsp("joinLines")
          end, vim.tbl_extend("force", opts, { desc = "Rust Join Lines" }))

          -- Structural Search Replace
          vim.keymap.set("n", "<leader>rs", function()
            vim.cmd.RustLsp("ssr")
          end, vim.tbl_extend("force", opts, { desc = "Rust Structural Search Replace" }))

          -- View Crate Graph
          vim.keymap.set("n", "<leader>rg", function()
            vim.cmd.RustLsp("crateGraph", "backend")
          end, vim.tbl_extend("force", opts, { desc = "Rust View Crate Graph" }))

          -- Expand Macro
          vim.keymap.set("n", "<leader>rm", function()
            vim.cmd.RustLsp("expandMacro")
          end, vim.tbl_extend("force", opts, { desc = "Rust Expand Macro" }))

          -- Move Item Up/Down
          vim.keymap.set("n", "<leader>rK", function()
            vim.cmd.RustLsp("moveItem", "up")
          end, vim.tbl_extend("force", opts, { desc = "Rust Move Item Up" }))

          vim.keymap.set("n", "<leader>rJ", function()
            vim.cmd.RustLsp("moveItem", "down")
          end, vim.tbl_extend("force", opts, { desc = "Rust Move Item Down" }))

          -- Runnables
          vim.keymap.set("n", "<leader>rr", function()
            vim.cmd.RustLsp("runnables")
          end, vim.tbl_extend("force", opts, { desc = "Rust Runnables" }))

          -- Debuggables
          vim.keymap.set("n", "<leader>rD", function()
            vim.cmd.RustLsp("debuggables")
          end, vim.tbl_extend("force", opts, { desc = "Rust Debuggables" }))

          -- Test
          vim.keymap.set("n", "<leader>rt", function()
            vim.cmd.RustLsp("testables")
          end, vim.tbl_extend("force", opts, { desc = "Rust Testables" }))
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            -- Add clippy lints for Rust
            checkOnSave = true,
            check = {
              command = "clippy",
              extraArgs = { "--all", "--", "-W", "clippy::all" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
            -- Inlay hints configuration
            inlayHints = {
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 25,
              },
              closureReturnTypeHints = {
                enable = "never",
              },
              lifetimeElisionHints = {
                enable = "never",
                useParameterNames = false,
              },
              maxLength = 25,
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
              renderColons = true,
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
      -- DAP configuration
      dap = {
        adapter = {
          type = "executable",
          command = "lldb-dap",
          name = "rt_lldb",
        },
      },
      -- Tools configuration
      tools = {
        hover_actions = {
          auto_focus = true,
        },
        -- Executor for runnables/testables
        executor = "termopen",
        -- Callback to execute once rust-analyzer is done initializing the workspace
        -- See https://github.com/neovim/nvim-lspconfig/issues/1931
        on_initialized = nil,
        -- Reload workspace from disk on certain events
        reload_workspace_from_cargo_toml = true,
        -- Inlay hints
        inlay_hints = {
          auto = true,
          only_current_line = false,
          show_parameter_hints = true,
          parameter_hints_prefix = "<- ",
          other_hints_prefix = "=> ",
          max_len_align = false,
          max_len_align_padding = 1,
          right_align = false,
          right_align_padding = 7,
          highlight = "Comment",
        },
        -- Hover actions config
        hover_actions = {
          border = "rounded",
          max_width = nil,
          max_height = nil,
          auto_focus = false,
        },
        -- Crate graph config
        crate_graph = {
          backend = "x11",
          output = nil,
          full = true,
          enabled_graphviz_backends = {
            "bmp",
            "cgimage",
            "canon",
            "dot",
            "gv",
            "xdot",
            "xdot1.2",
            "xdot1.4",
            "eps",
            "exr",
            "fig",
            "gd",
            "gd2",
            "gif",
            "gtk",
            "ico",
            "cmap",
            "ismap",
            "imap",
            "cmapx",
            "imap_np",
            "cmapx_np",
            "jpg",
            "jpeg",
            "jpe",
            "jp2",
            "json",
            "json0",
            "dot_json",
            "xdot_json",
            "pdf",
            "pic",
            "pct",
            "pict",
            "plain",
            "plain-ext",
            "png",
            "pov",
            "ps",
            "ps2",
            "psd",
            "sgi",
            "svg",
            "svgz",
            "tga",
            "tiff",
            "tif",
            "tk",
            "vml",
            "vmlz",
            "wbmp",
            "webp",
            "xlib",
            "x11",
          },
        },
      },
    }
  end,
}
