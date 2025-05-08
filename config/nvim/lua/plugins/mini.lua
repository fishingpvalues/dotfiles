-- Minimal plugins from mini.nvim collection
return {
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    require('mini.ai').setup({
      n_lines = 500,
    })

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    require('mini.surround').setup({
      mappings = {
        add = 'sa',
        delete = 'sd',
        find = 'sf',
        find_left = 'sF',
        highlight = 'sh',
        replace = 'sr',
        update_n_lines = 'sn',
      },
    })

    -- Add highlighting for matching pairs
    require('mini.pairs').setup({
      -- Which brackets to match
      pairs = {
        { '(', ')' },
        { '[', ']' },
        { '{', '}' },
        { '<', '>' },
      },
      -- Characters used for "string" and "single character" modes
      modes = {
        insert = true,
        command = false,
        terminal = false,
      },
    })

    -- Simple and easy statusline
    -- require('mini.statusline').setup({
    --   set_vim_settings = true,
    --   use_icons = true,
    -- })

    -- Better comment operations
    require('mini.comment').setup({
      options = {
        custom_commentstring = nil,
        ignore_blank_line = false,
        start_of_line = false,
        pad_comment_parts = true,
      },
      mappings = {
        -- Toggle comment (like `gcip` - comment inner paragraph) for both
        -- Normal and Visual modes
        comment = 'gc',
        -- Toggle comment on current line
        comment_line = 'gcc',
        -- Define 'comment' textobject (like `dgc` - delete whole comment block)
        textobject = 'gc',
      },
      hooks = {
        pre = function() end,
        post = function() end,
      },
    })

    -- Better buffer handling
    require('mini.bufremove').setup({})
  end,
}