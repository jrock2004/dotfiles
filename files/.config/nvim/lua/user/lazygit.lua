local M = {
  'kdheepak/lazygit.nvim',
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}

function M.config()
  local wk = require 'which-key'

  wk.register {
    ['<leader>gg'] = { '<cmd>LazyGit<cr>', 'LazyGit' },
    ['<leader>gc'] = { '<cmd>LazyGitConfig<cr>', 'LazyGitConfig' },
    ['<leader>gf'] = { '<cmd>LazyGitCurrentFile<cr>', 'LazyGitCurrentFile' },
    ['<leader>gF'] = { '<cmd>LazyGitFilter<cr>', 'LazyGitFilter' },
    ['<leader>gC'] = { '<cmd>LazyGitFilterCurrentFile<cr>', 'LazyGitFilterCurrentFile' },
  }
end

return M
