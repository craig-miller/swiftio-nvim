local M = {}

local _config = {}

function M.setup(config)
  if config.mm_sdk_path ~= nil then
    -- config.mm_sdk_path = "/Users/craig/Developer/embedded-swift/mm-sdk"
    -- config.mm_sdk_path = "~/mm-sdk"
    print('Missing mm_sdk_path: Should be something like: "~/mm-sdk"')
  end

  -- Append path to mm command
  local mm = vim.fn.expand(config.mm_sdk_path) .. '/usr/mm/mm'
  config.mm = mm

  -- save the config globally
  _config = config
end

function M.monitor()
  -- Monitor script in a terminal split
  --vim.api.nvim_create_user_command("SwiftIOMonitor", function()
  local script = vim.fn.expand('~/.config/nvim/nu-scripts/swiftio-monitor.nu')
  run_command_in_split_autoclose(script)
  --end, {})
end

function M.help()
  -- vim.api.nvim_create_user_command("SwiftIOHelp", function()
  -- run_command_in_split_autoclose("nu " .. vim.fn.expand("~/.config/nvim/nu-scripts/swiftio-help.nu"))
  run_command_in_split_autoclose(
    'nu ' .. vim.fn.expand('~/.config/nvim/nu-scripts/swiftio-help.nu')
  )
  -- end, {})
end

function M.clean()
  -- vim.api.nvim_create_user_command("SwiftIOClean", function()
  run_command_in_split_autoclose(
    'nu ' .. vim.fn.expand('~/.config/nvim/nu-scripts/swiftio-clean.nu')
  )
  -- end, {})
end

function M.init()
  -- vim.api.nvim_create_user_command("SwiftIOInit", function()
  run_command_in_split_autoclose(_config.mm .. ' init | less')
  -- end, {})
end

function M.build()
  -- vim.api.nvim_create_user_command("SwiftIOBuild", function()
  run_command_in_split_autoclose(_config.mm .. ' build | less')
  -- end, {})
end

function M.download()
  -- vim.api.nvim_create_user_command("SwiftIODownload", function()
  run_command_in_split_autoclose(_config.mm .. ' download | less')
  -- end, {})
end

-- Helper to run a script in a horizontal split terminal
-- local function run_script_in_split(script_path)
--     vim.cmd("split | terminal nu " .. script_path)
-- end
local function run_command_in_split_autoclose(cmd)
  -- Open a new buffer and window
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

  -- Start the terminal job and track it
  local job_id = vim.fn.termopen(cmd, {
    on_exit = function(_, exit_code, _)
      -- Close the window after exit
      if vim.api.nvim_win_is_valid(win) then
        vim.schedule(function()
          vim.api.nvim_win_close(win, true)
        end)
      end
    end,
  })

  -- Optional: map 'q' to close early
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
end

return M
