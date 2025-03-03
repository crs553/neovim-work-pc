return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},

  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons

  vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),

  lazy = false,
}
