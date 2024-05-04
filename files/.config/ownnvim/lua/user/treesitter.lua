local M = {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  build = ':TSUpdate',
}

function M.config()
  require('nvim-treesitter.configs').setup {
    auto_install = true,
    ensure_installed = {
      'bash',
      'css',
      'dockerfile',
      'elixir',
      'git_config',
      'git_rebase',
      'gitcommit',
      'gitignore',
      'graphql',
      'html',
      'javascript',
      'jsdoc',
      'json',
      'lua',
      'markdown',
      'markdown_inline',
      'python',
      'typescript',
      'yaml',
    },
    ignore_install = { '' },
    sync_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
