-- Set all variations of dockerfile to right type
vim.cmd("autocmd BufRead *.dockerfile* set filetype=dockerfile")

-- Set all variations of env to right type
vim.cmd("autocmd BufRead *.env* set filetype=sh")

-- Set all variations of handlebars to right type
vim.cmd("autocmd BufRead *.handlebars set filetype=handlebars")
