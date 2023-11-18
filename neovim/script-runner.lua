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
  local file_name
  local file_path

  if string.match(vim.fn.expand('%'), "%.test%.ts$") then
    local current_file = vim.fn.expand("%:p")
    file_path = vim.fn.fnamemodify(current_file, ":h")
    file_name = vim.fn.fnamemodify(current_file, ":t")
  else
    local current_path = vim.fn.expand('%:p:h')
    if vim.fn.filereadable(current_path .. "/" .. vim.fn.expand('%:t:r') .. ".test.ts") == 1 then
      file_path = current_path
      file_name = vim.fn.expand('%:t:r') .. ".test.ts"
    end
  end

  if file_path == nil or file_name == nil then
    print("*.test.ts not found")
    return
  end

  local root_path = file_path
  repeat
    if vim.fn.filereadable(root_path .. "/package.json") == 1 then
      file_path = string.sub(file_path, #root_path + 2) .. "/" .. file_name
      if file_path.sub(file_path, 1, 1) == "/" then file_path = string.sub(file_path, 2) end

      require('FTerm').scratch({ cmd = "(cd " .. root_path .. " && bun test " .. file_path .. ")" })
      return
    end

    root_path = vim.fn.fnamemodify(root_path, ':h')
  until root_path == ""

  print("package.json not found")
end, { nargs = 0 })
