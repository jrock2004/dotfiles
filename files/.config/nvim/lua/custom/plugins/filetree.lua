vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>')

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require('neo-tree').setup {
      buffers = {
        follow_current_file = {
          enabled = true,
          highlight_opened_files = true,
        },
      },
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_hidden = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
      },
      window = {
        mappings = {
          ['<C-x>'] = 'open_split',
          ['<C-v>'] = 'open_vsplit',
        },
      },
    }
  end,
}
