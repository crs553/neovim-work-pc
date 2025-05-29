return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      --[[ things you want to change go here]]
      open_mapping = [[<M-i>]],
      direction = 'vertical'
    },
    config = function()
      require("toggleterm").setup()

      vim.keymap.set("n", "<M-i>", vim.cmd.ToggleTerm)
      vim.keymap.set("t", "<M-i>", vim.cmd.ToggleTerm)
    end,

  }
}
