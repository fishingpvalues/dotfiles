local wezterm = require('wezterm')
local act = wezterm.action
local config = {}

-- Use the config_builder which will help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Load GitHub Dark theme
config.color_scheme_dirs = { 'colors' }
config.color_scheme = 'github-dark'

-- Font configuration
config.font = wezterm.font_with_fallback {
  'CaskaydiaCove NF',
  'JetBrains Mono',
  'Cascadia Code',
}
config.font_size = 12.0
config.line_height = 1.1

-- Window appearance with blur effect
config.window_background_opacity = 0.85
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
  -- Transparency controls
  {
    key = ']',
    mods = 'ALT|CTRL',
    action = act.IncrementOpacity,
  },
  {
    key = '[',
    mods = 'ALT|CTRL',
    action = act.DecrementOpacity,
  },
  {
    key = '\\',
    mods = 'ALT|CTRL',
    action = act.ResetOpacity,
  },

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

return config