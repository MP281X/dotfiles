local permanent_filters = {
  --global
  ".git", ".gitignore", ".dockerignore", ".vscode",
  -- node
  "node_modules", "dist", "build",
  -- package managers
  "pnpm-lock.yaml",
  -- frameworks js/ts configs
  "vite-env.d.ts", ".next", "next-env.d.ts",
  -- cache
  ".attest", "*.tsbuildinfo", "*-journal", ".wrangler",
  ".turbo", "_generated", "worker-configuration.d.ts",
  ".drizzle",
}

local conditional_filters = {
  -- global
  ".github",
  -- claude
  ".mcp.json", ".claude", "CLAUDE.md", "AGENTS.md",
  -- package managers
  "pnpm-workspace.yaml", ".npmrc",
  -- js/ts configs
  "*.config.*", "tsconfig.json", "tsconfig.base.json", "biome.jsonc", "biome.json",
  -- sveltekit/nextjs
  "entry-client.tsx", "entry-server.tsx",
  "app.html", "app.css", "index.css", "globals.css", "index.html",
  -- codegen
  "*.g.ts", "*.g.d.ts", "env.d.ts", "turbo.json", "wrangler.jsonc"
}

local nvimTreeFilters = function()
  local filters = {}
  if Enable_filters then
    filters = vim.list_extend(permanent_filters, conditional_filters)
  else
    filters = permanent_filters
  end

  local regex_arr = {}
  for _, item in ipairs(filters) do
    if item:sub(1, 1) == "*" then item = item:sub(2) else item = "^" .. item end
    if item:sub(-1) == "*" then item = item:sub(1, -2) else item = item .. "$" end

    table.insert(regex_arr, item)
  end
  return regex_arr
end

local telescopeFilters = function(args)
  local filters = {}
  if Enable_filters then
    filters = vim.list_extend(permanent_filters, conditional_filters)
  else
    filters = permanent_filters
  end

  for _, pattern in ipairs(filters) do
    table.insert(args, '-g')
    table.insert(args, '!' .. pattern)
  end
  return args
end

local sortFiles = function(nodes)
  table.sort(nodes, function(a, b)
    if a.type ~= b.type then return a.type == "directory" end
    local a_idx = a.name:match("^index%.") or a.name:match("^+%.")
    local b_idx = b.name:match("^index%.") or b.name:match("^+%.")
    if a_idx ~= b_idx then return b_idx end
    return a.name:lower() < b.name:lower()
  end)
  return nodes
end

-- file explorer
require("nvim-tree").setup({
  filters = { custom = nvimTreeFilters() },
  view = { side = "right", width = 60 },
  update_focused_file = { enable = true },
  git = { enable = true, ignore = false, timeout = 500 },
  sort = { sorter = sortFiles },
  renderer = {
    root_folder_label = false,
    icons = { show = { git = false } },
    special_files = { "index.ts", "+page.tsx" }
  },
})

-- telescope (fuzzy finder)
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<Tab>"] = require('telescope.actions').move_selection_next,
        ["<S-Tab>"] = require('telescope.actions').move_selection_previous,
      }
    }
  },
  pickers = {
    live_grep = { additional_args = telescopeFilters({ '--hidden', '--no-ignore' }) },
    find_files = { find_command = telescopeFilters({ 'rg', '--files', '--hidden', '--no-ignore' }) },
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown({}) },
    undo = {
      use_delta = true,
      side_by_side = true,
      vim_diff_opts = { ctxlen = 15 },
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

require("telescope").load_extension("undo")      -- undo tree
require('telescope').load_extension('fzf')       -- use fzf for better performance
require("telescope").load_extension("ui-select") -- replace select panel with telescope
