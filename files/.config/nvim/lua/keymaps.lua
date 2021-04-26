local g = vim.g
local map = vim.api.nvim_set_keymap
local cmd = vim.cmd
local options = {noremap = true, silent = true}

-- map leader key
map('n', ',', '<NOP>', options)
g.mapleader = ','

-- alternate way for saving files
map('n', '<leader>,', ':w<CR>', {})

-- better window movement
map('n', '<C-h>', '<C-w>h', {silent = true})
map('n', '<C-j>', '<C-w>j', {silent = true})
map('n', '<C-k>', '<C-w>k', {silent = true})
map('n', '<C-l>', '<C-w>l', {silent = true})
map('n', '<C-e>', '3<C-e>', options)
map('n', '<C-y>', '3<C-y>', options)

-- vnip
cmd 'imap <expr> <C-j>   vsnip#expandable()  ? \'<Plug>(vsnip-expand)\'         : \'<C-j>\''
cmd 'smap <expr> <C-j>   vsnip#expandable()  ? \'<Plug>(vsnip-expand)\'         : \'<C-j>\''

-- no hl
map('n', '<Leader>h', ':set hlsearch!<CR>', options)
