local function eslint_config()
	local f = io.open("package.json", "r")

	if f ~= nil then
		local package = f:read("*all")

		if package:find('"eslintConfig"') then
			io.close(f)
			return "package.json"
		end

		io.close(f)

		return "package.json"
	end

	return nil
end

-- https://github.com/pedro757/emmet
-- npm i -g ls_emmet
return {
	cmd = { "ls_emmet", "--stdio" },
	filetypes = {
		"html",
		"css",
		"scss",
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"haml",
		"xml",
		"xsl",
		"pug",
		"slim",
		"sass",
		"stylus",
		"less",
		"sss",
		"hbs",
		"handlebars",
	},
	options = {
		overrideConfigFile = eslint_config,
	},
}
