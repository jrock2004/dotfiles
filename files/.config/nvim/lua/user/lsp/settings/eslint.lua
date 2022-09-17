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

return {
	-- cmd = { "eslint", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
	options = {
		overrideConfigFile = eslint_config,
	},
}
