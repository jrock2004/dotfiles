local cmd = vim.cmd

local luaFormat = {
  formatCommand = 'lua-format -i --no-keep-simple-function-one-line --column-limit=120 --indent-width=2 --double-quote-to-single-quote',
  formatStdin = true
}

local prettierFormat = {formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true}

local eslintFormat = {
  lintCommand = './node_modules/.bin/eslint -f unix --stdin --stdin-filename ${INPUT}',
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {'%f:%l:%c: %m'},
  formatCommand = './node_modules/.bin/eslint --fix-dry-run --stdin --stdin-filename=${INPUT}',
  formatStdin = true
}

require'lspconfig'.efm.setup {
  cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
  init_options = {documentFormatting = true},
  filetypes = {'lua', 'typescriptreact', 'typescript'},
  settings = {
    rootMarkers = {'.git/'},
    languages = {
      lua = {luaFormat},
      typescriptreact = {prettierFormat, eslintFormat},
      typescript = {prettierFormat, eslintFormat}
    }
  }
}

-- format on save
cmd('autocmd BufWritePre *.lua lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.tsx lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.ts lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.jsx lua vim.lsp.buf.formatting_sync(nil, 1000)')
cmd('autocmd BufWritePre *.js lua vim.lsp.buf.formatting_sync(nil, 1000)')
