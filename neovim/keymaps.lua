-- remap space
vim.g.mapleader = " "
vim.keymap.set("n", "<Space>", "<NOP>")

vim.keymap.set("n", "<ESC>", ":nohl<CR>") -- remove search highlight
vim.keymap.set("n", "d", '"_d')           -- delete a single letter without coping it
vim.keymap.set("v", "d", '"_d')           -- delete a single letter without coping it
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

-- move selected line/block down
vim.keymap.set('n', '<A-Down>', ":m .+1<CR>==")
vim.keymap.set('v', '<A-Down>', ":m '>+1<CR>gv=gv")

-- move selected line/block up
vim.keymap.set('n', '<A-Up>', ":m .-2<CR>==")
vim.keymap.set('v', '<A-Up>', ":m '<-2<CR>gv=gv")

-- enable and disable telescope and nvimTree filters
Enable_filters = true
vim.keymap.set("n", "<leader>ff", function()
	Enable_filters = not Enable_filters
	vim.api.nvim_command('source ' .. "~/.config/nvim/lua/files-config.lua")
end, {})

-- telescope
vim.keymap.set("n", "<leader>sf", function() require("telescope.builtin").find_files() end, {})
vim.keymap.set("n", "<leader>sc", function() require("telescope.builtin").live_grep() end, {})
vim.keymap.set("n", "<leader>se", function() require("telescope.builtin").diagnostics() end, {})
vim.keymap.set("n", "<leader>sb", function() require("telescope.builtin").buffers() end, {})
vim.keymap.set("n", "<leader>sr", function() require("telescope.builtin").lsp_references() end, {})
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
