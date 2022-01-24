local ls = require("luasnip")
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.snippets = {
	all = {
		s("date", t("this is a test")),
	},
	javascript = {
		s("log", fmt("console.log({log});", { log = i(1, "log") })),
		s(
			"setTimeout",
			fmt(
				[[
		    setTimeout(() => {{
		      {1}
		    }}, {2})
		    ]],
				{ i(1), i(2) }
			)
		),
	},
	typescript = {
		s("log", fmt("console.log({log});", { log = i(1, "log") })),
	},
}

ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "javascript" })

require("luasnip.loaders.from_vscode").lazy_load()
