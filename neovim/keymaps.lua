-- remap space
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<NOP>")

vim.keymap.set("n", "<leader>nh", ":nohl<CR>") -- delete search result
vim.keymap.set("n", "d", '"_d')                -- delete a single letter without coping it
vim.keymap.set("v", "d", '"_d')                -- delete a single letter without coping it
vim.keymap.set("n", "c", '"_c')

-- movement
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- buffer
vim.keymap.set("n", "<C-\\>", ":bd<CR>")
vim.keymap.set("n", "<<", ":bp<CR>")
vim.keymap.set("n", ">>", ":bn<CR>")

-- search and replace
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- telescope
vim.keymap.set("n", "<leader>sf", function() require("telescope.builtin").find_files() end, {})
vim.keymap.set("n", "<leader>sc", function() require("telescope.builtin").live_grep() end, {})
vim.keymap.set("n", "<leader>se", function() require("telescope.builtin").diagnostics() end, {})
vim.keymap.set("n", "<leader>sb", function() require("telescope.builtin").buffers() end, {})
vim.keymap.set("n", "<leader>u", ":Telescope undo<CR>")  -- telescope undo
vim.keymap.set("n", "<leader>fb", ":NvimTreeToggle<CR>") -- file browser

-- Remap key so ctrl-D and ctr-B work in the terminal mode
vim.api.nvim_exec(
	[[
  tnoremap <C-D> <C-\><C-N>:execute 'normal! \<C-W>\<C-D>'<CR>
  tnoremap <C-B> <C-\><C-N>:execute 'normal! \<C-W>\<C-B>'<CR>
]],
	false
)

-- toggle deleted and added lines
vim.keymap.set("n", "<leader>g", ":Gitsigns preview_hunk<CR>", {})

-- toggle terminal
vim.keymap.set("n", "<leader>t", function() require("FTerm").open() end)
vim.keymap.set("t", "<Esc>", function() require("FTerm").close() end)
