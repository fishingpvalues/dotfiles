return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "main",
    lazy = false,
    config = function()
      local ts = require("nvim-treesitter")
      ts.setup()

      local wanted = {
        "lua", "vim", "vimdoc", "bash", "fish", "python", "rust", "go",
        "javascript", "typescript", "json", "yaml", "toml", "markdown",
        "markdown_inline", "dockerfile", "sql", "diff", "git_config",
      }

      -- Install only what is MISSING. The first version of this called
      -- install(wanted) unconditionally on every startup, which meant every
      -- single `nvim` re-downloaded 19 parsers - and, because install() is
      -- async and `nvim --headless +qa` exits immediately, none of them ever
      -- finished. The result was 19 downloads per start and zero parsers on
      -- disk, with no error unless you went looking.
      local installed = {}
      for _, lang in ipairs(ts.get_installed()) do
        installed[lang] = true
      end
      local missing = vim.tbl_filter(function(lang)
        return not installed[lang]
      end, wanted)

      if #missing > 0 then
        -- This needs the tree-sitter CLI. Without it every compile fails with
        -- `ENOENT ... 'tree-sitter'` and the parser is silently not installed,
        -- so say so once rather than failing 19 times into a log nobody reads.
        if vim.fn.executable("tree-sitter") == 0 then
          vim.notify(
            "treesitter: the `tree-sitter` CLI is missing, parsers cannot be "
              .. "compiled. Install tree-sitter-cli.",
            vim.log.levels.WARN
          )
        else
          ts.install(missing)
        end
      end

      -- Start the parser for any buffer that has one. pcall because a filetype
      -- with no installed parser is normal, not an error worth a message.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })
    end,
  },

  {
    -- The picker. fzf-lua rather than telescope: it shells out to fzf, so it
    -- stays fast on a big repo where telescope's Lua sorter starts to crawl.
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
      { "<leader>fr", "<cmd>FzfLua resume<cr>", desc = "Resume last picker" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
      { "<leader><leader>", "<cmd>FzfLua files<cr>", desc = "Find files" },
    },
    opts = { "default-title", winopts = { height = 0.85, width = 0.85, preview = { layout = "vertical" } } },
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      -- Route vim.ui.select through fzf-lua. Without this every code action and
      -- every "choose one" prompt falls back to the numbered list at the bottom
      -- of the screen, and snacks' health check flags the gap.
      fzf.register_ui_select()
    end,
  },

  {
    -- Edit the filesystem as a buffer. Renaming ten files is a visual block
    -- edit, not ten prompts.
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = { { "-", "<cmd>Oil<cr>", desc = "Open parent directory" } },
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
      keymaps = { ["q"] = "actions.close" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" }, change = { text = "~" },
        delete = { text = "_" }, topdelete = { text = "^" }, changedelete = { text = "~" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local map = function(m, k, f, d) vim.keymap.set(m, k, f, { buffer = buf, desc = d }) end
        map("n", "]h", gs.next_hunk, "Next hunk")
        map("n", "[h", gs.prev_hunk, "Previous hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },

  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.ai").setup()          -- better a/i textobjects
      require("mini.surround").setup()    -- sa / sd / sr
      require("mini.pairs").setup()
      require("mini.icons").setup()
    end,
  },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },   -- turns off treesitter/lsp on huge files
      notifier = { enabled = true },
      quickfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      -- Off explicitly, not by omission. snacks' health check inspects every
      -- module whether or not you configured it, so leaving these unset
      -- produced three hard ERRORs for tools this machine will never have
      -- (ghostscript, pdflatex, mmdc) plus a complaint that the terminal does
      -- not speak the kitty graphics protocol. Inline image rendering is not
      -- wanted; saying so silences the lot.
      image = { enabled = false },
      -- fzf-lua is the picker here. Two pickers is one too many.
      picker = { enabled = false },
      dashboard = { enabled = false },
      scroll = { enabled = false },
    },
    config = function(_, opts)
      local snacks = require("snacks")
      snacks.setup(opts)
      -- snacks.setup() does NOT hook vim.ui.input by itself - measured:
      -- config.input.enabled was true while vim.ui.input was still the stock
      -- one, which is exactly what its health check reports as an ERROR.
      -- enable() is the module's own entry point for this.
      pcall(function() snacks.input.enable() end)
    end,
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Blame line" },
    },
  },
}
