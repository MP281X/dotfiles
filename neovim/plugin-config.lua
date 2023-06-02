
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

local projectType = (function()
  if vim.fn.findfile("package.json") == "package.json" then
    return { 'zsh', '-c', 'pnpm run dev'}
  end

  if vim.fn.findfile("go.mod") == "go.mod" then
    return { 'zsh', '-c', 'go run main.go'}
  end

  if vim.fn.findfile("Cargo.lock") == "Cargo.lock" then
    return { 'zsh', '-c', 'cargo run'} 
  end

  return { 'zsh' }
end)()

require("FTerm").setup({ 
  auto_close = false,
  cmd = projectType  
})

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
    lualine_b = {{ "branch", icon="󰊢" }},
    lualine_c = {{ "buffers", symbols = {modified = ' 󱇨', alternate_file = ''} }},
    lualine_x = { "diagnostics" },
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
