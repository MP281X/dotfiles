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

				if exists == false and not fileName:match("^%+") then
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
		if vim.fn.findfile("bun.lockb") ~= "" then packet_manager = "bun run --silent" end
		if vim.fn.findfile("package.json") ~= "" then packet_manager = "node --no-warnings --run" end

		require("FTerm").scratch({ cmd = packet_manager .. " " .. script })
	end
end

-- script runner
vim.keymap.set("n", "<leader>ss", function()
	vim.ui.select(getScriptNames(), { prompt = "Select script" }, runScript)
end, {})
