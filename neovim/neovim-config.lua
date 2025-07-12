local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- load default config
require("keymaps")
require("config")

-- load plugins
require("plugin")

-- load plugin config
require("plugin-config")
require("files-config")
require("lsp-config")

-- load the custom script runner
require("script-runner")
