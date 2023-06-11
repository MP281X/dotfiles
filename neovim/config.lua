vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

-- file encoding
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- disable mouse
vim.opt.mouse = ""

-- line nunbers
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.scrolloff = 15

-- tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

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
vim.o.undofile = true

-- global statusline
vim.opt.laststatus = 3
