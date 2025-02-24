require("config.lazy")
require("cs-config")
require('lualine').setup {}

vim.cmd.colorscheme "catppuccin-mocha"

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- sourcing files for changes
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")


vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- In terminal compiling (unused as you can't do this with matlab)
-- local job_id = 0

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Customise terminal opening',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false

    -- In terminal compiling (unused as you can't do this with matlab)
    -- job_id = vim.bo.channel
  end,
})

-- open terminal
vim.keymap.set("n", "<M-i>", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)

vim.keymap.set('t', '<M-i>', '<C-\\><C-n>:bd!<CR>,', { noremap = true, silent = true })
