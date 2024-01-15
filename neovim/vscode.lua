--? base config
-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- tabs and indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.scrolloff = 15

--? keymaps config
-- remap space
vim.g.mapleader = ' '
vim.keymap.set('n', '<Space>', '<NOP>')


vim.keymap.set('n', 'd', '"_d')                -- delete a single letter without coping it
vim.keymap.set('v', 'd', '"_d')                -- delete a single letter without coping it
vim.keymap.set('n', 'c', '"_c')

-- movement
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

--? vscode config
local vscode = require('vscode-neovim')
local keymap = function (cmd) return function() vscode.action(cmd) end end

-- buffers
vim.keymap.set('n', '<<', keymap("workbench.action.previousEditor"))
vim.keymap.set('n', '>>', keymap("workbench.action.nextEditor"))

-- comment a line
vim.keymap.set('n', '<leader>gc', keymap("editor.action.commentLine"))

-- script runner
vim.api.nvim_create_user_command("RUN", function(params)
  if params.args ~= {} then
    vscode.call("workbench.action.terminal.toggleTerminal")
    vscode.call("workbench.action.terminal.sendSequence", {
      args = { text = "; clear && ./script/".. params.args ..".ps1" .."\n"}
    })
  end
end, {
  nargs = 1,
  complete = function(_, _, _)
    local scriptNames = {}

    for _, fileName in ipairs(vim.fn.readdir("./script")) do
      if fileName:match("%.ps1$") then
        table.insert(scriptNames, fileName:match("^(.+)%..+$"))
      end
    end

    return vim.list_extend(scriptNames, {"_"})
  end
})