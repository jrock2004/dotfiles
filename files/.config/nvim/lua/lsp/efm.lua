local lspconfig = require 'lspconfig'

local prettier = {formatCommand = './node_modules/.bin/prettier --stdin-filepath ${INPUT}', formatStdin = true}
local luaFormat = {
  formatCommand = 'lua-format -i --no-keep-simple-function-one-line --column-limit=120 --indent-width=2 --double-quote-to-single-quote',
  formatStdin = true
}

lspconfig.efm.setup {
  -- cmd = {'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5'},
  on_attach = on_attach,
  init_options = {documentFormatting = true},
  filetypes = {'javascriptreact', 'javascript', 'lua', 'typescriptreact', 'typescript'},
  settings = {
    rootMarkers = {'.git/'},
    languages = {lua = {luaFormat}, typescript = {prettier}, typescriptreact = {prettier}}
  }
}
