# Recommended SOTA Neovim Plugins (2025)

Based on research of trending and most popular plugins in 2025, here are recommendations for plugins your setup is currently missing:

## 🤖 AI & Code Completion (Critical for 2025)

### **avante.nvim** - Cursor AI for Neovim ⭐⭐⭐⭐⭐
- **What**: Use Neovim like Cursor AI IDE with inline AI suggestions
- **Why**: Leading AI-powered coding assistant for Neovim, emulates Cursor AI behavior
- **GitHub**: yetone/avante.nvim
```lua
{
  "yetone/avante.nvim",
  event = "VeryLazy",
  opts = {
    -- add any opts here
  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
}
```

### **supermaven-nvim** - Fastest AI Completion ⭐⭐⭐⭐⭐
- **What**: The fastest copilot alternative (300k token context)
- **Why**: Significantly faster than GitHub Copilot with larger context window
- **GitHub**: supermaven-inc/supermaven-nvim
```lua
{
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({})
  end,
}
```

### **copilot.lua** - GitHub Copilot Integration ⭐⭐⭐⭐
- **What**: Fully featured Lua replacement for copilot.vim
- **Why**: Native Lua implementation with API access
- **GitHub**: zbirenbaum/copilot.lua
```lua
{
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup({
      suggestion = { enabled = true, auto_trigger = true },
      panel = { enabled = true },
    })
  end,
}
```

## 🎯 Navigation & Movement

### **flash.nvim** - Enhanced Navigation ⭐⭐⭐⭐⭐
- **What**: Search labels, enhanced f/t motions, Treesitter integration
- **Why**: Modern replacement for leap.nvim/hop.nvim with better UX
- **GitHub**: folke/flash.nvim
- **Note**: You have leap.nvim, consider upgrading to flash.nvim
```lua
{
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
```

### **oil.nvim** - Modern File Explorer ⭐⭐⭐⭐⭐
- **What**: File explorer as a vim buffer (like dired in Emacs)
- **Why**: Edit filesystem like text, more intuitive than neo-tree for many users
- **GitHub**: stevearc/oil.nvim
```lua
{
  'stevearc/oil.nvim',
  opts = {},
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup()
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
  end,
}
```

## 📦 Code Quality & Refactoring

### **refactoring.nvim** - Automated Refactoring ⭐⭐⭐⭐
- **What**: Automated refactoring operations (extract function, inline var, etc.)
- **Why**: Professional-grade refactoring tools powered by Treesitter
- **GitHub**: ThePrimeagen/refactoring.nvim
```lua
{
  "ThePrimeagen/refactoring.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("refactoring").setup()
  end,
}
```

### **trouble.nvim v3** - Modern Diagnostics UI ⭐⭐⭐⭐⭐
- **What**: Pretty diagnostics, references, quickfix lists
- **Why**: You have it, but ensure you're on v3 (2024+)
- **Check**: Your version at lua/plugins/trouble.lua

## 🧪 Testing

### **neotest** - Testing Framework ⭐⭐⭐⭐
- **What**: Extensible test runner with UI
- **Why**: Run tests directly in Neovim with visual feedback (supports Go, Python, Rust, etc.)
- **GitHub**: nvim-neotest/neotest
```lua
{
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-go",        -- Go adapter
    "nvim-neotest/neotest-python",    -- Python adapter
    "rouge8/neotest-rust",            -- Rust adapter
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-go"),
        require("neotest-python"),
        require("neotest-rust"),
      },
    })
  end,
}
```

## 🎨 UI Enhancements

### **noice.nvim** - Modern UI Replacement ⭐⭐⭐⭐⭐
- **What**: Replaces cmdline, messages, popupmenu
- **Why**: You have it! Great choice for modern UI

### **dressing.nvim** - Better vim.ui ⭐⭐⭐⭐
- **What**: Improves default vim.ui interfaces (input, select)
- **Why**: Makes UI prompts use telescope/modern interfaces
- **GitHub**: stevearc/dressing.nvim
```lua
{
  'stevearc/dressing.nvim',
  opts = {},
}
```

### **mini.nvim** - Swiss Army Knife ⭐⭐⭐⭐⭐
- **What**: Collection of 40+ minimal, independent modules
- **Why**: Replaces many plugins with one well-maintained suite
- **GitHub**: echasnovski/mini.nvim
- **Note**: You have mini.surround and mini.icons
- **Consider adding**: mini.ai (better text objects), mini.animate, mini.bufremove
```lua
{
  'echasnovski/mini.ai',
  version = false,
  config = function()
    require('mini.ai').setup()
  end,
}
```

## 🔧 Language-Specific

### **rustaceanvim** - Enhanced Rust Support ⭐⭐⭐⭐⭐
- **What**: Replaces rust-tools.nvim with automatic rust-analyzer config
- **Why**: Modern, actively maintained, better inlay hints
- **GitHub**: mrcjkb/rustaceanvim
```lua
{
  'mrcjkb/rustaceanvim',
  version = '^5',
  lazy = false,
  ft = { 'rust' },
}
```

### **nvim-jdtls** - Java Development ⭐⭐⭐⭐
- **What**: Extensions for jdtls (Java LSP)
- **Why**: Better Java support than plain lspconfig
- **GitHub**: mfussenegger/nvim-jdtls

## 📊 Git Integration

### **diffview.nvim** - Git Diff Viewer ⭐⭐⭐⭐⭐
- **What**: Single tabpage interface for viewing git diffs
- **Why**: You have it! Excellent choice

### **neogit** - Magit Clone ⭐⭐⭐⭐
- **What**: Git interface similar to Emacs Magit
- **Why**: Fuller git UI than fugitive
- **GitHub**: NeogitOrg/neogit
```lua
{
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = true
}
```

## 🚀 Performance & Session

### **persistence.nvim** - Session Management ⭐⭐⭐⭐
- **What**: Simple session management
- **Why**: Auto-save and restore sessions
- **GitHub**: folke/persistence.nvim
- **Note**: You have session.lua, check if you want this alternative

### **snacks.nvim** - Utility Collection ⭐⭐⭐⭐
- **What**: Collection of QoL improvements (lazygit integration, etc.)
- **Why**: Modern utility suite from folke (author of lazy.nvim)
- **GitHub**: folke/snacks.nvim
- **Note**: You have snacks_dashboard.lua already!

## 📝 Note Taking & Documentation

### **obsidian.nvim** - Obsidian Integration ⭐⭐⭐⭐
- **What**: Work with Obsidian vaults in Neovim
- **Why**: If you use Obsidian for notes
- **GitHub**: epwalsh/obsidian.nvim

## 🎯 Top Priority Recommendations

Based on 2025 trends and your current setup:

1. **avante.nvim or supermaven-nvim** (AI coding - essential for 2025)
2. **flash.nvim** (upgrade from leap.nvim)
3. **oil.nvim** (modern file management alternative to neo-tree)
4. **neotest** (integrated testing)
5. **refactoring.nvim** (automated refactoring)
6. **dressing.nvim** (UI improvements)
7. **rustaceanvim** (enhanced Rust support)

## Already Well-Covered Areas ✅

Your setup already has excellent coverage for:
- ✅ LSP (mason, lspconfig, lspsaga)
- ✅ Completion (blink.cmp)
- ✅ Debugging (dap, dap-ui, dap-virtual-text)
- ✅ Git (gitsigns, diffview)
- ✅ Fuzzy Finding (telescope)
- ✅ File Explorer (neo-tree, yazi)
- ✅ UI (noice, which-key, trouble, lualine)
- ✅ Formatting (conform, none-ls)
- ✅ Treesitter (all plugins)

## Installation Priority

**Tier 1 (Must Have for 2025)**:
- AI Completion: supermaven-nvim OR avante.nvim
- Navigation: flash.nvim
- Testing: neotest

**Tier 2 (Highly Recommended)**:
- Refactoring: refactoring.nvim
- UI: dressing.nvim
- File Management: oil.nvim (as alternative to neo-tree)

**Tier 3 (Nice to Have)**:
- Git: neogit
- Language-specific: rustaceanvim, nvim-jdtls
- Mini modules: mini.ai, mini.animate

---

## Notes
- Your setup is already very comprehensive and modern
- Focus on AI tooling (biggest trend in 2025)
- Consider flash.nvim over leap.nvim for better UX
- You have excellent DevOps and data science coverage already
