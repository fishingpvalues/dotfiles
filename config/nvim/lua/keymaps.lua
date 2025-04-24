-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will try without reading `:help terminal`
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize with arrows
vim.keymap.set('n', '<C-Up>', ':resize +2<CR>', { desc = 'Increase window height' })
vim.keymap.set('n', '<C-Down>', ':resize -2<CR>', { desc = 'Decrease window height' })
vim.keymap.set('n', '<C-Left>', ':vertical resize -2<CR>', { desc = 'Decrease window width' })
vim.keymap.set('n', '<C-Right>', ':vertical resize +2<CR>', { desc = 'Increase window width' })

-- Move Lines
vim.keymap.set('n', '<A-j>', "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set('n', '<A-k>', "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set('i', '<A-j>', "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set('i', '<A-k>', "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set('v', '<A-j>', ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set('v', '<A-k>', ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Indent/Dedent in visual mode
vim.keymap.set('v', '<', '<gv', { desc = "Indent left and reselect" })
vim.keymap.set('v', '>', '>gv', { desc = "Indent right and reselect" })

-- Toggle transparent background
vim.keymap.set('n', '<leader>tt', function()
    vim.g.transparent_enabled = not vim.g.transparent_enabled
    if vim.g.transparent_enabled then
        vim.cmd("TransparentEnable")
        print("Transparency enabled")
    else
        vim.cmd("TransparentDisable")
        print("Transparency disabled")
    end
end, { desc = 'Toggle transparency' })

-- vim: ts=2 sts=2 sw=2 et