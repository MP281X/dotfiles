-- remap space
vim.g.mapleader = ' '
vim.keymap.set('n', '<Space>', '<NOP>')

vim.keymap.set('n', '<leader>nh', ':nohl<CR>') -- delete search result
vim.keymap.set('n', 'd', '"_d') -- delete a single letter without coping it
vim.keymap.set('v', 'd', '"_d') -- delete a single letter without coping it

-- movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- buffer 
vim.keymap.set('n', '<C-\\>', ':bd<CR>')
vim.keymap.set('n', '>>', ':bn<CR>')
vim.keymap.set('n', '<<', ':bn<CR>')

-- telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, {})
vim.keymap.set('n', '<leader>se', require('telescope.builtin').diagnostics, {})
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').git_status, {})
vim.keymap.set('n', '<leader>gc', require('telescope.builtin').git_commits, {})
vim.keymap.set('n', '<leader>fb', ':Telescope file_browser path=%:p:h select_buffer=true<CR>') -- telescope file browser
vim.keymap.set('n', '<leader>u', ':Telescope undo<CR>') -- telescope undo

-- FTerm
vim.keymap.set('n', '<leader>t', require('FTerm').toggle)
vim.keymap.set('t', '<leader>t', require('FTerm').toggle)

