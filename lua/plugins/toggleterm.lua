return {
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      --[[ things you want to change go here]]
      open_mapping = [[<M-i>]],
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      direction = "float",
      float_opts = {
        border = "curved",
        winblend = 3,
      },
      shell = vim.fn.has("win32") == 1 and "powershell.exe" or vim.o.shell,
    },
    config = function(_, opts)
      require("toggleterm").setup(opts)

      vim.keymap.set("n", "<M-i>", vim.cmd.ToggleTerm)
      vim.keymap.set("t", "<M-i>", vim.cmd.ToggleTerm)
    end,

  }
}
