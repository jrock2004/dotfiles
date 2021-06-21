local keymap = require('lua-helpers/keymap')
local nmap = keymap.nmap
local g = vim.g
local tree_cb = require'nvim-tree.config'.nvim_tree_callback

-- plugin settings
g.nvim_tree_auto_close = 1
g.nvim_tree_auto_ignore_ft = 'startify'
g.nvim_tree_follow = 1
g.nvim_tree_indent_markers = 1
g.nvim_tree_hide_dotfiles = 0
g.nvim_tree_bindings = {
  ["<CR>"] = tree_cb("edit"),
}

nmap('<leader>k', ':NvimTreeToggle<CR>')
