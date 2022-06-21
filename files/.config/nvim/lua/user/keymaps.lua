local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Remap comma as leader key
--keymap("", ",", "<Nop>", opts)
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Turn off highlighting
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>t", "<cmd>ToggleTerm direction=vertical size=30<CR>", opts)

-- Custom --
-- Faster way to save a file
keymap("n", "<leader>,", ":w<CR>", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
keymap("n", "<leader>f", ":Telescope find_files hidden=true<CR>", opts)
keymap("n", "<leader>F", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>P", ":Telescope projects<CR>", opts)
keymap("n", "<leader>b", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>sc", ":Telescope colorscheme<CR>", opts)
keymap("n", "<leader>sh", ":Telescope help_tags<CR>", opts)
keymap("n", "<leader>sk", ":Telescope keymaps<CR>", opts)
keymap("n", "<leader>sC", ":Telescope commands<CR>", opts)

-- LSP
keymap("n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<CR>", opts)
keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting({ async = true })<CR>", opts)
keymap("n", "<leader>lF", "<cmd>LspToggleAutoFormat<CR>", opts)
keymap("n", "<leader>li", "<cmd>LspInfo<CR>", opts)
keymap("n", "<leader>lI", "<cmd>LspInstallInfo<CR>", opts)
keymap("n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", opts)
keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", opts)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

-- Packer
keymap("n", "<leader>pc", "<cmd>PackerCompile<CR>", opts)
keymap("n", "<leader>pi", "<cmd>PackerInstall<CR>", opts)
keymap("n", "<leader>ps", "<cmd>PackerSync<CR>", opts)
keymap("n", "<leader>pS", "<cmd>PackerStatus<CR>", opts)
keymap("n", "<leader>pu", "<cmd>PackerUpdate<CR>", opts)

-- Misc
keymap("n", "<S-x>", "<cmd>Bdelete!<CR>", opts)
keymap("n", "Y", "y$", opts)
