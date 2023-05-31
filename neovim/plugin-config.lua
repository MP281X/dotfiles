
-- theme
require("catppuccin").setup({
  flavour = "mocha",
  no_italic = true,
})
vim.cmd.colorscheme "catppuccin"

-- telescope (fuzzy finder)
require("telescope").setup({
  defaults = { file_ignore_patterns = { 
    ".git/", ".gitignore", -- global
    ".png", ".woff2", ".webp", ".jpg", -- file
    "node_modules/", ".prettierignore", ".eslintignore", "pnpm-lock.yaml", "tsconfig.json", "postcss.config.js", ".npmrc", -- node
    "target/", "Cargo.lock", -- rust
    "go.sum", ".pb", -- golang
  } },
  extensions = {
    file_browser = {
      hijack_netrw = true,
      hidden = true,
      grouped = true,
      auto_depth = true,
      git_status = false,
    },
    undo = {
      use_delta = true,
      side_by_side = true,
      diff_context_lines = 15,
      entry_format = "[$ID]: $TIME",
      mappings = { i = { ["<cr>"] = require("telescope-undo.actions").restore } },
    }
  }
})
require("telescope").load_extension "file_browser"
require("telescope").load_extension "undo"

-- auto close ()
require("nvim-autopairs").setup()

-- floating terminal
require("FTerm").setup({ cmd = os.getenv('SHELL') })

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

-- session manager
require("auto-session").setup({
  log_level = "error",
  auto_session_suppress_dirs = { "~/" },
  cwd_change_handling = {
    post_cwd_changed_hook = function()
      require("lualine").refresh()
    end,
  },
})

-- tabs
require("bufferline").setup({
  options = { 
    show_buffer_close_icons = false,
    diagnostics = "nvim_lsp",
    modified_icon = "󱇨",
    indicator = { style = "none" },
  },
  highlights = {
    buffer_selected = { italic = false },
	  diagnostic_selected = { italic = false },
	  hint_selected = { italic = false },
	  pick_selected = { italic = false },
	  error_selected = { italic = false },
	  pick = { italic = false },
    modified = { fg = '#6c6f93' },
    modified_visible = { fg = '#6c6f93' },
    modified_selected = { fg = '#6c6f93' },
  },
})
