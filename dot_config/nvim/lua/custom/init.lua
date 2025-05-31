-- custom/init.lua
-- Entrypoint for all custom modules (commands, plugins, etc.)
-- Extend this file to load any new customizations

-- Load custom commands
require('custom.commands.toggle_icons').setup()
require('custom.commands.navic_winbar').setup()

-- Optionally, load all custom plugins (if not already loaded via lazy-plugins)
-- Example:
-- require('custom.plugins.lualine')
-- require('custom.plugins.trouble')
-- ...

-- Add more custom modules here as needed 