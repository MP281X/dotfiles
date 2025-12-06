-- Floating terminal implementation
local term_buf, term_win = nil, nil

local function get_float_config()
  local w, h = math.floor(vim.o.columns * 0.8), math.floor(vim.o.lines * 0.8)
  return {
    relative = "editor",
    width = w,
    height = h,
    row = math.floor((vim.o.lines - h) / 2),
    col = math.floor((vim.o.columns - w) / 2),
    style = "minimal",
    border = "rounded",
  }
end

local function setup_term_win(win)
  vim.wo[win].winhl = "Normal:Normal"
  vim.wo[win].winblend = 0
end

local function get_default_cmd()
  if vim.fn.findfile("package.json") ~= "" then
    return { "node", "--no-warnings", "--run", "dev" }
  end
  return { vim.o.shell }
end

local function open_terminal()
  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    term_win = vim.api.nvim_open_win(term_buf, true, get_float_config())
    setup_term_win(term_win)
    vim.cmd("startinsert")
    return
  end

  term_buf = vim.api.nvim_create_buf(false, true)
  term_win = vim.api.nvim_open_win(term_buf, true, get_float_config())
  setup_term_win(term_win)

  vim.api.nvim_buf_call(term_buf, function()
    vim.fn.jobstart(get_default_cmd(), {
      term = true,
      on_exit = function() vim.schedule(function() term_buf = nil end) end,
    })
  end)

  vim.cmd("startinsert")
end

local function close_terminal()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, true)
    term_win = nil
  end
end

local function scratch_terminal(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, get_float_config())
  setup_term_win(win)

  vim.api.nvim_buf_call(buf, function()
    vim.fn.jobstart(cmd, { term = true })
  end)

  vim.cmd("startinsert")
end

local function get_script_names()
  local scripts = {}
  local node_scripts = {}

  if vim.fn.findfile("package.json") ~= "" then
    local handle = io.popen("jq -r '.scripts | to_entries[] | select(. != \"dev\") | .key' package.json 2>/dev/null")
    if handle then
      for name in handle:lines() do
        if name ~= "dev" and name ~= "turbo" and name:sub(1, 1) ~= "_" then
          table.insert(scripts, "node:" .. name)
          node_scripts[name] = true
        end
      end
      handle:close()
    end
  end

  local stat = vim.uv.fs_stat("./scripts")
  if stat and stat.type == "directory" then
    for _, file in ipairs(vim.fn.readdir("./scripts")) do
      local name = file:match("^(.+)%.sh$")
      if name and name ~= "turbo" and not name:match("^%+") and not node_scripts[name] then
        table.insert(scripts, "bash:" .. name)
      end
    end
  end

  return scripts
end

local function run_script(selected)
  if not selected then return end

  local kind, name = selected:match("(.-):(.*)")
  if kind == "bash" then
    scratch_terminal({ "sh", "./scripts/" .. name .. ".sh" })
  elseif kind == "node" then
    scratch_terminal({ "node", "--no-warnings", "--run", name })
  end
end

-- Keymaps
vim.keymap.set("n", "<leader>t", open_terminal)
vim.keymap.set("t", "<Esc>", close_terminal)
vim.keymap.set("n", "<leader>ss", function()
  vim.ui.select(get_script_names(), { prompt = "Select script" }, run_script)
end)

return {}
