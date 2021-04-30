local options = { noremap = true, silent = true }
local map = vim.api.nvim_set_keymap
local cmd = vim.cmd

require('nvim_comment').setup()

map('n', '<leader>gcc', ':CommentToggle<CR>', options)
map('v', '<leader>gcc', ':CommentToggle<CR>', options)

-- temp override to get gcc access
cmd('nmap <expr> gcc (v:count? \':CommentToggle<CR>\' : \':set operatorfunc=CommentOperator<CR>g@\')')
