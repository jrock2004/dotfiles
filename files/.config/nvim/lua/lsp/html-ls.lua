local capabilities = vim.lsp.protocol.make_client_capabilities()
local on_attach = require'compe'.on_attach
capabilities.textDocument.completion.completionItem.snippetSupport = true

require'lspconfig'.html.setup {
	capabilities = capabilities,
	on_attach=on_attach
}
