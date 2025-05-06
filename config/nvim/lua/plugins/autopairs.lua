-- Auto bracket pairing
return {
  'windwp/nvim-autopairs',
  event = "InsertEnter",
  config = function()
    local autopairs = require('nvim-autopairs')
    
    autopairs.setup({
      check_ts = true, -- Check treesitter for pair matching
      ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
        java = false, -- Don't check treesitter in Java
      },
      disable_filetype = { "TelescopePrompt", "vim" },
      fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment',
      },
    })
    
    -- Add additional rules
    local Rule = require('nvim-autopairs.rule')
    
    -- Add spaces between brackets
    autopairs.add_rules({
      Rule(' ', ' ')
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
        end),
      Rule('( ', ' )')
        :with_pair(function() return false end)
        :with_move(function(opts)
          return opts.prev_char:match('.%)') ~= nil
        end)
        :use_key(')'),
      Rule('{ ', ' }')
        :with_pair(function() return false end)
        :with_move(function(opts)
          return opts.prev_char:match('.%}') ~= nil
        end)
        :use_key('}'),
      Rule('[ ', ' ]')
        :with_pair(function() return false end)
        :with_move(function(opts)
          return opts.prev_char:match('.%]') ~= nil
        end)
        :use_key(']'),
    })

    -- Apply transparency if enabled
    if vim.g.transparent_enabled then
      -- No specific highlight groups to clear for autopairs
      -- but we could add any custom ones if needed
    end
  end,
}