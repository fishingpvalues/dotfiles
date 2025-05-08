-- DAP (Debug Adapter Protocol) setup for Python
return {
  'mfussenegger/nvim-dap-python',
  dependencies = {
    'mfussenegger/nvim-dap',
    'rcarriga/nvim-dap-ui',
  },
  config = function()
    local dap_python = require('dap-python')
    
    -- Get Python path with better error handling
    local function get_python_path()
      -- Try Mason's debugpy installation first
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local mason_python = mason_path .. "/packages/debugpy/venv/"
                         .. (vim.fn.has('win32') == 1 and "Scripts/python.exe" or "bin/python")
      
      if vim.fn.filereadable(mason_python) == 1 then
        return mason_python
      end
      
      -- Check for virtual environments
      local venv_path = os.getenv("VIRTUAL_ENV")
      if venv_path and venv_path ~= "" then
        -- Handle both Windows and Unix paths
        local is_windows = vim.fn.has('win32') == 1
        local separator = is_windows and '\\' or '/'
        local python_exec = is_windows and 'python.exe' or 'python'
        local path = venv_path .. separator .. (is_windows and 'Scripts' .. separator or 'bin' .. separator) .. python_exec
        
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
      
      -- Check for conda/miniforge environments
      local conda_prefix = os.getenv("CONDA_PREFIX")
      if conda_prefix and conda_prefix ~= "" then
        local is_windows = vim.fn.has('win32') == 1
        local separator = is_windows and '\\' or '/'
        local path = conda_prefix .. separator .. (is_windows and 'python.exe' or 'bin' .. separator .. 'python')
        
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
      
      -- Try popular miniforge locations
      local home = os.getenv("HOME") or os.getenv("USERPROFILE")
      if home then
        local is_windows = vim.fn.has('win32') == 1
        local separator = is_windows and '\\' or '/'
        local miniforge_path = home .. separator .. 'miniforge3'
        local path = miniforge_path .. separator .. (is_windows and 'python.exe' or 'bin' .. separator .. 'python')
        
        if vim.fn.filereadable(path) == 1 then
          return path
        end
      end
      
      -- Fall back to system Python
      if vim.fn.executable("python3") == 1 then
        return "python3"
      elseif vim.fn.executable("python") == 1 then
        return "python"
      end
      
      -- Last resort default
      return vim.fn.has('win32') == 1 and "python.exe" or "python"
    end
    
    -- Get the appropriate Python path
    local python_path = get_python_path()
    
    -- Log the detected Python path for debugging
    vim.notify("DAP Python using interpreter: " .. python_path, vim.log.levels.INFO)
    
    -- Configure the Python DAP
    dap_python.setup(python_path)
    
    -- Set up test mappings
    dap_python.test_runner = 'pytest'
    
    -- Configure exception breakpoints
    local dap = require('dap')
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = function() return python_path end,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch with arguments',
        program = '${file}',
        pythonPath = function() return python_path end,
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' ')
        end,
      },
      {
        type = 'python',
        request = 'attach',
        name = 'Attach remote',
        connect = function()
          local host = vim.fn.input('Host [127.0.0.1]: ')
          host = host ~= '' and host or '127.0.0.1'
          local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
          return { host = host, port = port }
        end,
      },
    }
  end,
}