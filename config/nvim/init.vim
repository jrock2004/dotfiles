set nocompatible

" Ensure that we have vim-plug installed
call functions#PlugLoad()

so ~/.config/nvim/plugins.vim
so ~/.config/nvim/editor.vim
so ~/.config/nvim/functions.vim
so ~/.config/nvim/keymap.vim
so ~/.config/nvim/coc.vim

" Manual Syntaxes / Filetypes
autocmd BufNewFile,BufRead *.hbs setfiletype handlebars
autocmd BufNewFile,BufRead *.tsx,*.jsx setfiletype typescript.tsx
autocmd FileType javascript setlocal foldmethod=syntax

