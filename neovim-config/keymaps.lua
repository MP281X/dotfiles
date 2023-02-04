vim.g.mapleader = " "

vim.keymap.set("n", "<leader>nh", ":nohl<CR>") -- delete search result
vim.keymap.set("n", "d", '"_d') -- delete a single letter without coping it
vim.keymap.set("v", "d", '"_d') -- delete a single letter without coping it

-- split window
vim.keymap.set("n", "<leader>sv", '<C-w>v') -- vertical 
vim.keymap.set("n", "<leader>se", '<C-w>=') -- reset size
vim.keymap.set("n", "<leader>sx", ':close<CR>') -- close

-- telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, {})
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').live_grep, {})
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_status, {})

-- nvim-tree
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')

-- FTerm
vim.keymap.set('n', '<leader>t', require('FTerm').toggle)
vim.keymap.set('t', '<leader>t', require('FTerm').toggle)

-- movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv') 
vim.keymap.set('n', 'N', 'Nzzzv') 
