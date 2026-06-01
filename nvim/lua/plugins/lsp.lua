return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "saghen/blink.cmp" },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities()
      )
      capabilities.general = capabilities.general or {}
      capabilities.general.positionEncodings = { "utf-16" }

      vim.lsp.config("*", { capabilities = capabilities })

      local home = vim.uv.os_homedir()
      local vite_bin = vim.fs.joinpath(home, ".vite-plus", "bin")
      local vite_lsp_bin = vim.fs.joinpath(home, ".vite-plus", "current", "node_modules", ".bin")
      local lsp_env = { PATH = vite_bin .. ":" .. (vim.env.PATH or "") }

      local function has_vite_key(file, key)
        local ok, lines = pcall(vim.fn.readfile, file)
        local contents = ok and table.concat(lines, "\n") or ""
        return contents:find("{%s*" .. key .. "%s*:") or contents:find("\n%s*" .. key .. "%s*:")
      end

      local function root_dir(key)
        return function(bufnr, on_dir)
          local file = vim.api.nvim_buf_get_name(bufnr)
          for _, config in ipairs(vim.fs.find("vite.config.ts", { path = file, upward = true, limit = math.huge })) do
            if has_vite_key(config, key) then
              on_dir(vim.fs.dirname(config))
              return
            end
          end
        end
      end

      local function cmd(binary)
        return function(dispatchers, config)
          local root_dir = config.root_dir or vim.fn.getcwd()
          local command = vim.fs.joinpath(root_dir, "node_modules", ".bin", binary)
          if vim.fn.executable(command) == 0 then
            local fallback = vim.fs.joinpath(vite_lsp_bin, binary)
            command = vim.fn.executable(fallback) == 1 and fallback or binary
          end
          local args = { command }
          vim.list_extend(args, { "--lsp" })

          if binary == "oxfmt" then
            vim.list_extend(args, { "--config", vim.fs.joinpath(root_dir, "vite.config.ts") })
          end

          return vim.lsp.rpc.start(args, dispatchers, {
            cwd = root_dir,
            env = lsp_env,
          })
        end
      end

      vim.lsp.config("tsgo", { cmd = { "tsgo", "--lsp", "--stdio" } })
      vim.lsp.config("nixd", {})
      vim.lsp.config("oxlint", {
        cmd = cmd("oxlint"),
        root_dir = root_dir("lint"),
        settings = {
          run = "onType",
          fixKind = "safe_fix",
          typeAware = true,
          unusedDisableDirectives = "deny",
        },
      })
      vim.lsp.config("oxfmt", {
        cmd = cmd("oxfmt"),
        root_dir = root_dir("fmt"),
      })
      vim.lsp.config("tailwindcss", {
        settings = {
          tailwindCSS = {
            files = {
              exclude = {
                "**/.git/**",
                "**/.opencode/**",
                "**/node_modules/**",
              },
            },
          },
        },
      })
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

      vim.lsp.enable({ "tsgo", "oxlint", "oxfmt", "tailwindcss", "lua_ls", "nixd" })

      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "x",
            [vim.diagnostic.severity.WARN] = "▲",
            [vim.diagnostic.severity.HINT] = "⚑",
            [vim.diagnostic.severity.INFO] = "»",
          },
        },
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        float = { source = "always", border = "rounded" },
        severity_sort = true,
        update_in_insert = false,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, silent = true }
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          vim.keymap.set("n", "<leader>gd", require('telescope.builtin').lsp_definitions, opts)
          vim.keymap.set("n", "<leader>gr", require('telescope.builtin').lsp_references, opts)
          vim.keymap.set("n", "<leader>gi", require('telescope.builtin').lsp_implementations, opts)
          vim.keymap.set("n", "<leader>gt", require('telescope.builtin').lsp_type_definitions, opts)
          vim.keymap.set("n", "<leader>sa", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "E", vim.diagnostic.open_float, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "R", vim.lsp.buf.rename, opts)

          -- Disable heavy features for snappiness
          if client then
            client.server_capabilities.semanticTokensProvider = nil
            client.server_capabilities.documentHighlightProvider = false
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.js", "*.jsx", "*.ts", "*.tsx", "*.json", "*.jsonc", "*.json5", "*.html", "*.css", "*.scss", "*.less", "*.md", "*.toml", "*.yaml", "*.yml", "*.graphql" },
        callback = function()
          vim.lsp.buf.format({ filter = function(c) return c.name == "oxfmt" end, timeout_ms = 1000 })
        end,
      })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.lua",
        callback = function()
          vim.lsp.buf.format({ filter = function(c) return c.name == "lua_ls" end, timeout_ms = 1000 })
        end,
      })
    end,
  },
}
