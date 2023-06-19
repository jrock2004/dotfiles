return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    buffers = {
      follow_current_file = false,
    },
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_hidden = false,
      },
      follow_current_file = true,
    },
    window = {
      mappings = {
        ["<C-x>"] = "open_split",
        ["<C-v>"] = "open_vsplit",
      },
    },
  },
}
