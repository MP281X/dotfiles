local getScriptNames = function()
	local scriptNames = {}

	-- find all the bash script
	local stat = vim.loop.fs_stat("./script")

	if stat and stat.type == "directory" then
		for _, fileName in ipairs(vim.fn.readdir("./script")) do
			if fileName:match("%.sh$") then
				table.insert(scriptNames, "bash:" .. fileName:match("^(.+)%.sh$"))
			end
		end
	end

	-- find all the package json scripts
	if vim.fn.findfile("package.json") ~= "" then
		local extract_key = '.scripts | keys[] | select(test("^[^_].*"))'

		for fileName in io.popen("cat package.json | jq -r '" .. extract_key .. "'"):lines() do
			table.insert(scriptNames, "node:" .. fileName)
		end
	end

	-- find if there is a test file for the current file
	if string.match(vim.fn.expand("%"), "%.test%.ts$") then
		local current_file = vim.fn.expand("%:p")
		table.insert(scriptNames, "test:" .. vim.fn.fnamemodify(current_file, ":t"))
	else
		local current_path = vim.fn.expand("%:p:h")
		if vim.fn.filereadable(current_path .. "/" .. vim.fn.expand("%:t:r") .. ".test.ts") == 1 then
			table.insert(scriptNames, "test:" .. vim.fn.expand("%:t:r") .. ".test.ts")
		end
	end

	return scriptNames
end

local runScript = function(selected)
	if selected == nil then return end

	local type = selected:match("(.-):")
	local script = selected:match(":(.+)")

	-- run the bash script
	if type == "bash" then require("FTerm").scratch({ cmd = "bash ./script/" .. script .. ".sh" }) end

	-- find the correct node package manager and run the script
	if type == "node" then
		local packet_manager = ""
		if vim.fn.findfile("pnpm-lock.yaml") ~= "" then packet_manager = "pnpm" end
		if vim.fn.findfile("yarn.lock") ~= "" then packet_manager = "yarn" end
		if vim.fn.findfile("bun.lockb") ~= "" then packet_manager = "bun" end
		if vim.fn.findfile("package-lock.json") ~= "" then packet_manager = "npm" end
		if packet_manager == "" then return end

		require("FTerm").scratch({ cmd = packet_manager .. " run " .. script })
	end

	-- find the correct package.json (the project root) and run the test
	if type == "test" then
		local file_path = vim.fn.expand("%:p:h")
		local root_path = file_path

		repeat
			if vim.fn.filereadable(root_path .. "/package.json") == 1 then
				file_path = string.sub(file_path, #root_path + 2) .. "/" .. script
				if file_path.sub(file_path, 1, 1) == "/" then file_path = string.sub(file_path, 2) end

				require("FTerm").scratch({ cmd = "(cd " .. root_path .. " && bun test --only " .. file_path .. ")" })
				return
			end

			root_path = vim.fn.fnamemodify(root_path, ":h")
		until root_path == ""

		print("package.json not found")
	end
end

-- script runner
vim.keymap.set("n", "<leader>ss", function()
	vim.ui.select(getScriptNames(), { prompt = "Select script" }, runScript)
end, {})

-- git
local branchNames = function()
	if vim.fn.systemlist("git fetch")[1] ~= nil then return {} end

	local branch_names = {}
	for branch in io.popen("git branch --format='%(refname:short)'"):lines() do
		if branch ~= "" then table.insert(branch_names, branch) end
	end

	return branch_names
end

local stashIdByName = function(stash_name)
	for stash_info in io.popen("git stash list"):lines() do
		local stash_id = stash_info:match("{(%d+)}")
		local stash_message = stash_info:match(".*:.*: (.*)$")

		if stash_message:match("^nvim_" .. stash_name .. "$") then
			return stash_id
		end
	end
end

local stash = function(current_branch)
	local result = vim.fn.systemlist("git diff -q --exit-code || git stash -q -u -m '" .. current_branch .. "'")[1]

	-- if  ~= nil then
	-- 		print("git diff -q --exit-code || git stash -q -u -m '" .. current_branch .. "'")
	-- 		error("git stash failed")
	-- 		return
	-- 	end
	-- -- diff --git
end

local checkout = function(branch_name)
	local result = vim.fn.systemlist("git checkout -q " .. branch_name)[1]

	if result == nil then return true end
	if result == "fatal: The current branch a has no upstream branch." then return true end

	return false
end

local pull = function()
	local result = vim.fn.systemlist("git pull -q")[1]
	if result == nil then return true end
	if result == "There is no tracking information for the current branch." then return true end

	return false
end

local popStash = function(id)
	if id == nil or id == "" then return true end

	local output = vim.fn.systemlist("git stash pop stash@{" .. id .. "} -q")
	if output == nil then return true end
	if output[1]:match("^fatal:") then return true end
	if output:match("not a valid reference$") then return true end

	return false
end

-- git
vim.keymap.set("n", "<leader>gb", function()
	vim.ui.select(branchNames(), { prompt = "Select branch" }, function(branch_name)
		local current_branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
		if current_branch == nil then
			error("branch not found")
			return
		end

		if stash(current_branch) == false then
			error("git stash failed")
			return
		end

		if checkout(branch_name) == false then
			error("git checkout failed")
			return
		end

		if pull() == false then
			error("git pull failed")
			return
		end

		local id = stashIdByName(branch_name)
		if popStash(id) == false then print("git stash pop failed") end
	end)
end, {})
