-- nvim-tree (file explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({
  prefer_startup_root = true,
  view = { side = "right", hide_root_folder = true, signcolumn = "no" },
  renderer = { icons = { glyphs = { git = { unstaged = "󰤌", untracked = "" } } } }
})

-- theme
require("catppuccin").setup({
  flavour = "mocha",
  no_italic = false,
})

vim.cmd.colorscheme "catppuccin"

-- telescope (fuzzy finder)
require("telescope").setup({ defaults = { file_ignore_patterns = { "node_modules/", ".git/" } } })

-- auto close ()
require("nvim-autopairs").setup()

-- floating terminal
require("FTerm").setup({ cmd = "pwsh -noLogo" })

-- comment
require("Comment").setup()

-- lua line (statusline)
require("lualine").setup({
  options = {
    theme = "horizon",
    section_separators = "",
    component_separators = "",
    disabled_filetypes = { "packer", "NvimTree" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { "filename" },
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})
