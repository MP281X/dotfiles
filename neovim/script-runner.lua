local getScriptNames = function()
	local scriptNames = {}

	-- find all the package json scripts
	if vim.fn.findfile("package.json") ~= "" then
		local extract_key = '.scripts | keys[] | select(test("^[^_].*"))'

		for nodeScript in io.popen("cat package.json | jq -r '" .. extract_key .. "'"):lines() do
			if nodeScript ~= "dev" then
				table.insert(scriptNames, "node:" .. nodeScript)
			end
		end
	end

	-- find all the bash script
	local stat = vim.loop.fs_stat("./scripts")

	if stat and stat.type == "directory" then
		for _, fileName in ipairs(vim.fn.readdir("./scripts")) do
			if fileName:match("%.sh$") then
				local name = fileName:match("^(.+)%.sh$")
				local exists = table.concat(scriptNames, ','):find("node:" .. name) and true or false

				if exists == false then
					table.insert(scriptNames, "bash:" .. name)
				end
			end
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
	if type == "bash" then require("FTerm").scratch({ cmd = "sh ./scripts/" .. script .. ".sh" }) end

	-- find the correct node package manager and run the script
	if type == "node" then
		local packet_manager = ""
		if vim.fn.findfile("pnpm-lock.yaml") ~= "" then packet_manager = "pnpm" end
		if vim.fn.findfile("yarn.lock") ~= "" then packet_manager = "yarn" end
		if vim.fn.findfile("bun.lockb") ~= "" then packet_manager = "bun" end
		if vim.fn.findfile("package-lock.json") ~= "" then packet_manager = "npm" end
		if packet_manager == "" then return end

		require("FTerm").scratch({ cmd = packet_manager .. " run --silent " .. script })
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
