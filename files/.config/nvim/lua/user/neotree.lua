local M = {
  'nvim-neo-tree/neo-tree.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
}

function M.config()
  local wk = require 'which-key'

  wk.register {
    ['<leader>e'] = {
      function()
        local lspconfig = require 'lspconfig'
        local root_patterns = { '.git' }
        local root_dir = lspconfig.util.root_pattern(unpack(root_patterns))(vim.fn.expand '%:p')

        require('neo-tree.command').execute { toggle = true, dir = root_dir }
      end,
      'Explorer',
    },
  }

  local icons = require 'user.icons'

  require('neo-tree').setup {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = true,
        hide_hidden = true,
        hide_by_name = {
          '.git',
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
    },
    buffers = {
      follow_current_file = {
        enabled = true,
      },
    },
    -- close_if_last_window = true,
    -- hijack_netrw = false,
    -- open_on_setup = false,
    -- auto_close = true,
    -- update_to_buf_dir = {
    --   enable = true,
    --   auto_open = true,
    -- },
    -- view = {
    --   width = 30,
    --   side = 'left',
    --   auto_resize = true,
    -- },
    -- ignore = { '.git', '.cache', '.local', '.npm', '.rustup', '.stack', '.svn', '.vscode', '.yarn' },
    -- tree = {
    --   show_icons = {
    --     git = false,
    --     folders = true,
    --     files = true,
    --   },
    --   icons = {
    --     default = icons.ui.Text,
    --     symlink = icons.ui.FileSymlink,
    --     bookmark = icons.ui.BookMark,
    --     folder = {
    --       arrow_closed = icons.ui.ChevronRight,
    --       arrow_open = icons.ui.ChevronShortDown,
    --       default = icons.ui.Folder,
    --       open = icons.ui.FolderOpen,
    --       empty = icons.ui.EmptyFolder,
    --       empty_open = icons.ui.EmptyFolderOpen,
    --       symlink = icons.ui.FolderSymlink,
    --       symlink_open = icons.ui.FolderOpen,
    --     },
    --     git = {
    --       unstaged = icons.git.FileUnstaged,
    --       staged = icons.git.FileStaged,
    --       unmerged = icons.git.FileUnmerged,
    --       renamed = icons.git.FileRenamed,
    --       untracked = icons.git.FileUntracked,
    --       deleted = icons.git.FileDeleted,
    --       ignored = icons.git.FileIgnored,
    --     },
    --   },
    -- },
  }
end

return M
