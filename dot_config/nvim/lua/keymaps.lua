local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Window navigation without the <C-w> prefix.
map("n", "<C-h>", "<C-w><C-h>", { desc = "Window left" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Window right" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Window down" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Window up" })

-- Move the selection, reindenting as it goes.
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the cursor put while joining, and centred while paging.
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Paste over a selection without losing the register.
map("x", "<leader>p", [["_dP]], { desc = "Paste, keep register" })
-- Delete without clobbering the yank.
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete to black hole" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Write" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- Diagnostics
map("n", "<leader>xd", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>xf", function() vim.diagnostic.open_float() end, { desc = "Diagnostic float" })
