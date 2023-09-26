return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  keys = {
    { '<leader>,', false },
  },
  opts = {
    pickers = {
      find_files = {
        hidden = true,
        file_ignore_patterns = { 'node_modules', '.git' },
      },
      live_grep = {
        additional_args = function(opts)
          return { '--hidden' }
        end,
      },
    },
  },
}
