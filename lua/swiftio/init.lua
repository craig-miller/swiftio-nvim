local M = {}

local _config = {}

function M.setup(config)
  assert(config.mm_sdk_path, 'Missing mm_sdk_path in SwiftIO config')
  local mm = vim.fn.expand(config.mm_sdk_path) .. '/usr/mm/mm'
  config.mm = mm
  _config = config

  vim.api.nvim_create_user_command('SwiftIOHelp', M.help, {})
  vim.api.nvim_create_user_command('SwiftIOBuild', M.build, {})
  vim.api.nvim_create_user_command('SwiftIOInit', M.init, {})
  vim.api.nvim_create_user_command('SwiftIODownload', M.download, {})
  vim.api.nvim_create_user_command('SwiftIOClean', M.clean, {})
  vim.api.nvim_create_user_command('SwiftIOMonitor', M.monitor, {})
end

-- Helper to run a script in a floating window
local function run_command_in_split_autoclose(cmd, window_title)
  local term_buf = vim.api.nvim_create_buf(false, true)
  local status_buf = vim.api.nvim_create_buf(false, true)

  local win_height = math.floor(vim.o.lines * 0.6)
  local win_width = math.floor(vim.o.columns * 0.6)
  local row = math.floor(vim.o.lines * 0.2)
  local col = math.floor(vim.o.columns * 0.2)

  local term_win = vim.api.nvim_open_win(term_buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = win_width,
    height = win_height - 1,
    style = 'minimal',
    title = window_title,
    border = 'rounded',
    title_pos = 'center',
  })

  local status_win = vim.api.nvim_open_win(status_buf, false, {
    relative = 'editor',
    row = row + win_height - 1,
    col = col,
    width = win_width,
    height = 1,
    style = 'minimal',
  })

  vim.api.nvim_buf_set_lines(status_buf, 0, -1, false, {
    window_title or '',
  })
  vim.api.nvim_buf_add_highlight(status_buf, -1, 'Comment', 0, 0, -1)

  local job_id = vim.fn.termopen(cmd, {
    on_stdout = function(_, _, _)
      vim.schedule(function()
        local line_count = vim.api.nvim_buf_line_count(term_buf)
        vim.api.nvim_win_set_cursor(term_win, { line_count, 0 })
      end)
    end,
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_win_is_valid(term_win) then
          vim.api.nvim_win_close(term_win, true)
        end
        -- if vim.api.nvim_win_is_valid(status_win) then
        --   vim.api.nvim_win_close(status_win, true)
        -- end
      end)
    end,
  })

  local function close_and_kill()
    if vim.fn.jobwait({ job_id }, 0)[1] == -1 then
      vim.fn.jobstop(job_id)
    end
    if vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_close(term_win, true)
    end
    if vim.api.nvim_win_is_valid(status_win) then
      vim.api.nvim_win_close(status_win, true)
    end
  end

  vim.api.nvim_buf_set_keymap(term_buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = close_and_kill,
  })
end

local function get_plugin_script_path(script)
  local matches = vim.api.nvim_get_runtime_file('scripts/' .. script, false)
  if #matches == 0 then
    error('Script not found: ' .. script)
  end
  return matches[1]
end

function M.monitor()
  -- Monitor script in a terminal split
  local script = get_plugin_script_path('swiftio-monitor.nu')
  run_command_in_split_autoclose(script, 'SwiftIOMicro Monitor')
end

function M.help()
  local script = get_plugin_script_path('swiftio-help.nu')
  run_command_in_split_autoclose(script, 'SwiftIOMicro Help')
end

function M.clean()
  local script = get_plugin_script_path('swiftio-clean.nu')
  run_command_in_split_autoclose(script, 'SwiftIOMicro Clean')
end

function M.init()
  run_command_in_split_autoclose(_config.mm .. ' init -b SwiftIOMicro | less', 'SwiftIOMicro Init')
end

function M.build()
  run_command_in_split_autoclose(_config.mm .. ' build | less', 'SwiftIOMicro Build')
end

function M.download()
  run_command_in_split_autoclose(_config.mm .. ' download | less', 'SwiftIOMicro Download')
end

return M
