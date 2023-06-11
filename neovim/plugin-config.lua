-- script runner
vim.api.nvim_create_user_command("RUN", function(params)
  local args = params.args
  require('FTerm').scratch({ cmd = "bash ./script/" .. args .. ".sh" })
end, {
  nargs = 1,
  complete = function(A, L, P)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen("ls ./script/ | sed -e 's/\\..*$//'")
    for filename in pfile:lines() do
      i = i + 1
      t[i] = filename
    end
    pfile:close()
    return t
  end
})

-- color scheme
require("kanagawa").setup({
  keywordStyle = { italic = false },
  commentStyle = { italic = false },
  colors = { theme = { all = { ui = { bg_gutter = "none" } } } },
  overrides = function(colors)
    local theme = colors.theme
    return {
      NormalFloat = { bg = "none" },
      FloatBorder = { bg = "none" },
      FloatTitle = { bg = "none" },
      NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
      LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
      Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
      PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
      PmenuSbar = { bg = theme.ui.bg_m1 },
      PmenuThumb = { bg = theme.ui.bg_p2 },
    }
  end,
})
vim.cmd.colorscheme "kanagawa"

-- file explorer
require("nvim-tree").setup({
  view = { side = "right" },
  renderer = {
    root_folder_label = false,
    icons = { show = { git = false } },
  },
})

-- telescope (fuzzy finder)
require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      -- global
      ".git", ".gitignore",
      -- file
      ".png", ".woff2", ".webp", ".jpg",
      -- node
      "node_modules", ".prettierignore", ".eslintignore", "pnpm-lock.yaml",
      "tsconfig.json", "postcss.config.js", ".npmrc",
      -- rust
      "target", "Cargo.lock",
      -- golang
      "go.sum", ".pb",
    }
  },
  extensions = {
    undo = {
      use_delta = true,
      side_by_side = true,
      diff_context_lines = 15,
      entry_format = "[$ID]: $TIME",
      mappings = {
        i = {
          ["<leader>y"] = require("telescope-undo.actions").yank_additions,
          ["<leader>d"] = require("telescope-undo.actions").yank_deletions,
          ["<cr>"] = require("telescope-undo.actions").restore,
        },
      },
    },
  },
})
require("telescope").load_extension "undo"

-- floating terminal
require("FTerm").setup({
  auto_close = false,
  cmd = (function()
    if vim.fn.findfile("angular.json") == "angular.json" then return { 'zsh', '-c', 'npm run start' } end
    if vim.fn.findfile("package.json") == "package.json" then return { 'zsh', '-c', 'pnpm run dev' } end
    if vim.fn.findfile("go.mod") == "go.mod" then return { 'zsh', '-c', 'go run main.go' } end
    if vim.fn.findfile("Cargo.lock") == "Cargo.lock" then return { 'zsh', '-c', 'cargo run' } end
    return { 'zsh' }
  end)()
})

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
    lualine_b = { { "branch", icon = "󰊢" } },
    lualine_c = { { "buffers", symbols = { modified = ' 󱇨', alternate_file = '' } } },
    lualine_x = { "diagnostics" },
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})

-- session manager
require("auto-session").setup({
  log_level = "error",
  auto_session_suppress_dirs = { "~/" },
  cwd_change_handling = { post_cwd_changed_hook = function() require("lualine").refresh() end },
})
