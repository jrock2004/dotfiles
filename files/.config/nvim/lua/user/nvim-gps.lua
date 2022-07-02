local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
	return
end

gps.setup({
	icons = {
		["array-name"] = " ",
		["boolean-name"] = "蘒 ",
		["class-name"] = " ",
		["container-name"] = " ",
		["date-name"] = " ",
		["date-time-name"] = " ",
		["float-name"] = " ",
		["function-name"] = " ",
		["inline-table-name"] = " ",
		["integer-name"] = " ",
		["mapping-name"] = " ",
		["method-name"] = " ",
		["module-name"] = " ",
		["null-name"] = " ",
		["number-name"] = " ",
		["object-name"] = " ",
		["sequence-name"] = " ",
		["string-name"] = " ",
		["table-name"] = " ",
		["tag-name"] = " ",
		["time-name"] = " ",
	},
})
