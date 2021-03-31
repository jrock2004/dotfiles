local options = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap

require('nvim_comment').setup()

map('n', '<leader>gcc', ':CommentToggle<CR>', options)
map('v', '<leader>gcc', ':CommentToggle<CR>', options)
