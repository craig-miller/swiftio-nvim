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

-- Helper to run a script in a horizontal split terminal
-- local function run_script_in_split(script_path)
--     vim.cmd("split | terminal nu " .. script_path)
-- end
--
local function run_command_in_split_autoclose(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor(vim.o.lines * 0.2),
    col = math.floor(vim.o.columns * 0.2),
    width = math.floor(vim.o.columns * 0.6),
    height = math.floor(vim.o.lines * 0.6),
    style = 'minimal',
    border = 'rounded',
  })

  local job_id = vim.fn.termopen(cmd, {
    on_stdout = function(_, data, _)
      if data then
        vim.schedule(function()
          local line_count = vim.api.nvim_buf_line_count(buf)
          vim.api.nvim_win_set_cursor(win, { line_count, 0 })
        end)
      end
    end,
    on_exit = function()
      if vim.api.nvim_win_is_valid(win) then
        vim.schedule(function()
          vim.api.nvim_win_close(win, true)
        end)
      end
    end,
  })

  local function close_and_kill()
    if vim.fn.jobwait({ job_id }, 0)[1] == -1 then
      vim.fn.jobstop(job_id)
    end
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end

  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '', {
    noremap = true,
    silent = true,
    callback = close_and_kill,
  })
end

-- local function run_command_in_split_autoclose(cmd)
--   -- Open a new buffer and window
--   local buf = vim.api.nvim_create_buf(false, true)
--   local win = vim.api.nvim_open_win(buf, true, {
--     relative = 'editor',
--     row = math.floor(vim.o.lines * 0.2),
--     col = math.floor(vim.o.columns * 0.2),
--     width = math.floor(vim.o.columns * 0.6),
--     height = math.floor(vim.o.lines * 0.6),
--     style = 'minimal',
--     border = 'rounded',
--   })
--
--   -- Start the terminal job and track it
--   local job_id = vim.fn.termopen(cmd, {
--     on_exit = function(_, exit_code, _)
--       -- Close the window after exit
--       if vim.api.nvim_win_is_valid(win) then
--         vim.schedule(function()
--           vim.api.nvim_win_close(win, true)
--         end)
--       end
--     end,
--   })
--   -- Optional: map 'q' to close early
--   vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
-- end

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
  run_command_in_split_autoclose(script)
end

function M.help()
  local script = get_plugin_script_path('swiftio-help.nu')
  run_command_in_split_autoclose(script)
end

function M.clean()
  local script = get_plugin_script_path('swiftio-clean.nu')
  run_command_in_split_autoclose(script)
end

function M.init()
  run_command_in_split_autoclose(_config.mm .. ' init | less')
end

function M.build()
  run_command_in_split_autoclose(_config.mm .. ' build | less')
end

function M.download()
  run_command_in_split_autoclose(_config.mm .. ' download | less')
end

return M
