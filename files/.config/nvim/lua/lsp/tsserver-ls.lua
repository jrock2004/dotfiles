local on_attach = require'compe'.on_attach

require'lspconfig'.tsserver.setup {
	on_attach = on_attach
}
