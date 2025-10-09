-- sort.nvim: SOTA sorting plugin for Neovim (line-wise, delimiter, natural sort)
-- https://github.com/sQVe/sort.nvim
return {
    "sQVe/sort.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("sort").setup({
            delimiters = { ',', '|', ';', ':', 's', 't' },
            natural_sort = true,
            whitespace = { alignment_threshold = 3 },
            mappings = {
                operator = 'go',
                textobject = {
                    inner = 'io',
                    around = 'ao',
                },
                motion = {
                    next_delimiter = ']o',
                    prev_delimiter = '[o',
                },
            },
        })
    end,
}
