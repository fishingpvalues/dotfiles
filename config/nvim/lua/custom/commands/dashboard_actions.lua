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
  if not dir_exists('~/dotfiles') then
    notify_missing('dotfiles directory', icons.dotfiles, ' ~/dotfiles not found.')
    return
  end
  if not has_cmd('chezmoi') then
    notify_missing('chezmoi', icons.dotfiles, ' Please install chezmoi to manage dotfiles.')
    return
  end
  vim.cmd('Telescope find_files cwd=~/dotfiles')
end

M.yazi_shortcut_action = function()
  if not has_cmd('yazi') then
    notify_missing('Yazi file manager', '󰙅', ' Please install yazi and add to PATH.')
    return
  end
  vim.cmd('Yazi')
end

M.apps_shortcut_action = function()
  local apps_dir = nil
  if vim.fn.has('win32') == 1 then
    apps_dir = '~/AppData/Local/Microsoft/WindowsApps'
  elseif vim.fn.has('macunix') == 1 then
    apps_dir = '/Applications'
  elseif vim.fn.has('unix') == 1 then
    apps_dir = '/usr/share/applications'
  end
  if not has_cmd('rg') then
    notify_missing('ripgrep (rg)', icons.app, ' Please install ripgrep to use this shortcut.')
    return
  end
  if not apps_dir or not dir_exists(apps_dir) then
    notify_missing('Apps directory', icons.app, ' Not found for this OS.')
    return
  end
  vim.cmd('Telescope find_files cwd=' .. vim.fn.expand(apps_dir))
end

M.new_project_action = function()
  vim.ui.input({ prompt = 'Project name: ' }, function(name)
    if not name or name == '' then return end
    local base = vim.fn.expand('~/Projects')
    if vim.fn.isdirectory(base) == 0 then vim.fn.mkdir(base, 'p') end
    local project_dir = base .. '/' .. name
    if vim.fn.isdirectory(project_dir) == 0 then
      vim.fn.mkdir(project_dir, 'p')
      vim.notify('Created project: ' .. project_dir, vim.log.levels.INFO)
    end
    vim.cmd('cd ' .. project_dir)
    vim.cmd('Telescope find_files cwd=' .. project_dir)
  end)
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

return M 