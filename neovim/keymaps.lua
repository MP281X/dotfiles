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

-- reload typescript lsp
vim.keymap.set("n", "<leader>r", function()
	local clients = vim.lsp.get_active_clients()
	local currentBuffer = vim.api.nvim_get_current_buf()

	for _, client in ipairs(clients) do
		-- check if the client is the typescript lsp
		if client.name ~= "tsserver" then goto continue end

		-- check if the lsp client is connected to the current buffer
		local clientBuffers = vim.lsp.get_buffers_by_client_id(client.id)
		if not table.concat(clientBuffers, ","):find(currentBuffer) then goto continue end

		-- stop the lsp server
		vim.lsp.stop_client(client.id)
		vim.defer_fn(function()
			-- start a new lsp client with the same config of the previous
			local clientId = vim.lsp.start_client(client.config)

			-- attach the new lsp client to the buffers the previous client was connected to
			vim.defer_fn(function()
				for _, bufnr in ipairs(clientBuffers) do vim.lsp.buf_attach_client(bufnr, clientId) end
			end, 100)
		end, 100)

		::continue::
	end
end)
