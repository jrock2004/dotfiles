-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.cmd("autocmd BufRead *.dockerfile* set filetype=dockerfile")
vim.cmd("autocmd BufRead *.env* set filetype=sh")
vim.cmd("autocmd BufRead *.handlebars set filetype=handlebars")

vim.g.lazyvim_eslint_auto_format = true

vim.lsp.enable("copilot")
