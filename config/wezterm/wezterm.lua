local wezterm = require('wezterm')
local act = wezterm.action
local config = {}

-- Use the config_builder which will help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Load GitHub Dark theme
config.color_scheme_dirs = { 'colors' }
config.color_scheme = 'GitHub Dark'

-- Font configuration
config.font = wezterm.font_with_fallback {
  'FiraCode Nerd Font',
  'CaskaydiaCove NF',
  'JetBrains Mono',
  'Cascadia Code',
}
config.font_size = 12.0
config.line_height = 1.1

-- Window appearance with blur effect
config.window_background_opacity = 0.5
config.window_decorations = "TITLE | RESIZE"
config.window_padding = {
  left = 10,
  right = 10,
  top = 10,
  bottom = 10,
}
-- Enable blur effect on Windows and other platforms that support it
config.win32_system_backdrop = "Acrylic" -- Windows 11 acrylic effect
config.macos_window_background_blur = 20 -- macOS blur
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = 'AlwaysPrompt'
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- Tab bar appearance
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = true

-- Cursor configuration
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 800
config.cursor_thickness = 2

-- Terminal bell
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
  target = 'CursorColor',
}

-- Disable annoying close confirmation
config.skip_close_confirmation_for_processes_named = {
  'bash', 'sh', 'zsh', 'fish', 'tmux', 'nu', 'cmd.exe', 'powershell.exe', 'pwsh.exe'
}

-- Scrollback and viewport
config.scrollback_lines = 10000
config.enable_scroll_bar = true

-- Smart copy behavior
config.automatically_reload_config = true
config.selection_word_boundary = " \t\n{}[]()\"'`,;:"

-- Right click behavior
config.mouse_bindings = {
  -- Right click pastes from the clipboard
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.PasteFrom('Clipboard'),
  },
}

-- Key Bindings
config.keys = {
  -- Tab management
  {
    key = 't',
    mods = 'CTRL|SHIFT',
    action = act.SpawnTab 'CurrentPaneDomain',
  },
  {
    key = 'w',
    mods = 'CTRL|SHIFT',
    action = act.CloseCurrentTab { confirm = true },
  },

  -- Split panes
  {
    key = '|',
    mods = 'CTRL|SHIFT',
    action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = act.SplitVertical { domain = 'CurrentPaneDomain' },
  },

  -- Navigate panes
  {
    key = 'LeftArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Left',
  },
  {
    key = 'RightArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Right',
  },
  {
    key = 'UpArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Up',
  },
  {
    key = 'DownArrow',
    mods = 'ALT',
    action = act.ActivatePaneDirection 'Down',
  },

  -- Resize Panes
  {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Left', 2 },
  },
  {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Right', 2 },
  },
  {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Up', 2 },
  },
  {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = act.AdjustPaneSize { 'Down', 2 },
  },

  -- Font size
  {
    key = '=',
    mods = 'CTRL',
    action = act.IncreaseFontSize,
  },
  {
    key = '-',
    mods = 'CTRL',
    action = act.DecreaseFontSize,
  },
  {
    key = '0',
    mods = 'CTRL',
    action = act.ResetFontSize,
  },
}

-- Define separate configurations for different operating systems
local os_name = wezterm.target_triple

if os_name:find("windows") then
  -- Windows-specific settings
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
  config.launch_menu = {
    { label = "PowerShell", args = { "pwsh.exe", "-NoLogo" } },
    { label = "Command Prompt", args = { "cmd.exe" } },
    { label = "Git Bash", args = { "bash.exe", "-i", "-l" } },
  }
elseif os_name:find("linux") then
  -- Linux-specific settings
  config.default_prog = { '/usr/bin/zsh' }
  config.launch_menu = {
    { label = "Zsh", args = { "zsh", "-l" } },
    { label = "Bash", args = { "bash", "-l" } },
    { label = "Fish", args = { "fish", "-l" } },
  }
elseif os_name:find("darwin") then
  -- macOS-specific settings
  config.default_prog = { '/bin/zsh' }
  config.launch_menu = {
    { label = "Zsh", args = { "zsh", "-l" } },
    { label = "Bash", args = { "bash", "-l" } },
    { label = "Fish", args = { "fish", "-l" } },
  }
end

-- Optional: Background wallpaper (uncomment to enable)
-- config.window_background_image = wezterm.home_dir .. "/Pictures/Wallpapers/forest/belinda-fewings-mwEwys0CWog-unsplash.jpg"
-- config.window_background_image_hsb = {
--   brightness = 0.1,
--   saturation = 0.5,
--   hue = 1.0,
-- }

-- To show fastfetch/neofetch on shell startup, ensure your shell rc file (e.g., .bashrc, .zshrc, PowerShell profile) includes the fastfetch/neofetch logic. WezTerm will run your shell, which will display the info automatically.

-- Add tabline.wez plugin
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
local battery = wezterm.plugin.require("https://github.com/rootiest/battery.wez")
battery.invert = true
battery.apply_to_config(config)

-- Remove custom used_ram and network_usage from tabline_x, use only built-in plugin components

tabline.setup({
  options = {
    icons_enabled = true,
    theme = 'GitHub Dark',
    tabs_enabled = true,
    section_separators = { left = '│', right = '│' },
    component_separators = { left = '│', right = '│' },
    tab_separators = { left = '│', right = '│' },
  },
  sections = {
    tabline_a = {},
    tabline_b = { 'workspace', 'hostname' },
    tabline_c = { 'cwd', 'process' },
    tab_active = {
      'index',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu', 'network' },
    tabline_y = { 'datetime' },
    tabline_z = { battery.get_battery_icons },
  },
  extensions = {},
})

tabline.apply_to_config(config)
config.tab_bar_at_bottom = true

-- wezterm-tmux-navigator (seamless pane/tmux navigation)
-- Removed broken plugin reference; use built-in key bindings below

local act = wezterm.action
config.keys = config.keys or {}
for _, key in ipairs({
  {key="LeftArrow",  mods="CTRL|SHIFT", action=act.ActivatePaneDirection("Left")},
  {key="DownArrow",  mods="CTRL|SHIFT", action=act.ActivatePaneDirection("Down")},
  {key="UpArrow",    mods="CTRL|SHIFT", action=act.ActivatePaneDirection("Up")},
  {key="RightArrow", mods="CTRL|SHIFT", action=act.ActivatePaneDirection("Right")},
}) do
  table.insert(config.keys, key)
end

-- Enable SSH multiplexing
config.ssh_domains = wezterm.default_ssh_domains()

-- Enable QuickSelect for URLs and file paths
config.quick_select_patterns = {
  "https?://\\S+",
  "/[\\w\\-./]+",
}

-- Add modal.wezterm plugin
config.colors = wezterm.get_builtin_color_schemes()[config.color_scheme]
local modal = wezterm.plugin.require("https://github.com/MLFlexer/modal.wezterm")
modal.apply_to_config(config)

-- Add presentation.wez plugin
local presentation = wezterm.plugin.require("https://gitlab.com/xarvex/presentation.wez")
presentation.apply_to_config(config, {
  font_size_multiplier = 1.8,
  presentation = {
    keybind = { key = "o", mods = "CTRL|ALT" },
  },
  presentation_full = {
    keybind = { key = "o", mods = "CTRL|ALT|SHIFT" },
    font_size_multiplier = 2.4,
    font_weight = "Bold",
  },
})

return config