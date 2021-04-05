-- :LspInstall bash
local on_attach = require'compe'.on_attach

require'lspconfig'.bashls.setup{on_attach=on_attach}
