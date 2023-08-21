-- remap space
vim.g.mapleader = ' '
vim.keymap.set('n', '<Space>', '<NOP>')

vim.keymap.set('n', '<leader>nh', ':nohl<CR>') -- delete search result
vim.keymap.set('n', 'd', '"_d')                -- delete a single letter without coping it
vim.keymap.set('v', 'd', '"_d')                -- delete a single letter without coping it
vim.keymap.set('n', 'c', '"_c')

-- movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- buffer
vim.keymap.set('n', '<C-\\>', ':bd<CR>')
vim.keymap.set('n', '<<', ':bp<CR>')
vim.keymap.set('n', '>>', ':bn<CR>')

-- telescope
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, {})
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').live_grep, {})
vim.keymap.set('n', '<leader>se', require('telescope.builtin').diagnostics, {})
vim.keymap.set('n', '<leader>gb', require('telescope.builtin').git_branches, {})
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, {})
vim.keymap.set('n', '<leader>u', ':Telescope undo<CR>') -- telescope undo

-- file
vim.keymap.set('n', '<leader>fb', ':NvimTreeToggle<CR>') -- file browser

-- FTerm
vim.keymap.set('n', '<leader>t', require('FTerm').toggle)
vim.keymap.set('t', '<Esc>', require('FTerm').toggle)
-- Remap key so ctrl-D and ctr-B work in the terminal mode
vim.api.nvim_exec([[
  tnoremap <C-D> <C-\><C-N>:execute "normal! \<C-W>\<C-D>"<CR>
  tnoremap <C-B> <C-\><C-N>:execute "normal! \<C-W>\<C-B>"<CR>
]], false)

-- lsp
vim.keymap.set('n', '<leader>ff', ':LspZeroFormat<CR>')
vim.keymap.set('n', '<leader>sa', ':lua vim.lsp.buf.code_action()<CR>')

-- script runner
vim.o.wildcharm = "<C-z>"
vim.keymap.set('n', '<leader>ss', ':RUN <C-z>')
vim.keymap.set('n', '<leader>sn', ':NPMRUN <C-z>')
