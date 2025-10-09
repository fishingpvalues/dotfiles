-- Kubernetes and DevOps tooling
return {
  {
    -- Kubernetes YAML support and validation
    'towolf/vim-helm',
    ft = { 'helm', 'yaml' },
  },
  {
    -- Enhanced YAML support for Kubernetes
    'cuducos/yaml.nvim',
    ft = { 'yaml' },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('yaml').setup({
        ft = { 'yaml', 'yaml.ansible', 'yaml.docker-compose' },
      })
    end,
  },
  {
    -- Docker and docker-compose support
    'esensar/nvim-dev-container',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('devcontainer').setup({})
    end,
    keys = {
      { '<leader>dc', '<cmd>DevcontainerStart<cr>', desc = 'Start dev container' },
      { '<leader>ds', '<cmd>DevcontainerStop<cr>', desc = 'Stop dev container' },
    },
  },
}