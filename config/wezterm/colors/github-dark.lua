-- GitHub Dark Theme for WezTerm
-- Based on GitHub's dark theme colors

return {
  -- The default text color
  foreground = "#c9d1d9",
  -- The default background color
  background = "#0d1117",

  -- Overrides the cell background color when the current cell is occupied by the
  -- cursor and the cursor style is set to Block
  cursor_bg = "#58a6ff",
  -- Overrides the text color when the current cell is occupied by the cursor
  cursor_fg = "#0d1117",
  -- Specifies the border color of the cursor when the cursor style is set to Block,
  -- or the color of the vertical or horizontal bar when the cursor style is set to
  -- Bar or Underline.
  cursor_border = "#58a6ff",

  -- the foreground color of selected text
  selection_fg = "#ffffff",
  -- the background color of selected text
  selection_bg = "#264f78",

  -- The color of the scrollbar "thumb"; the portion that represents the current viewport
  scrollbar_thumb = "#484f58",

  -- The color of the split lines between panes
  split = "#444c56",

  ansi = {
    "#484f58", -- black
    "#ff7b72", -- red
    "#3fb950", -- green
    "#d29922", -- yellow
    "#58a6ff", -- blue
    "#bc8cff", -- magenta/purple
    "#39c5cf", -- cyan
    "#b1bac4", -- white
  },
  brights = {
    "#6e7681", -- bright black
    "#ffa198", -- bright red
    "#56d364", -- bright green
    "#e3b341", -- bright yellow
    "#79c0ff", -- bright blue
    "#d2a8ff", -- bright magenta/purple
    "#56d4dd", -- bright cyan
    "#f0f6fc", -- bright white
  },

  -- When the IME, a dead key or a leader key are being processed and are effectively
  -- holding input pending the result of input composition, change the cursor
  -- to this color to give a visual cue about the compose state.
  compose_cursor = "#d2a8ff",

  -- Colors for copy_mode and quick_select
  -- available since: 20220807-113146-c2fee766
  -- In copy_mode, the color of the active text is:
  -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
  -- 2. selection_* otherwise
  copy_mode_active_highlight_bg = { Color = "#264f78" },
  copy_mode_active_highlight_fg = { Color = "#ffffff" },
  copy_mode_inactive_highlight_bg = { Color = "#30363d" },
  copy_mode_inactive_highlight_fg = { Color = "#c9d1d9" },

  quick_select_label_bg = { Color = "#264f78" },
  quick_select_label_fg = { Color = "#ffffff" },
  quick_select_match_bg = { Color = "#30363d" },
  quick_select_match_fg = { Color = "#58a6ff" },

  -- Tab bar colors
  tab_bar = {
    background = "#161b22",
    active_tab = {
      bg_color = "#0d1117",
      fg_color = "#f0f6fc",
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#161b22",
      fg_color = "#8b949e",
    },
    inactive_tab_hover = {
      bg_color = "#30363d",
      fg_color = "#c9d1d9",
      italic = false,
    },
    new_tab = {
      bg_color = "#161b22",
      fg_color = "#8b949e",
    },
    new_tab_hover = {
      bg_color = "#30363d",
      fg_color = "#c9d1d9",
      italic = false,
    },
  },

  -- Visual bell animation
  visual_bell = "#58a6ff",
}