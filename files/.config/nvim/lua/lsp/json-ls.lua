local on_attach = require'compe'.on_attach

require'lspconfig'.jsonls.setup {
	on_attach=on_attach,
	commands = {
		Format = {
			function()
				vim.lsp.buf.range_formatting({}, {0, 0}, {vim.fn.line("$"), 0})
			end
		}
	}
}
