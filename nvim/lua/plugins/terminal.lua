-- Floating terminal implementation
local terminal_buffer, terminal_window = nil, nil

-- Package manager configuration (detected once at startup)
local PACKAGE_MANAGER_CONFIG = {
  bun = { command = "bun", run = "run" },
  node = { command = "node", run = "--no-warnings --run" },
}

-- Detect package manager once at startup
local PACKAGE_MANAGER = vim.fn.findfile("bun.lock") ~= "" and "bun"
    or vim.fn.findfile("package.json") ~= "" and "node"
    or nil

-- Helper to create floating window config
local function get_float_config()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  return {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  }
end

-- Open or focus the persistent dev terminal
vim.keymap.set("n", "<leader>t", function()
  if terminal_buffer and vim.api.nvim_buf_is_valid(terminal_buffer) then
    terminal_window = vim.api.nvim_open_win(terminal_buffer, true, get_float_config())
    vim.wo[terminal_window].winhl = "Normal:Normal"
    vim.wo[terminal_window].winblend = 0
    vim.cmd("startinsert")
    return
  end

  terminal_buffer = vim.api.nvim_create_buf(false, true)
  terminal_window = vim.api.nvim_open_win(terminal_buffer, true, get_float_config())
  vim.wo[terminal_window].winhl = "Normal:Normal"
  vim.wo[terminal_window].winblend = 0

  local config = PACKAGE_MANAGER and PACKAGE_MANAGER_CONFIG[PACKAGE_MANAGER]
  local command = config
      and { config.command, config.run, "dev" }
      or { vim.o.shell }

  vim.api.nvim_buf_call(terminal_buffer, function()
    vim.fn.jobstart(command, {
      term = true,
      on_exit = function()
        vim.schedule(function()
          if terminal_buffer then terminal_buffer = nil end
        end)
      end,
    })
  end)

  vim.cmd("startinsert")
end)

-- Close the terminal window
vim.keymap.set("t", "<Esc>", function()
  if terminal_window and vim.api.nvim_win_is_valid(terminal_window) then
    vim.api.nvim_win_close(terminal_window, true)
    terminal_window = nil
  end
end)

-- Script selector
vim.keymap.set("n", "<leader>ss", function()
  local scripts = {}
  local package_scripts = {}

  if PACKAGE_MANAGER and vim.fn.findfile("package.json") ~= "" then
    local success_read, content = pcall(vim.fn.readfile, "package.json")
    if success_read then
      local success_decode, package_data = pcall(vim.json.decode, table.concat(content))
      if success_decode and package_data.scripts then
        for name, _ in pairs(package_data.scripts) do
          if name ~= "dev" and name ~= "turbo" and name:sub(1, 1) ~= "_" and not name:match("^dev:") then
            table.insert(scripts, PACKAGE_MANAGER .. ":" .. name)
            package_scripts[name] = true
          end
        end
      end
    end
  end

  local file_stat = vim.uv.fs_stat("./scripts")
  if file_stat and file_stat.type == "directory" then
    for _, file in ipairs(vim.fn.readdir("./scripts")) do
      local name = file:match("^(.+)%.sh$")
      if name and name ~= "turbo" and not name:match("^%+") and not package_scripts[name] then
        table.insert(scripts, "bash:" .. name)
      end
    end
  end

  if vim.fn.findfile("flake.nix") ~= "" then
    table.insert(scripts, "nix:switch")
    table.insert(scripts, "nix:rebuild")
    table.insert(scripts, "nix:clean")
  end

  vim.ui.select(scripts, { prompt = "Select script" }, function(selected)
    if not selected then return end

    local kind, name = selected:match("(.-):(.*)")
    local command

    if kind == "bash" then
      command = { "sh", "./scripts/" .. name .. ".sh" }
    elseif kind == "nix" then
      local nix_commands = {
        switch = { "home-manager", "switch", "--flake", ".#mp281x" },
        rebuild = { "nix", "run", "home-manager/master", "--", "switch", "--flake", ".#mp281x" },
        clean = { "nix-collect-garbage", "-d" },
      }
      command = nix_commands[name]
    else
      local config = PACKAGE_MANAGER_CONFIG[kind]
      if config then
        command = { config.command, config.run, name }
      end
    end

    if not command then return end

    local buffer = vim.api.nvim_create_buf(false, true)
    local window = vim.api.nvim_open_win(buffer, true, get_float_config())
    vim.wo[window].winhl = "Normal:Normal"
    vim.wo[window].winblend = 0

    vim.api.nvim_buf_call(buffer, function()
      vim.fn.jobstart(command, { term = true })
    end)

    vim.cmd("startinsert")
  end)
end)

return {}
