local options = {
	backup = false,
	clipboard = "unnamedplus",
	cmdheight = 2,
	completeopt = { "menuone", "noselect" },
	conceallevel = 0,
	expandtab = true,
	fileencoding = "utf-8",
	hlsearch = true,
	incsearch = true,
	ignorecase = true,
	laststatus = 2,
	mouse = "a",
	pumheight = 10,
	shiftwidth = 2,
	showmode = false,
	showtabline = 2,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	tabstop = 2,
	termguicolors = true,
	timeoutlen = 100,
	undofile = true,
	updatetime = 300,
	writebackup = false,
	cursorline = true,
	number = true,
	relativenumber = false,
	numberwidth = 4,
	signcolumn = "yes",
	wrap = true,
	scrolloff = 8,
	sidescrolloff = 8,
	guifont = "monospace:h17",
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])
