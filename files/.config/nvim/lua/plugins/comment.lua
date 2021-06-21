local keymap = require('lua-helpers/keymap')
local nmap = keymap.nmap
local vmap = keymap.vmap
-- local cmd = vim.cmd

require('nvim_comment').setup()

nmap('<leader>gcc', ':CommentToggle<CR>')
vmap('<leader>gcc', ':CommentToggle<CR>')

-- temp override to get gcc access
-- cmd('nmap <expr> gcc (v:count? \':CommentToggle<CR>\' : \':set operatorfunc=CommentOperator<CR>g@\')')
