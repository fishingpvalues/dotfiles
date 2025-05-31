local M = {}

local icons = {
  files = vim.g.have_nerd_font and '󰥨 ' or 'Files',
  dotfiles = vim.g.have_nerd_font and '󱁿 ' or 'Dotfiles',
  app = vim.g.have_nerd_font and '󱓞 ' or 'Apps',
}

local function notify_missing(what, icon, extra)
  vim.schedule(function()
    vim.notify((icon or '') .. ' ' .. what .. ' is not available.' .. (extra or ''), vim.log.levels.WARN, {title = 'Dashboard'})
  end)
end

local function has_cmd(cmd)
  return vim.fn.exepath(cmd) ~= ''
end

local function dir_exists(path)
  return vim.fn.isdirectory(vim.fn.expand(path)) == 1
end

M.files_shortcut_action = function()
  if not has_cmd('rg') then
    notify_missing('ripgrep (rg)', icons.files, ' Please install ripgrep to use file search.')
    return
  end
  vim.cmd('Telescope find_files')
end

M.dotfiles_shortcut_action = function()
  -- XDG does not standardize a home variable; HOME is the standard for the user's home directory.
  -- If you want XDG_CONFIG_HOME (for configs), use that instead.
  local home = os.getenv('HOME')
  if not home or home == '' then
    notify_missing('HOME environment variable', icons.dotfiles, ' Not set.')
    return
  end
  if not dir_exists(home) then
    notify_missing('HOME directory', icons.dotfiles, ' ' .. home .. ' not found.')
    return
  end
  vim.cmd('Telescope find_files cwd=' .. home)
end

M.yazi_shortcut_action = function()
  if not has_cmd('yazi') then
    notify_missing('Yazi file manager', '󰙅', ' Please install yazi and add to PATH.')
    return
  end
  vim.cmd('Yazi')
end

M.mru_action = function()
  local ok = pcall(require, 'telescope.builtin')
  if ok then
    require('telescope.builtin').oldfiles({
      only_cwd = false,
    })
  else
    vim.notify('Telescope not available', vim.log.levels.WARN)
  end
end

M.recent_sessions_action = function()
  local ok, persisted = pcall(require, 'persisted')
  if not ok then
    vim.notify('persisted.nvim not available', vim.log.levels.WARN)
    return
  end
  -- Use Telescope integration if available
  if persisted.telescope then
    vim.cmd('Telescope persisted')
  else
    -- Fallback: show a simple session picker
    persisted.load({ last = true })
  end
end

return M 