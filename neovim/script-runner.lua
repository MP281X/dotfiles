-- floating terminal
require("FTerm").setup({
	auto_close = false,
	cmd = (function()
		-- node
		if vim.fn.findfile("package.json") ~= "" then return { "node", "--no-warnings", "--run", "dev" } end
		if vim.fn.findfile("deno.json") ~= "" then return { "deno", "task", "-q", "dev" } end
		if vim.fn.findfile("mvnw") ~= "" then return { "./mvnw", "spring-boot:run", "--quiet" } end

		return { "sh", "-c", "$SHELL" }
	end)(),
})

local getScriptNames = function()
	local scriptNames = {}

	-- find all the node scripts
	if vim.fn.findfile("package.json") ~= "" then
		local extract_key = '.scripts | keys[] | select(. != "dev")'
		for nodeScript in io.popen("jq -r '.scripts | keys[] | select(. != \"dev\")' package.json" .. extract_key .. "'"):lines() do
			table.insert(scriptNames, "node:" .. nodeScript)
		end
	end

	-- find all the deno scripts
	if vim.fn.findfile("deno.json") ~= "" then
		for denoScript in io.popen("jq -r '.tasks | keys[] | select(. != \"dev\")' deno.json"):lines() do
			table.insert(scriptNames, "deno:" .. denoScript)
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

	return scriptNames
end

local runScript = function(selected)
	if selected == nil then return end

	local type = selected:match("(.-):")
	local script = selected:match(":(.+)")

	-- bash script
	if type == "bash" then
		require("FTerm").scratch({ cmd = "sh ./scripts/" .. script .. ".sh" })
	end

	-- node script
	if type == "node" then
		require("FTerm").scratch({ cmd = "node --no-warnings --run " .. script })
	end

	-- deno script
	if type == "deno" then
		require("FTerm").scratch({ cmd = "deno task -q " .. " " .. script })
	end
end

-- script runner
vim.keymap.set("n", "<leader>ss", function()
	vim.ui.select(getScriptNames(), { prompt = "Select script" }, runScript)
end, {})
