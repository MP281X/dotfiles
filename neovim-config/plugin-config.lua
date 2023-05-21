-- theme
require("catppuccin").setup({
  flavour = "mocha",
  no_italic = true,
})

vim.cmd.colorscheme "catppuccin"

-- telescope (fuzzy finder)
require("telescope").setup({
  defaults = { file_ignore_patterns = { "node_modules/", ".git/" } },
  extensions = {
    file_browser = {
      hijack_netrw = true,
      git_status = false,
      grouped = true,
      hidden = true,
      collapse_dirs = true,
    }
  }
})

require("telescope").load_extension "file_browser"
--autocmd User TelescopePreviewerLoaded setlocal wrap

-- auto close ()
require("nvim-autopairs").setup()

-- floating terminal
require("FTerm").setup({ cmd = "bash" })

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
