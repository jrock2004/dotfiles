local M = {
  'williamboman/mason-lspconfig.nvim',
  dependencies = {
    'williamboman/mason.nvim',
  },
}

function M.config()
  local servers = {
    'bashls',
    'cssls',
    'dockerls',
    'elixirls',
    'emmet_ls',
    'eslint',
    'graphql',
    'html',
    'jsonls',
    'lua_ls',
    'marksman',
    'pyright',
    'tailwindcss',
    'tsserver',
    'yamlls',
  }

  require('mason').setup {
    ui = {
      border = 'rounded',
    },
  }

  require('mason-lspconfig').setup {
    ensure_installed = servers,
  }
end

return M
