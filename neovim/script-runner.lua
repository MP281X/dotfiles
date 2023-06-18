-- bash
vim.api.nvim_create_user_command("RUN", function(params)
  local args = params.args
  require('FTerm').scratch({ cmd = "bash ./script/" .. args .. ".sh" })
end, {
  nargs = 1,
  complete = function(_, _, _)
    local scriptNames = {}
    for fileName in io.popen("ls ./script"):lines() do
      table.insert(scriptNames, fileName:match("^(.+)%..+$"))
    end
    return scriptNames
  end
})

-- node
vim.api.nvim_create_user_command("NPMRUN", function(params)
  local packet_manager = "pnpm"
  if vim.fn.findfile("pnpm-lock.yaml") == "package.json" then packet_manager = "pnpm" end
  if vim.fn.findfile("yarn.lock") == "yarn.lock" then packet_manager = "yarn" end

  local args = params.args
  require('FTerm').scratch({ cmd = packet_manager .. " run " .. args })
end, {
  nargs = 1,
  complete = function(_, _, _)
    local scriptNames = {}
    for fileName in io.popen("cat package.json | jq -r '.scripts | keys[]'"):lines() do
      table.insert(scriptNames, fileName)
    end
    return scriptNames
  end
})
