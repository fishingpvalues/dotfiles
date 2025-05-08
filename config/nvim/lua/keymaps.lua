-- [[ Centralized Keymaps ]]
-- See `:help vim.keymap.set()`

-- local wk = require('which-key') -- DISABLED: only load if which-key is available

-- Basic Keymaps
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', function()
  local ok = pcall(require, 'neo-tree.command')
  if ok then
    vim.cmd('Neotree toggle')
  else
    vim.cmd('Ex')
  end
end, { desc = 'Open file [E]xplorer' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Window resizing
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Move lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<cr>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<cr>==', { desc = 'Move line up' })
vim.keymap.set('i', '<A-j>', '<esc><cmd>m .+1<cr>==gi', { desc = 'Move line down' })
vim.keymap.set('i', '<A-k>', '<esc><cmd>m .-2<cr>==gi', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = 'Move selection up' })

-- Indent/Dedent in visual mode
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and reselect' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and reselect' })

-- Buffer management
vim.keymap.set('n', '<C-w>', '<cmd>lua MiniBufremove.delete()<CR>', { desc = 'Delete Buffer' })

-- Telescope (fuzzy finder)
do
  local ok, telescope_builtin = pcall(require, 'telescope.builtin')
  if ok then
    vim.keymap.set('n', '<leader>sf', telescope_builtin.find_files, { desc = 'Search Files' })
    vim.keymap.set('n', '<leader>sh', telescope_builtin.help_tags, { desc = 'Search Help' })
    vim.keymap.set('n', '<leader>sw', telescope_builtin.grep_string, { desc = 'Search Word under cursor' })
    vim.keymap.set('n', '<leader>sg', telescope_builtin.live_grep, { desc = 'Search Grep' })
    vim.keymap.set('n', '<leader>sd', telescope_builtin.diagnostics, { desc = 'Search Diagnostics' })
    vim.keymap.set('n', '<leader>sr', telescope_builtin.oldfiles, { desc = 'Search Recent Files' })
    vim.keymap.set('n', '<leader><space>', telescope_builtin.buffers, { desc = 'Search Open Buffers' })
    vim.keymap.set('n', '<leader>sb', telescope_builtin.buffers, { desc = 'Search Buffers' })
    vim.keymap.set('n', '<leader>gc', telescope_builtin.git_commits, { desc = 'Search Git Commits' })
    vim.keymap.set('n', '<leader>gs', telescope_builtin.git_status, { desc = 'Search Git Status' })
  end
end

-- Todo-comments
if pcall(require, 'todo-comments') then
  vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = 'Next todo comment' })
  vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = 'Previous todo comment' })
  vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<cr>', { desc = 'Search Todo comments' })
end

-- GitSigns
if pcall(require, 'gitsigns') then
  vim.keymap.set('n', ']c', function() if vim.wo.diff then return ']c' end vim.schedule(function() require('gitsigns').next_hunk() end) return '<Ignore>' end, { expr = true, desc = 'Jump to next hunk' })
  vim.keymap.set('n', '[c', function() if vim.wo.diff then return '[c' end vim.schedule(function() require('gitsigns').prev_hunk() end) return '<Ignore>' end, { expr = true, desc = 'Jump to previous hunk' })
  vim.keymap.set('v', '<leader>hs', function() require('gitsigns').stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { desc = 'Stage git hunk' })
  vim.keymap.set('v', '<leader>hr', function() require('gitsigns').reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, { desc = 'Reset git hunk' })
  vim.keymap.set('n', '<leader>hs', require('gitsigns').stage_hunk, { desc = 'Git stage hunk' })
  vim.keymap.set('n', '<leader>hr', require('gitsigns').reset_hunk, { desc = 'Git reset hunk' })
  vim.keymap.set('n', '<leader>hS', require('gitsigns').stage_buffer, { desc = 'Git Stage buffer' })
  vim.keymap.set('n', '<leader>hu', require('gitsigns').undo_stage_hunk, { desc = 'Undo stage hunk' })
  vim.keymap.set('n', '<leader>hR', require('gitsigns').reset_buffer, { desc = 'Git Reset buffer' })
  vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { desc = 'Preview git hunk' })
  vim.keymap.set('n', '<leader>hb', function() require('gitsigns').blame_line { full = true } end, { desc = 'Git blame line' })
  vim.keymap.set('n', '<leader>hd', require('gitsigns').diffthis, { desc = 'Git diff against index' })
  vim.keymap.set('n', '<leader>hD', function() require('gitsigns').diffthis('~') end, { desc = 'Git diff against last commit' })
  vim.keymap.set('n', '<leader>tb', require('gitsigns').toggle_current_line_blame, { desc = 'Toggle git blame line' })
  vim.keymap.set('n', '<leader>td', require('gitsigns').toggle_deleted, { desc = 'Toggle git show deleted' })
  vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select git hunk' })
end

-- DAP (Debug Adapter Protocol)
do
  local ok_dap_python, dap_python = pcall(require, 'dap-python')
  local ok_dapui, dapui = pcall(require, 'dapui')
  if ok_dap_python then
    vim.keymap.set('n', '<leader>dpr', function() dap_python.test_method() end, { desc = 'Debug Python Test Method' })
    vim.keymap.set('n', '<leader>dpc', function() dap_python.test_class() end, { desc = 'Debug Python Test Class' })
    vim.keymap.set('n', '<leader>dps', function() dap_python.debug_selection() end, { desc = 'Debug Python Selection' })
  end
  if ok_dapui then
    vim.keymap.set('n', '<leader>du', function() dapui.toggle() end, { desc = 'Toggle Debug UI' })
    vim.keymap.set('n', '<leader>de', function() dapui.eval() end, { desc = 'Evaluate Expression' })
    vim.keymap.set('v', '<leader>de', function() dapui.eval() end, { desc = 'Evaluate Expression' })
  end
end

-- Persistent Breakpoints
if pcall(require, 'persistent-breakpoints') then
  vim.keymap.set('n', '<leader>db', function() require('persistent-breakpoints.api').toggle_breakpoint() end, { desc = 'Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>dB', function() require('persistent-breakpoints.api').set_conditional_breakpoint() end, { desc = 'Set Conditional Breakpoint' })
  vim.keymap.set('n', '<leader>dc', function() require('persistent-breakpoints.api').clear_all_breakpoints() end, { desc = 'Clear All Breakpoints' })
end

-- Leap
if pcall(require, 'leap') and pcall(require, 'leap.leap') then
  vim.keymap.set('n', '<leader>j', function()
    local target_windows = require('leap.leap').get_target_windows()
    require('leap').leap({ target_windows = target_windows })
  end, { desc = 'Leap: Jump across windows' })
end

-- Illuminate
if pcall(require, 'illuminate') then
  vim.keymap.set('n', ']]', function() require('illuminate').goto_next_reference() end, { desc = 'Next Reference' })
  vim.keymap.set('n', '[[', function() require('illuminate').goto_prev_reference() end, { desc = 'Previous Reference' })
end

-- PickMe
if pcall(require, 'mini.pick') then
  vim.keymap.set('n', '<leader>p', ':PickMe<CR>', { desc = 'Open PickMe Menu', silent = true })
end

-- LuaSnip
if pcall(require, 'luasnip') then
  vim.keymap.set({ 'i', 's' }, '<C-j>', function()
    local ls = require('luasnip')
    if ls.expand_or_jumpable() then ls.expand_or_jump() end
  end, { silent = true, desc = 'LuaSnip expand or jump' })
  vim.keymap.set({ 'i', 's' }, '<C-k>', function()
    local ls = require('luasnip')
    if ls.jumpable(-1) then ls.jump(-1) end
  end, { silent = true, desc = 'LuaSnip jump back' })
  vim.keymap.set({ 'i', 's' }, '<C-l>', function()
    local ls = require('luasnip')
    if ls.choice_active() then ls.change_choice(1) end
  end, { silent = true, desc = 'LuaSnip next choice' })
end

-- Conform (formatter)
if pcall(require, 'conform') then
  vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
    require('conform').format({ lsp_fallback = true, async = false, timeout_ms = 500 })
  end, { desc = 'Format file or range (in visual mode)' })
end

vim.keymap.set('n', '<leader>T', ':split | terminal<CR>', { desc = 'Open terminal in split' })

-- Register main which-key groups
-- if pcall(require, 'which-key') then
--   local wk = require('which-key')
--   wk.register({
--     ["<leader>"] = {
--       t = { name = "Transparency" },
--       f = { name = "Find/Telescope" },
--       e = { name = "Explorer" },
--       g = { name = "Git" },
--       c = { name = "Code/LSP" },
--       d = { name = "Debug" },
--       b = { name = "Buffers" },
--       s = { name = "Search/Todo" },
--       h = { name = "Git Hunk" },
--       m = { name = "Format/Meta" },
--       p = { name = "PickMe" },
--     },
--   })
-- end

-- vim: ts=2 sts=2 sw=2 et