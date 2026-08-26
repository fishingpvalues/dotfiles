local o = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

o.number = true
o.relativenumber = true      -- makes 5j / 12k a glance rather than a count
o.cursorline = true
o.signcolumn = "yes"         -- pinned, so the text does not jump when a sign appears
o.scrolloff = 8
o.sidescrolloff = 8
o.wrap = false

o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.smartindent = true
o.breakindent = true

o.ignorecase = true
o.smartcase = true           -- a capital in the pattern makes it case-sensitive
o.inccommand = "split"       -- live preview of :s, in a split
o.hlsearch = true

o.splitright = true
o.splitbelow = true

o.undofile = true            -- undo survives closing the file
o.swapfile = false
o.backup = false
o.updatetime = 250           -- how fast CursorHold fires (diagnostics, gitsigns)
o.timeoutlen = 400

o.termguicolors = true
o.showmode = false           -- the statusline already says it
o.laststatus = 3             -- one statusline for the whole window
o.confirm = true             -- ask instead of failing on :q with changes
o.mouse = "a"
o.clipboard = "unnamedplus"
o.completeopt = "menu,menuone,noselect"

o.list = true
o.listchars = { tab = "> ", trail = "-", nbsp = "+" }

o.foldmethod = "expr"
o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
o.foldlevel = 99             -- everything open until you fold it yourself

-- Flash what was yanked, so you can see the region you actually took.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Reopen a file where you left it.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("last_position", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(args.buf) then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
