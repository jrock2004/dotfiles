local keymap = require('lua-helpers/keymap')
local nmap = keymap.nmap
local g = vim.g
-- local tree_cb = require'nvim-tree.config'.nvim_tree_callback

require'nvim-tree'.setup {
  disable_netrw = true,
  hijack_netrw = true,
  open_on_setup = false,
  ignore_ft_on_setup = {'startify'},
  auto_close = true,
  open_on_tab = false,
  -- update_to_buf_dir = {
  --   enable = true,
  --   auto_open = true,
  -- },
  hijack_cursor = false,
  update_cwd = false,
  lsp_diagnostics = false,
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  view = {
    width = 30,
    height = 30,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {},
    }
  }
}

g.nvim_tree_ignore = { '.git', 'node_modules', '.cache' }

nmap('<leader>-', ':NvimTreeToggle<CR>')
