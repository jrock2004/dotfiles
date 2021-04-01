local on_attach = require'compe'.on_attach

require'lspconfig'.dockerls.setup {on_attach}
