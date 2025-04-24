-- Telescope fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
  },
  config = function()
    local telescope = require('telescope')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ['<C-u>'] = false,
            ['<C-d>'] = false,
            ['<C-j>'] = actions.move_selection_next,
            ['<C-k>'] = actions.move_selection_previous,
          },
          n = {
            ['q'] = actions.close,
          },
        },
        file_ignore_patterns = { "node_modules", ".git/" },
        -- Enable transparency
        borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
        color_devicons = true,
        winblend = vim.g.transparent_enabled and 10 or 0,
      },
      pickers = {
        find_files = {
          hidden = true,
        },
      },
    })

    -- Enable telescope fzf native, if installed
    pcall(telescope.load_extension, 'fzf')

    -- Keymaps
    local keymap = vim.keymap.set
    
    keymap('n', '<leader>sf', require('telescope.builtin').find_files, { desc = 'Search Files' })
    keymap('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = 'Search Help' })
    keymap('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = 'Search Word under cursor' })
    keymap('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = 'Search Grep' })
    keymap('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = 'Search Diagnostics' })
    keymap('n', '<leader>sr', require('telescope.builtin').oldfiles, { desc = 'Search Recent Files' })
    keymap('n', '<leader><space>', require('telescope.builtin').buffers, { desc = 'Search Open Buffers' })
    keymap('n', '<leader>sb', require('telescope.builtin').buffers, { desc = 'Search Buffers' })
    
    -- Git search
    keymap('n', '<leader>gc', require('telescope.builtin').git_commits, { desc = 'Search Git Commits' })
    keymap('n', '<leader>gs', require('telescope.builtin').git_status, { desc = 'Search Git Status' })
    
    -- Apply transparency fix
    if vim.g.transparent_enabled then
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "TelescopePrompt",
        callback = function()
          vim.defer_fn(function()
            require('transparent').clear_prefix('Telescope')
          end, 10)
        end,
      })
    end
  end,
}