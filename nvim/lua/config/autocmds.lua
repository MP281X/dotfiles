local augroup_yank = vim.api.nvim_create_augroup("HighlightYank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup_yank,
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

local augroup_terminal_mouse = vim.api.nvim_create_augroup("TerminalMouse", { clear = true })
vim.api.nvim_create_autocmd("TermEnter", {
  group = augroup_terminal_mouse,
  pattern = "*",
  callback = function() vim.opt.mouse = "a" end,
})
vim.api.nvim_create_autocmd("TermLeave", {
  group = augroup_terminal_mouse,
  pattern = "*",
  callback = function() vim.opt.mouse = "" end,
})
