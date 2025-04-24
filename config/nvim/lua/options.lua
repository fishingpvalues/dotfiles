-- [[ Setting options ]]
-- See `:help vim.opt`

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Enable true color support
vim.opt.termguicolors = true

-- Configure clipboard for WezTerm
if vim.env.TERM_PROGRAM == "WezTerm" then
  vim.g.clipboard = {
    name = "wezterm",
    copy = {
      ["+"] = "wezterm cli copy-to clipboard",
      ["*"] = "wezterm cli copy-to primary",
    },
    paste = {
      ["+"] = "wezterm cli paste-from clipboard",
      ["*"] = "wezterm cli paste-from primary",
    },
    cache_enabled = 1,
  }
else
  -- Fallback for other terminals
  vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
  end)
end

-- Case-insensitive searching UNLESS \C or capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Configure whitespace characters display
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Ask to save on quit if needed
vim.opt.confirm = true

-- Transparency and background settings
vim.opt.winblend = 15            -- Window transparency level
vim.opt.pumblend = 15            -- Popup menu transparency
vim.opt.background = "dark"      -- Dark mode to match dotfile themes

-- vim: ts=2 sts=2 sw=2 et