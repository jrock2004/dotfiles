-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Setting leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Set filetypes
vim.cmd("autocmd BufRead *.dockerfile* set filetype=dockerfile")
vim.cmd("autocmd BufRead *.env* set filetype=sh")
vim.cmd("autocmd BufRead *.handlebars set filetype=handlebars")
