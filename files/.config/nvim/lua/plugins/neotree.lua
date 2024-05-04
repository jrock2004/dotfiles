return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  opts = {
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
        ["<C-x>"] = "open_split",
        ["<C-v>"] = "open_vsplit",
      },
    },
  },
}
