vim.api.nvim_create_user_command("RUN", function(params)
  local args = params.args
  
  require('FTerm').scratch({cmd = "bash ./script/"..args..".sh"})
end, { 
  nargs = 1,
  complete = function(A, L, P)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen("ls ./script/ | sed -e 's/\\..*$//'")
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
  end 
})
