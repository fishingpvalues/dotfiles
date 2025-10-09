-- nvim-bqf: Better quickfix window
return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  config = function()
    require("bqf").setup {
      auto_enable = true,
      preview = {
        win_height = 15,
        win_vheight = 15,
        delay_syntax = 50,
        border_chars = { "|", "|", "|", "|", "|", "|", "-", "-" },
      },
      func_map = {
        open = "<CR>",
        openc = "o",
        drop = "O",
        split = "s",
        vsplit = "v",
        tab = "t",
        tabc = "T",
        prevfile = "<C-p>",
        nextfile = "<C-n>",
        prevhist = "<",
        nexthist = ">",
        lastleave = [[\]],
        stoggleup = "K",
        stoggledown = "J",
        stogglevm = "<Tab>",
        stogglebuf = "<Space>"
      },
      filter = {
        fzf = {
          action_for = { ['ctrl-s'] = 'split', ['ctrl-v'] = 'vsplit', ['ctrl-t'] = 'tab' },
          extra_opts = { '--bind', 'ctrl-o:toggle-all', '--prompt', 'QF> ' },
        }
      }
    }
  end,
} 