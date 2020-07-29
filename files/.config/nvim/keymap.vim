let mapleader = ','
let maplocalleader = ','

"""""""""""""""""""
" File Management
"""""""""""""""""""
nmap <leader>, :w<cr>

" Search
if isdirectory(".git")
  " if in a git project, use :GFiles
  nmap <silent> <leader>t :GitFiles --cached --others --exclude-standard<cr>
else
  " otherwise, use :FZF
  nmap <silent> <leader>t :FZF<cr>
endif

nmap <silent> <leader>s :GFiles?<cr>
nmap <silent> <leader>r :Buffers<cr>
nmap <silent> <leader>e :FZF<cr>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

 " Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)
imap <c-l> <plug>(fzf-maps-i)

" Fzf search keymaps
nnoremap <silent> <Leader>C :call fzf#run({
  \ 'source':
  \   map(split(globpath(&rtp, "colors/*.vim"), "\n"),
  \     "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
  \ 'sink':    'colo',
  \ 'options': '+m',
  \ 'left':    30
\ })<CR>

command! -bang -nargs=* Find call fzf#vim#grep(
  \ 'rg --column --line-number --no-heading --follow --color=always '.<q-args>, 1,
  \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
command! -bang -nargs=? -complete=dir GitFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)

noremap <space> :set hlsearch! hlsearch?<cr>

nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>phw :h <C-R>=expand("<cword>")<CR><CR>

"""""""""""""""""""""
" Source Control
"""""""""""""""""""""
nmap <leader>ge :Gedit<cr>
nmap <silent><leader>gr :Gread<cr>
nmap <silent><leader>gb :Gblame<cr>
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

" Lazy Git stuff
nnoremap <silent> <Leader>lg :call ToggleLazyGit()<CR>

"""""""""""""""""""""
" Working with Code
"""""""""""""""""""""
" Move Lines Up/Down
nnoremap <C-j> :move+1<CR>
nnoremap <C-k> :move-2<CR>

" Change the number lines fo scroll down"
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$

vmap < <gv
vmap > >gv

nmap <leader>w :A<cr>
nmap <silent> <C-l> <Plug>(jsdoc)

"""""""""""""""""""""
" General Stuff
"""""""""""""""""""""
