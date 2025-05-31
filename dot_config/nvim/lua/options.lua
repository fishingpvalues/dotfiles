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

-- Configure clipboard for all platforms, maximizing WezTerm compatibility
local has_wezterm = vim.env.TERM_PROGRAM == "WezTerm" and vim.fn.executable("wezterm") == 1
local has_win32yank = vim.fn.executable("win32yank.exe") == 1
local has_pbcopy = vim.fn.executable("pbcopy") == 1 and vim.fn.executable("pbpaste") == 1
local has_wlcopy = vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1
local has_xclip = vim.fn.executable("xclip") == 1
local has_xsel = vim.fn.executable("xsel") == 1
local has_osc52 = vim.fn.has("nvim") == 1 and (vim.env.TERM_PROGRAM == "WezTerm" or vim.env.TERM == "wezterm") and vim.fn.exists(":Osc52") == 2

-- Prefer WezTerm OSC 52 clipboard for remote/tmux/ssh if available
if has_osc52 then
  vim.g.clipboard = {
    name = "OSC 52 (WezTerm)",
    copy = {
      ["+"] = "Osc52 copy",
      ["*"] = "Osc52 copy",
    },
    paste = {
      ["+"] = "Osc52 paste",
      ["*"] = "Osc52 paste",
    },
    cache_enabled = 1,
  }
elseif has_wezterm then
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
elseif has_win32yank then
  vim.g.clipboard = nil
  vim.opt.clipboard = 'unnamedplus'
elseif has_pbcopy then
  vim.g.clipboard = {
    name = "macOS-clipboard",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 1,
  }
elseif has_wlcopy then
  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy --foreground --type text/plain",
      ["*"] = "wl-copy --foreground --primary --type text/plain",
    },
    paste = {
      ["+"] = "wl-paste --no-newline",
      ["*"] = "wl-paste --no-newline --primary",
    },
    cache_enabled = 1,
  }
elseif has_xclip then
  vim.g.clipboard = {
    name = "xclip",
    copy = {
      ["+"] = "xclip -selection clipboard",
      ["*"] = "xclip -selection primary",
    },
    paste = {
      ["+"] = "xclip -selection clipboard -o",
      ["*"] = "xclip -selection primary -o",
    },
    cache_enabled = 1,
  }
elseif has_xsel then
  vim.g.clipboard = {
    name = "xsel",
    copy = {
      ["+"] = "xsel --clipboard --input",
      ["*"] = "xsel --input",
    },
    paste = {
      ["+"] = "xsel --clipboard --output",
      ["*"] = "xsel --output",
    },
    cache_enabled = 1,
  }
else
  vim.schedule(function()
    vim.notify("No valid clipboard provider found! Clipboard integration may not work.", vim.log.levels.WARN, {title = "Clipboard"})
  end)
end

-- Helper: Print WezTerm/clipboard status for debugging
function _G.CheckWeztermClipboard()
  print("TERM_PROGRAM:", vim.env.TERM_PROGRAM)
  print("TERM:", vim.env.TERM)
  print("wezterm in PATH:", vim.fn.executable("wezterm"))
  print("OSC52 available:", has_osc52)
  print("Clipboard provider:", vim.inspect(vim.g.clipboard))
end
vim.api.nvim_create_user_command('CheckWezterm', _G.CheckWeztermClipboard, {})

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

-- Removed transparency and background settings
vim.opt.background = "dark"      -- Dark mode to match dotfile themes

-- Always show the tabline (required for bufferline)
vim.opt.showtabline = 2

-- vim: ts=2 sts=2 sw=2 et