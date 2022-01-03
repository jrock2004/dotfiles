local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

keymap("i", "<C-j>", "<silent><script><expr> <C-J> copilot#Accept("\<CR>")", opts)
vim.cmd("let g:copilot_no_tab_map = 1")
