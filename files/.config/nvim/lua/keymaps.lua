local g = vim.g
local map = vim.api.nvim_set_keymap
local options = { noremap = true, silent = true }

-- map leader key
map('n', ',', '<NOP>', options)
g.mapleader = ','

-- alternate way for saving files
map('n', '<leader>,', ':w<CR>', {})
