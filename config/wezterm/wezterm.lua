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
config.window_background_opacity = 0.7
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

-- Status bar: CPU, RAM, and time (Windows)
wezterm.on('update-right-status', function(window, pane)
  local time = wezterm.strftime('%H:%M:%S')
  local cpu = ''
  local ram = ''
  -- Nerd Font icons
  local clock_icon = '󰥔'
  local cpu_icon = '󰍛'
  local ram_icon = '󰍛'
  if wezterm.target_triple:find('windows') then
    -- Get CPU usage (average of all cores)
    local cpu_out = wezterm.run_child_process({'powershell', '-NoProfile', '-Command', "Get-CimInstance Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select -ExpandProperty Average"})
    if cpu_out and #cpu_out > 0 then
      cpu = string.format('%s %s%%', cpu_icon, cpu_out:gsub('\n', ''))
    end
    -- Get RAM usage (used/total in GB)
    local ram_out = wezterm.run_child_process({'powershell', '-NoProfile', '-Command', "Get-CimInstance Win32_OperatingSystem | ForEach-Object { [math]::Round(($_.TotalVisibleMemorySize- $_.FreePhysicalMemory)/1MB,1) }"})
    local ram_total = wezterm.run_child_process({'powershell', '-NoProfile', '-Command', "Get-CimInstance Win32_OperatingSystem | ForEach-Object { [math]::Round($_.TotalVisibleMemorySize/1MB,1) }"})
    if ram_out and ram_total and #ram_out > 0 and #ram_total > 0 then
      ram = string.format('%s %s/%sGB', ram_icon, ram_out:gsub('\n', ''), ram_total:gsub('\n', ''))
    end
  end
  window:set_right_status(wezterm.format({
    {Text = string.format('%s %s   %s   %s', clock_icon, time, cpu, ram)}
  }))
end)

-- bar.wezterm (SOTA status/tab bar)
local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
  position = "bottom",
  max_width = 32,
  padding = {
    left = 1,
    right = 1,
    tabs = { left = 0, right = 2 },
  },
  separator = {
    space = 1,
    left_icon = wezterm.nerdfonts.fa_long_arrow_right,
    right_icon = wezterm.nerdfonts.fa_long_arrow_left,
    field_icon = wezterm.nerdfonts.indent_line,
  },
  modules = {
    tabs = { active_tab_fg = 4, inactive_tab_fg = 6, new_tab_fg = 2 },
    workspace = { enabled = true, icon = wezterm.nerdfonts.cod_window, color = 8 },
    leader = { enabled = true, icon = wezterm.nerdfonts.oct_rocket, color = 2 },
    pane = { enabled = true, icon = wezterm.nerdfonts.cod_multiple_windows, color = 7 },
    username = { enabled = true, icon = wezterm.nerdfonts.fa_user, color = 6 },
    hostname = { enabled = true, icon = wezterm.nerdfonts.cod_server, color = 8 },
    clock = { enabled = true, icon = wezterm.nerdfonts.md_calendar_clock, format = "%H:%M", color = 5 },
    cwd = { enabled = true, icon = wezterm.nerdfonts.oct_file_directory, color = 7 },
    -- Uncomment to enable Spotify integration (requires spotify-tui)
    -- spotify = { enabled = true, icon = wezterm.nerdfonts.fa_spotify, color = 3, max_width = 64, throttle = 15 },
  },
})

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

return config 