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
    default_component_configs = {
      icon = {
        folder_closed = icons.ui.Folder,
        folder_open = icons.ui.FolderOpen,
        folder_empty = icons.ui.EmptyFolder,
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = '*',
        highlight = 'NeoTreeFileIcon',
      },
      git_status = {
        symbols = {
          -- Change type
          added = icons.git.LineAdded, -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified = icons.git.LineModified, -- or "", but this is redundant info if you use git_status_colors on the name
          deleted = icons.git.FileDeleted, -- this can only be used in the git_status source
          renamed = icons.git.FileRenamed, -- this can only be used in the git_status source
          -- Status type
          untracked = icons.git.FileUntracked,
          ignored = icons.git.FileIgnored,
          unstaged = icons.git.FileUnstaged,
          staged = icons.git.FileStaged,
          conflict = '',
        },
      },
    },
    window = {
      mappings = {
        ['<C-x>'] = 'open_split',
        ['<C-v>'] = 'open_vsplit',
      },
    },
  }
end

return M
