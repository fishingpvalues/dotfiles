-- jupynium.nvim: Jupyter notebook integration for data science
return {
  'kiyoon/jupynium.nvim',
  build = 'pip3 install --user .',
  dependencies = {
    'rcarriga/nvim-notify',
    'stevearc/dressing.nvim',
  },
  ft = { 'python', 'jupyter' },
  keys = {
    { '<leader>js', '<cmd>JupyniumStartAndAttachToServer<cr>', desc = 'Start Jupynium server' },
    { '<leader>jc', '<cmd>JupyniumStartSync<cr>', desc = 'Start Jupynium sync' },
    { '<leader>jr', '<cmd>JupyniumExecuteSelectedCells<cr>', desc = 'Execute selected cells', mode = { 'n', 'v' } },
    { '<leader>ja', '<cmd>JupyniumKernelHover<cr>', desc = 'Jupyter hover' },
  },
  config = function()
    require('jupynium').setup({
      python_host = { 'python3', '-m', 'jupynium', '--sock' },
      default_notebook_URL = 'localhost:8888',

      -- Auto download notebook dependencies
      auto_download_ipynb = true,

      -- Sync settings
      auto_close_tab = true,
      auto_start_server = {
        enable = false,
        file_pattern = { '*.ju.py', '*.jupyter.py' },
      },

      -- Textobjects
      textobjects = {
        use_default_keybindings = true,
      },

      -- Syntax highlighting
      syntax_highlight = {
        enable = true,
      },

      -- Shortsighted mode for large notebooks
      shortsighted = false,
    })
  end,
}