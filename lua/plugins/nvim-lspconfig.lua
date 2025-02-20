-- Install plugins: mason.nvim, nvim-lspconfig
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      'saghen/blink.cmp',
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

      -- lua
      require("lspconfig").lua_ls.setup { capabilites = capabilities }

      --python
      require 'lspconfig'.pylsp.setup { capabilites = capabilities }
      --matlab
      require("lspconfig").matlab_ls.setup {
        capabilities = capabilities,
        cmd = { "matlab-language-server", "--stdio" },
        filetypes = { "matlab" },
        single_file_support = true,
        settings = {
          MATLAB = {
            indexWorkspace = true,
            installPath = "C://Program Files/MATLAB/R2024a", -- might need to change this based on current matlab version
            matlabConnectionTiming = "onStart",
            telemetry = true,
          },

        },
      }

      --markdown
      require 'lspconfig'.marksman.setup { capabilities = capabilities }

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
  }
}
