-- codecompanion.nvim: AI Coding, Vim Style
-- SOTA AI assistant with multi-provider support
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional: For slash commands
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } }, -- Optional: For markdown rendering
  },
  config = function()
    require("codecompanion").setup({
      -- Adapters: Choose your AI provider
      adapters = {
        -- Option 1: Use Ollama (free, local, no API keys needed!)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:7b", -- or "deepseek-coder:6.7b", "codellama:13b"
              },
            },
          })
        end,

        -- Option 2: Anthropic Claude (best for complex code)
        -- Uncomment and add your API key to ~/.bashrc: export ANTHROPIC_API_KEY="your-key"
        -- anthropic = function()
        --   return require("codecompanion.adapters").extend("anthropic", {
        --     schema = {
        --       model = {
        --         default = "claude-3-5-sonnet-20241022",
        --       },
        --     },
        --   })
        -- end,

        -- Option 3: OpenAI (requires API key)
        -- openai = function()
        --   return require("codecompanion.adapters").extend("openai", {
        --     schema = {
        --       model = {
        --         default = "gpt-4o-mini", -- Cheaper option
        --       },
        --     },
        --   })
        -- end,
      },

      -- Display settings
      display = {
        chat = {
          window = {
            layout = "vertical", -- "vertical" | "horizontal" | "float"
            width = 0.45,
            height = 0.8,
            opts = {
              border = "rounded",
              breakindent = true,
              cursorline = false,
              conceallevel = 2,
              linebreak = true,
              list = false,
              wrap = true,
            },
          },
          intro_message = "Welcome to CodeCompanion! Type /help for commands",
        },
        inline = {
          diff = {
            enabled = true,
            highlights = {
              added = "DiffAdd",
              changed = "DiffChange",
              removed = "DiffDelete",
            },
          },
        },
      },

      -- Default prompts and strategies
      strategies = {
        chat = {
          adapter = "ollama", -- Change to "anthropic" or "openai" if you prefer
          roles = {
            llm = "CodeCompanion", -- Name of the LLM
            user = "You",
          },
        },
        inline = {
          adapter = "ollama",
        },
      },

      -- Prompt library (extensible)
      prompt_library = {
        ["Custom Prompt"] = {
          strategy = "chat",
          description = "Create a custom prompt",
          prompts = {
            {
              role = "system",
              content = "You are an expert programmer assistant.",
            },
          },
        },
      },

      -- Logging
      log_level = "ERROR", -- "DEBUG" | "ERROR" | "INFO" | "TRACE" | "WARN"
    })
  end,
  keys = {
    -- Chat interface
    {
      "<leader>aa",
      "<cmd>CodeCompanionActions<cr>",
      mode = { "n", "v" },
      desc = "AI: Actions",
    },
    {
      "<leader>ac",
      "<cmd>CodeCompanionChat Toggle<cr>",
      mode = { "n", "v" },
      desc = "AI: Toggle Chat",
    },
    {
      "<leader>aA",
      "<cmd>CodeCompanionChat Add<cr>",
      mode = "v",
      desc = "AI: Add to Chat",
    },

    -- Inline assistance
    {
      "<leader>ai",
      "<cmd>CodeCompanion<cr>",
      mode = { "n", "v" },
      desc = "AI: Inline Prompt",
    },

    -- Quick actions
    {
      "<leader>ae",
      "<cmd>CodeCompanionChat<cr>",
      mode = "n",
      desc = "AI: Explain Code",
    },
    {
      "<leader>af",
      function()
        require("codecompanion").prompt("fix")
      end,
      mode = { "n", "v" },
      desc = "AI: Fix Code",
    },
    {
      "<leader>at",
      function()
        require("codecompanion").prompt("tests")
      end,
      mode = { "n", "v" },
      desc = "AI: Generate Tests",
    },
    {
      "<leader>ad",
      function()
        require("codecompanion").prompt("docs")
      end,
      mode = { "n", "v" },
      desc = "AI: Generate Docs",
    },
    {
      "<leader>ar",
      function()
        require("codecompanion").prompt("refactor")
      end,
      mode = "v",
      desc = "AI: Refactor",
    },

    -- Buffer/LSP context
    {
      "<leader>ab",
      function()
        require("codecompanion").prompt("buffer")
      end,
      mode = "n",
      desc = "AI: Ask about Buffer",
    },
    {
      "<leader>al",
      function()
        require("codecompanion").prompt("lsp")
      end,
      mode = "n",
      desc = "AI: Ask about LSP",
    },
  },
}
