local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

local custom_on_attach = function(client)
	if client.server_capabilities.documentFormattingProvider then
		vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 2000 })")
	end
end

null_ls.setup({
	debug = false,
	on_attach = custom_on_attach,
	sources = {
		formatting.prettier.with({
			extra_filetypes = { "toml" },
			condition = function(utils)
				return utils.root_has_file(".prettierrc")
			end,
			prefer_local = "node_modules/.bin",
		}),
		formatting.black.with({ extra_args = { "--fast" } }),
		formatting.stylua,
		formatting.google_java_format,
		diagnostics.eslint,
		diagnostics.shellcheck,
	},
})
