return {
	default_config = {
		cmd = { "emmet-ls", "--stdio" },
		filetypes = { "html", "css", "blade", "typescriptreact", "javascriptreact" },
		root_dir = function(fname)
			return vim.loop.cwd()
		end,
		settings = {},
	},
}
