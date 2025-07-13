-- remap space
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<NOP>")

vim.keymap.set("n", "<ESC>", ":nohlsearch<CR>") -- remove search highlight
vim.keymap.set("n", "d", '"_d')                 -- delete a single letter without coping it
vim.keymap.set("v", "d", '"_d')                 -- delete a single letter without coping it
vim.keymap.set("n", "c", '"_c')

-- movement
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- buffer
vim.keymap.set("n", "<C-\\>", ":bd!<CR>")
vim.keymap.set("n", "<<", ":bp<CR>")
vim.keymap.set("n", ">>", ":bn<CR>")

-- split navigation
vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Down>", "<C-w>j")
vim.keymap.set("n", "<C-Up>", "<C-w>k")
vim.keymap.set("n", "<C-Right>", "<C-w>l")

-- move selected line/block down
vim.keymap.set('n', '<A-Down>', ":m .+1<CR>==")
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv")

-- move selected line/block up
vim.keymap.set('n', '<A-Up>', ":m .-2<CR>==")
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv")

-- Remap key so ctrl-D and ctrl-B work in the terminal mode
vim.keymap.set("t", "<C-D>", [[<C-\><C-N>:execute 'normal! \<C-W>\<C-D>'<CR>]])
vim.keymap.set("t", "<C-B>", [[<C-\><C-N>:execute 'normal! \<C-W>\<C-B>'<CR>]])
