-- vim-coach.nvim: Identify and correct inefficient Vim usage habits
-- https://github.com/xiantang/coach.nvim
-- NOTE: Keylogger component only works on macOS, disabled on Linux
return {
    "xiantang/coach.nvim",
    enabled = false, -- Disabled: keylogger component doesn't compile on Linux
    build = "bash ./install.sh",
    event = "VeryLazy",
    config = function()
        require("coach").setup({
            -- SOTA: Use default settings for best experience
        })
    end,
}
