local keymap = require('lua-helpers/keymap')
local nmap = keymap.nmap

-- alternate way for saving files
nmap('<leader>,', ':w<CR>')

-- better window movement
nmap('<C-h>', '<C-w>h', {silent = true})
nmap('<C-j>', '<C-w>j', {silent = true})
nmap('<C-k>', '<C-w>k', {silent = true})
nmap('<C-l>', '<C-w>l', {silent = true})
nmap('<C-e>', '3<C-e>')
nmap('<C-y>', '3<C-y>')

-- vnip
vim.cmd 'imap <expr> <C-j>   vsnip#expandable()  ? \'<Plug>(vsnip-expand)\'         : \'<C-j>\''
vim.cmd 'smap <expr> <C-j>   vsnip#expandable()  ? \'<Plug>(vsnip-expand)\'         : \'<C-j>\''

-- toggle hl
nmap('<leader>h', ':set hlsearch!<CR>')
