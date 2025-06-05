-- Innstall plugins: mason.nvim, nvim-lspconfig
return {
  {
    'williamboman/mason.nvim',
    tag = "v2.0.0-rc.2",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })
    end,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    tag = "v2.0.0-rc.1",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "pylsp", "marksman", "bashls", "lua_ls", "rust_analyzer", "matlab_ls", "harper_ls" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    tag = "v2.1.0",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      -- autocompletion
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require("lspconfig")

      -- lua
      lspconfig.lua_ls.setup({ capabilites = capabilities })

      -- python
      lspconfig.pylsp.setup({
        capabilites = capabilities,
        plugins = {
          black = { enabled = true },
          pyflakes = { enabled = false },
          pycodestyle = { enabled = false },
        }
      })

      -- nixd
      lspconfig.nixd.setup({ capabilites = capabilities })

      -- markdown
      lspconfig.marksman.setup({ capabilities = capabilities })

      -- bash
      lspconfig.bashls.setup({ capabilities = capabilities })

      -- go lsp
      lspconfig.gopls.setup({ capabilities = capabilities })

      -- rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            checkOnSave = {
              enable = true,
              command = "clippy",
            }
          },
        },

      })

      --matlab
      lspconfig.matlab_ls.setup({
        --cmd = { 'C:\\Users\\charlie\\AppData\\Local\\nvim-data\\mason\\packages\\matlab-language-server\\matlab-language-server.cmd' },
        cmd = {
          vim.fn.expand(
            "C:\\Users\\charlie\\AppData\\Local\\nvim-data\\mason\\packages\\matlab-language-server\\matlab-language-server.cmd"
          ),
          "--stdio",
          "--matlabInstallPath='C:/Program Files/MATLAB/R2024b'",
        },
        --cmd = { 'matlab-language-server', '--stdio', '--matlabInstallPath="C:\\Program Files\\MATLAB\\R2024b"' },
        filetypes = { 'matlab' },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
        end,
        capabilites = capabilities,
        settings = {
          MATLAB = {
            indexWorkspace = true,
            matlabConnectionTiming = 'onStart',
            telemetry = true,
          },
        },
        single_file_support = false,
      })

      --autoformat on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then return end
          if client.supports_method('textDocument/formatting') then
            -- format the current buffer onsave
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
              end,
            })

            -- Create a keymap for vim.lsp.buf.rename()
          end
        end
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = {
      "BufReadPre",
      "BufNewFile",
    },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "pylint" },
      }
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = lint_augroup,
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "black" },
      },
    },
  },
}
