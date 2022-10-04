local status_ok, navic = pcall(require, "nvim-navic")
if not status_ok then
	return
end

navic.setup({
	highlight = false,
	icons = {
		Array = " ",
		Boolean = "蘒 ",
		Class = " ",
		Container = " ",
		Date = " ",
		DateTime = " ",
		Float = " ",
		Function = " ",
		InlineTable = " ",
		Integer = " ",
		Mapping = " ",
		Method = " ",
		Module = " ",
		Null = " ",
		Number = " ",
		Object = " ",
		Sequence = " ",
		String = " ",
		Table = " ",
		Tag = " ",
		Time = " ",
	},
	separator = " > ",
})
