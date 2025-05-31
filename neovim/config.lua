-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- nerd font indicator
vim.g.have_nerd_font = true

-- file encoding
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- disable mouse
vim.opt.mouse = ""

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = false

-- scrolling
vim.opt.scrolloff = 15

-- tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.autoindent = true
vim.opt.smartindent = true

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- ui and colors
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣" }

-- backspace behavior
vim.opt.backspace = "indent,eol,start"

-- use system clipboard
vim.opt.clipboard:append("unnamedplus")

-- split window behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- undo history
vim.opt.undodir = os.getenv("HOME") .. "/.cache/undodir"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- performance
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.inccommand = "split"

-- diagnostic and lsp floating window style
local float_style = {
	focusable = true,
	style = "minimal",
	border = "rounded",
	source = "always",
	header = "",
	prefix = "",
}

vim.diagnostic.config({
	signs = true,
	underline = true,
	virtual_text = true,
	severity_sort = true,
	float = float_style,
})

-- consistent lsp floating window style
local orig_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	return orig_open_floating_preview(
		contents,
		syntax,
		vim.tbl_deep_extend("force", {}, float_style, opts or {}),
		...
	)
end

-- autocommands
local augroup_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup_yank,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 200 })
	end,
})

local augroup_terminal_mouse = vim.api.nvim_create_augroup("TerminalMouse", { clear = true })
vim.api.nvim_create_autocmd("TermEnter", {
	group = augroup_terminal_mouse,
	pattern = "*",
	command = "set mouse=a",
})
vim.api.nvim_create_autocmd("TermLeave", {
	group = augroup_terminal_mouse,
	pattern = "*",
	command = "set mouse=",
})
