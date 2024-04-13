vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
vim.g.have_nerd_font = true

-- file encoding
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- disable mouse
vim.opt.mouse = ""

-- line nunbers
vim.opt.relativenumber = true
vim.opt.number = true

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

-- colors
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"

-- backspace
vim.opt.backspace = "indent,eol,start"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- split window
vim.opt.splitright = true
vim.opt.splitbelow = true

-- save undo history
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Decrease update time
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300

-- Show ending spaces
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣' }

-- global statusline
vim.opt.laststatus = 3

-- floating info border style
local style = {
	focusable = true,
	style = "minimal",
	border = "rounded",
	source = "always",
	header = "",
	prefix = "",
}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, style)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, style)
vim.diagnostic.config({ signs = true, severity_sort = true, float = style })

-- highlight selected text
vim.api.nvim_create_autocmd('TextYankPost', {
	group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
	callback = function() vim.highlight.on_yank() end,
})
