-- bash
vim.api.nvim_create_user_command("RUN", function(params)
  if params.args ~= {} then
    local args = params.args
    require('FTerm').scratch({ cmd = "bash ./script/" .. args .. ".sh" })
  end
end, {
  nargs = 1,
  complete = function(_, _, _)
    local scriptNames = {}

    local stat = vim.loop.fs_stat("./script")
    if stat and stat.type == "directory" then
      for fileName in io.popen("ls ./script"):lines() do
        table.insert(scriptNames, fileName:match("^(.+)%..+$"))
      end
    end

    return scriptNames
  end
})

-- js/ts
vim.api.nvim_create_user_command("NPMRUN", function(params)
  local packet_manager = ""
  if vim.fn.findfile("pnpm-lock.yaml") == "pnpm-lock.yaml" then packet_manager = "pnpm" end
  if vim.fn.findfile("yarn.lock") == "yarn.lock" then packet_manager = "yarn" end
  if vim.fn.findfile("bun.lockb") == "bun.lockb" then packet_manager = "bun" end
  if vim.fn.findfile("package-lock.json") == "package-lock.json" then packet_manager = "npm" end

  if packet_manager ~= "" and params.args ~= {} then
    local args = params.args
    require('FTerm').scratch({ cmd = packet_manager .. " run " .. args })
  end
end, {
  nargs = 1,
  complete = function(_, _, _)
    local scriptNames = {}
    local extract_key = '.scripts | keys[] | select(test("^[^_].*"))'
    for fileName in io.popen("cat package.json | jq -r '" .. extract_key .. "'"):lines() do
      table.insert(scriptNames, fileName)
    end

    return scriptNames
  end
})

-- bun test
vim.api.nvim_create_user_command("BUNTEST", function(params)
  local file_path = vim.fn.expand('%')

  if string.match(file_path, "%.test%.ts$") then
    require('FTerm').scratch({ cmd = "bun run test " .. file_path })
  else
    local current_path = string.sub(vim.fn.expand('%:p:h'), #vim.fn.getcwd() + 2)
    local test_file = current_path .. "/" .. vim.fn.expand('%:t:r') .. ".test.ts"

    if vim.fn.filereadable(test_file) == 1 then
      require('FTerm').scratch({ cmd = "bun run test " .. test_file })
    else
      print("test file not found")
    end
  end
end, { nargs = 0 })
