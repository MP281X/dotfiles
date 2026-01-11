-- filters (applied to telescope and nvim-tree)
local filters = {
  --global
  ".git", ".gitignore", ".dockerignore",
  -- node
  "node_modules", "dist", "build",
  -- package managers
  "pnpm-lock.yaml", "bun.lock",
  -- cache
  "*.tsbuildinfo", ".turbo", ".drizzle", ".docs",
  ".next", "*env.d.ts", "app.d.ts", ".output", ".wrangler",
  ".tanstack", "routeTree.gen.ts", "worker-configuration.d.ts",
  "pnpm-workspace.yaml", "_generated",
  -- java
  ".idea", ".mvn", "target", "mvnw", ".micronaut", ".editorconfig",
  "Jenkinsfile", "ktlint", "jooq",
}

local nvimTreeFilters = function()
  local regex_arr = {}
  for _, item in ipairs(filters) do
    if item:sub(1, 1) == "*" then item = item:sub(2) else item = "^" .. item end
    if item:sub(-1) == "*" then item = item:sub(1, -2) else item = item .. "$" end

    table.insert(regex_arr, item)
  end

  return regex_arr
end

local telescopeFilters = function(args)
  for _, pattern in ipairs(filters) do
    table.insert(args, '-g')
    table.insert(args, '!' .. pattern)
  end

  return args
end

local sortFiles = function(nodes)
  table.sort(nodes, function(a, b)
    local a_idx = a.name:match("^index%.") or a.name:match("^+%.")
    local b_idx = b.name:match("^index%.") or b.name:match("^+%.")

    -- Index files always go last
    if a_idx and not b_idx then return false end
    if not a_idx and b_idx then return true end
    if a_idx and b_idx then return a.name:lower() < b.name:lower() end

    -- Both are non-index files, directories come first
    if a.type ~= b.type then return a.type == "directory" end

    -- If both are directories, prioritize lib and utils
    if a.type == "directory" then
      if a.name == "lib" and b.name ~= "lib" then return true end
      if b.name == "lib" and a.name ~= "lib" then return false end
      if a.name == "utils" and b.name ~= "utils" and b.name ~= "lib" then return true end
      if b.name == "utils" and a.name ~= "utils" and a.name ~= "lib" then return false end
    end

    return a.name:lower() < b.name:lower()
  end)
  return nodes
end


return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require("nvim-tree").setup({
        filters = { custom = nvimTreeFilters() },
        view = { side = "right", width = 60 },
        update_focused_file = { enable = true },
        git = { enable = true, ignore = false, timeout = 500 },
        sort = { sorter = sortFiles },
        renderer = {
          root_folder_label = false,
          icons = { show = { git = false } },
          special_files = { "index.ts", "index.tsx", "+page.tsx" }
        },
      })

      -- file browser keymap
      vim.keymap.set("n", "<leader>fb", ":NvimTreeToggle<CR>")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "debugloop/telescope-undo.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
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

      -- Load extensions
      require("telescope").load_extension("undo")
      require("telescope").load_extension("ui-select")

      -- Telescope keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sf", builtin.find_files, {})
      vim.keymap.set("n", "<leader>sc", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>se", builtin.diagnostics, {})
      vim.keymap.set("n", "<leader>sb", builtin.buffers, {})
      vim.keymap.set("n", "<leader>sr", builtin.lsp_references, {})
      vim.keymap.set("n", "<leader>u", ":Telescope undo<CR>")
    end,
  },
}
