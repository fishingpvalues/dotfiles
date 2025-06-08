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

-- ToggleTerm keymaps
vim.keymap.set('n', '<C-\\>', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal' })
vim.keymap.set('n', '<leader>tt', '<cmd>ToggleTerm<CR>', { desc = 'Toggle Terminal (Horizontal)' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<CR>', { desc = 'Toggle Terminal (Vertical)' })
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<CR>', { desc = 'Toggle Terminal (Float)' })
vim.keymap.set('n', '<leader>ta', '<cmd>ToggleTermToggleAll<CR>', { desc = 'Toggle All Terminals' })
vim.keymap.set('n', '<leader>ts', '<cmd>TermSelect<CR>', { desc = 'Select Terminal' })
vim.keymap.set('n', '<leader>te', function()
  vim.ui.input({ prompt = "TermExec cmd=" }, function(input)
    if input then
      vim.cmd("TermExec cmd=\"" .. input .. "\"")
    end
  end)
end, { desc = 'Exec in Terminal' })
vim.keymap.set("v", "<leader>tsl", function()
  require("toggleterm").send_lines_to_terminal("visual_selection", true, { args = vim.v.count })
end, { desc = "Send selection to terminal" })

-- Overwrite default terminal split
vim.keymap.set('n', '<leader>T', '', { desc = '' }) -- Remove old mapping

-- Register main which-key groups
if pcall(require, 'which-key') then
  local wk = require('which-key')
  local rocket = vim.g.have_nerd_font and '󰜎' or 'Run File'
  wk.register({
    ["<leader>"] = {
      t = {
        name = "Terminal",
        tt = "Toggle Horizontal Terminal",
        tv = "Toggle Vertical Terminal",
        tf = "Toggle Floating Terminal",
        ta = "Toggle All Terminals",
        ts = "Select Terminal",
        te = "Execute in Terminal",
        tsl = "Send Selection to Terminal",
        tg = "Toggle Lazygit",
        th = "Toggle htop",
        tp = "Toggle Python REPL",
      },
      tw = {
        name = "Treewalker",
        h = "Move Left",
        j = "Move Down",
        k = "Move Up",
        l = "Move Right",
        H = "Swap Left",
        J = "Swap Down",
        K = "Swap Up",
        L = "Swap Right",
      },
      df = { "Visualize DataFrame" },
      u = {
        ut = "Git Timetravel (Tardis)",
      },
      f = { name = "Find" },
      e = { name = "Explorer" },
      g = {
        name = "Goto",
        gd = "Go to Definition",
        gD = "Go to Declaration",
        gi = "Go to Implementation",
        gr = "Go to References",
        K = "Show Hover Documentation",
        ["<C-k>"] = "Signature Help",
      },
      c = {
        name = "Code",
        rn = "Rename Symbol",
        ca = "Code Action",
        lf = "Format Buffer",
        wa = "Add Workspace Folder",
        wr = "Remove Workspace Folder",
        wl = "List Workspace Folders",
      },
      d = {
        name = "Debug",
        dpr = "Debug Python Method",
        dpc = "Debug Python Class",
        dps = "Debug Python Selection",
        du = "Toggle Debug UI",
        de = "Evaluate Expression",
        db = "Toggle Breakpoint",
        dB = "Set Conditional Breakpoint",
        dc = "Clear All Breakpoints",
      },
      b = { name = "Buffers" },
      s = {
        name = "Search/Todo",
        st = "Search Todo Comments",
      },
      h = {
        name = "Git Hunk",
        s = "Stage Hunk",
        r = "Reset Hunk",
        S = "Stage Buffer",
        u = "Undo Stage Hunk",
        R = "Reset Buffer",
        p = "Preview Hunk",
        b = "Blame Line",
        d = "Diff Against Index",
        D = "Diff Against Last Commit",
      },
      hT = {
        name = "Hardtime",
        e = { ":Hardtime enable<CR>", "Enable Hardtime" },
        d = { ":Hardtime disable<CR>", "Disable Hardtime" },
        t = { ":Hardtime toggle<CR>", "Toggle Hardtime" },
        r = { ":Hardtime report<CR>", "Hardtime Report" },
      },
      m = {
        name = "Multicursor",
        n = "Add Cursor to Next Match",
        N = "Add Cursor to Previous Match",
        s = "Skip Next Match",
        S = "Skip Previous Match",
        ["<up>"] = "Add Cursor Above",
        ["<down>"] = "Add Cursor Below",
        ["<leader><up>"] = "Skip Cursor Above",
        ["<leader><down>"] = "Skip Cursor Below",
        x = "Delete Current Cursor",
        ["<c-q>"] = "Toggle Multicursor Mode",
      },
      p = { name = "PickMe" },
      w = {
        name = "Window/Splits",
        ["<C-h>"] = "Move to left split/pane",
        ["<C-j>"] = "Move to lower split/pane",
        ["<C-k>"] = "Move to upper split/pane",
        ["<C-l>"] = "Move to right split/pane",
        ["<C-\\>"] = "Move to previous split/pane",
        ["<A-h>"] = "Resize split left",
        ["<A-j>"] = "Resize split down",
        ["<A-k>"] = "Resize split up",
        ["<A-l>"] = "Resize split right",
        ["<leader><leader>h"] = "Swap buffer left",
        ["<leader><leader>j"] = "Swap buffer down",
        ["<leader><leader>k"] = "Swap buffer up",
        ["<leader><leader>l"] = "Swap buffer right",
      },
    },
    ["<C-h>"] = "Move to left pane (Wezterm/Nvim)",
    ["<C-j>"] = "Move to lower pane (Wezterm/Nvim)",
    ["<C-k>"] = "Move to upper pane (Wezterm/Nvim)",
    ["<C-l>"] = "Move to right pane (Wezterm/Nvim)",
  })
end

-- Register <leader>rf in which-key for code_runner.nvim
if pcall(require, 'which-key') then
  local wk = require('which-key')
  local rocket = vim.g.have_nerd_font and '󰜎' or 'Run File'
  wk.register({
    ["<leader>rf"] = { ':RunFile<CR>', rocket .. ' Run current file (code_runner)' },
  })
end

-- Terminal window navigation (in terminal mode)
function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\\><C-n><C-w>]], opts)
end
vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')

-- Bear.nvim DataFrame visualisation
vim.keymap.set('n', '<leader>df', function()
  local ok, bear = pcall(require, 'bear')
  if ok and bear.visualise then
    bear.visualise()
  else
    vim.notify('bear.nvim is not available or not loaded!', vim.log.levels.ERROR, {title = 'bear.nvim'})
  end
end, { desc = 'Visualise DataFrame (bear.nvim)' })

-- Treewalker keymaps
vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true, desc = 'Treewalker Up' })
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true, desc = 'Treewalker Down' })
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true, desc = 'Treewalker Left' })
vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true, desc = 'Treewalker Right' })
vim.keymap.set('n', '<C-S-k>', '<cmd>Treewalker SwapUp<cr>', { silent = true, desc = 'Treewalker Swap Up' })
vim.keymap.set('n', '<C-S-j>', '<cmd>Treewalker SwapDown<cr>', { silent = true, desc = 'Treewalker Swap Down' })
vim.keymap.set('n', '<C-S-h>', '<cmd>Treewalker SwapLeft<cr>', { silent = true, desc = 'Treewalker Swap Left' })
vim.keymap.set('n', '<C-S-l>', '<cmd>Treewalker SwapRight<cr>', { silent = true, desc = 'Treewalker Swap Right' })

-- Smart Splits keymaps (navigation, resizing, swapping)
do
  local ok, smart_splits = pcall(require, 'smart-splits')
  if not ok then
    vim.schedule(function()
      vim.notify('smart-splits.nvim failed to load!', vim.log.levels.ERROR, {title = 'smart-splits.nvim'})
    end)
    return
  end
  -- Navigation between splits (works with WezTerm/tmux/Kitty panes)
  vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { desc = 'Move to left split/pane' })
  vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { desc = 'Move to lower split/pane' })
  vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { desc = 'Move to upper split/pane' })
  vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { desc = 'Move to right split/pane' })
  vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous, { desc = 'Move to previous split/pane' })
  -- Resizing splits
  vim.keymap.set('n', '<A-h>', smart_splits.resize_left, { desc = 'Resize split left' })
  vim.keymap.set('n', '<A-j>', smart_splits.resize_down, { desc = 'Resize split down' })
  vim.keymap.set('n', '<A-k>', smart_splits.resize_up, { desc = 'Resize split up' })
  vim.keymap.set('n', '<A-l>', smart_splits.resize_right, { desc = 'Resize split right' })
  -- Buffer swapping
  vim.keymap.set('n', '<leader><leader>h', smart_splits.swap_buf_left, { desc = 'Swap buffer left' })
  vim.keymap.set('n', '<leader><leader>j', smart_splits.swap_buf_down, { desc = 'Swap buffer down' })
  vim.keymap.set('n', '<leader><leader>k', smart_splits.swap_buf_up, { desc = 'Swap buffer up' })
  vim.keymap.set('n', '<leader><leader>l', smart_splits.swap_buf_right, { desc = 'Swap buffer right' })
end

-- Minimalist "hacker" workflow: open a terminal split and run your file manually
-- Example: :split | terminal, then type your command (e.g., python %, bash %, ./file)
vim.keymap.set('n', '<leader>t', ':split | terminal<CR>', { desc = 'Open terminal in split' })

-- Debug: F5 for dap.continue
local function debug_continue()
  local ok, dap = pcall(require, 'dap')
  if ok and dap.continue then
    dap.continue()
  else
    vim.notify('nvim-dap not available', vim.log.levels.ERROR)
  end
end

vim.keymap.set('n', '<F5>', debug_continue, { desc = 'Start/Continue Debugging (F5)' })

-- Keymap for running current file with code_runner.nvim
vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', { noremap = true, silent = false, desc = 'Run current file (code_runner)' })

-- vim: ts=2 sts=2 sw=2 et