local M = {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
}

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local async_formatting = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  vim.lsp.buf_request(bufnr, 'textDocument/formatting', vim.lsp.util.make_formatting_params {}, function(err, res, ctx)
    if err then
      local err_msg = type(err) == 'string' and err or err.message
      -- you can modify the log message / level (or ignore it completely)
      vim.notify('formatting: ' .. err_msg, vim.log.levels.WARN)
      return
    end

    -- don't apply results if buffer is unloaded or has been modified
    if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, 'modified') then
      return
    end

    if res then
      local client = vim.lsp.get_client_by_id(ctx.client_id)
      vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or 'utf-16')
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd 'silent noautocmd update'
      end)
    end
  end)
end

function M.config()
  local null_ls = require 'null-ls'

  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics

  -- If having timeout issues, increase the timeout
  -- vim.lsp.buf.format({ timeout_ms = 2000 })

  null_ls.setup {
    debug = false,
    sources = {
      formatting.stylua,
      formatting.prettier,
      formatting.black,
      -- formatting.prettier.with {
      --   extra_filetypes = { "toml" },
      --   -- extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
      -- },
      -- formatting.eslint,
      -- null_ls.builtins.diagnostics.flake8,
      -- diagnostics.flake8,
      null_ls.builtins.completion.spell,
    },
    -- Sync formatting
    -- on_attach = function(client, bufnr)
    --   if client.supports_method 'textDocument/formatting' then
    --     vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    --     vim.api.nvim_create_autocmd('BufWritePre', {
    --       group = augroup,
    --       buffer = bufnr,
    --       callback = function()
    --         -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
    --         -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
    --         vim.lsp.buf.formatting_sync()
    --       end,
    --     })
    --   end
    -- end,

    -- Async formatting
    on_attach = function(client, bufnr)
      if client.supports_method 'textDocument/formatting' then
        vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
        vim.api.nvim_create_autocmd('BufWritePost', {
          group = augroup,
          buffer = bufnr,
          callback = function()
            async_formatting(bufnr)
          end,
        })
      end
    end,
  }
end

return M
