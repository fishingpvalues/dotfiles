-- nvim_json_graph_view: JSON graph explorer for Neovim
-- https://github.com/Owen-Dechow/nvim_json_graph_view
-- NOTE: This plugin may be deprecated. Disabled to prevent errors.
-- Alternative: Use built-in JSON folding or jq for JSON manipulation
return {
    "Owen-Dechow/nvim_json_graph_view",
    enabled = false,  -- Disabled due to deprecation warnings
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        editor_type = "split", -- split or floating
        floating_editor_style = {
            margin = 2,
            border = "double",
            zindex = 10,
        },
        accept_all_files = false, -- Only open .json files by default
        max_lines = 10, -- Collapse nodes after 10 lines for large JSON
        round_units = true, -- Use rounded units for aesthetics
        round_connections = true, -- Use rounded connections for clarity
        disable_line_wrap = true, -- Prevent line wrapping in graph buffer
        keymap_priorities = {
            expand = 4,
            collapse = 2,
            link_forward = 3,
            link_backward = 3,
            set_as_root = 1,
        },
        keymaps = {
            expand = "E", -- Expand collapsed areas
            collapse = "C", -- Collapse expanded areas
            link_forward = "L", -- Jump to linked unit
            link_backward = "B", -- Jump back to parent
            set_as_root = "R", -- Set current unit as root
            quick_action = "<CR>", -- Quick action (first priority)
            close_window = "q", -- Close the window
            -- SOTA: Add help and toggle collapse/expand all if supported in future
        },
    },
    config = function(_, opts)
        require("json_graph_view").setup(opts)
        -- Optional: Keymap to open JSON Graph View
        vim.api.nvim_create_user_command("JsonGraphView", function()
            require("json_graph_view").open()
        end, { desc = "Open JSON Graph View" })
    end,
} 