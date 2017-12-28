source ~/.config/nvim/plugins.vim

" Section General {{{

set history=1000
set nobackup
set nowritebackup
set noswapfile
set inccommand=nosplit
set clipboard^=unnamedplus,unnamed
set copyindent

" }}}

" Section Runtime {{{
set rtp+=~/.fzf
" }}}

" Section User Interface {{{

syntax on
colorscheme dracula

highlight Comment cterm=italic
highlight htmlArg cterm=italic
highlight SpecialKey ctermbg=none ctermfg=236
highlight NonText ctermbg=none ctermfg=236

set number
set relativenumber
set numberwidth=3
set showbreak=…
set smartindent

set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

set backspace=indent,eol,start
set noexpandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set shiftround
set completeopt+=longest,preview

set foldmethod=marker
set foldnestmax=10
set foldlevel=0

set diffopt+=filler,vertical
set so=7
set hidden
set wildmode=list:longest
set scrolloff=3
set title

set ignorecase
set smartcase
set nolazyredraw
set magic
set t_ut=
set showmatch

set noerrorbells
set visualbell
set tm=500
set mouse=

set textwidth=100
if exists('&colorcolumn')
  set colorcolumn=100
endif

set nostartofline

" }}}

" Section Mappings {{{

let mapleader = ','
set pastetoggle=<leader>v
noremap <space> :set hlsearch! hlsearch?<cr>
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$
noremap Q <NOP>
nmap <leader>, :w<cr>
command! MakeTags !ctags -R .
nnoremap <up> :echo "Stop being stupid"<cr>
nnoremap <down> :echo "Stop being stupid"<cr>
nnoremap <left> :echo "Stop being stupid"<cr>
nnoremap <right> :echo "Stop being stupid"<cr>


" }}}

" Section Plugins {{{

" FZF plugin
"""""""""""""""""""""""""""""""""""""
let g:fzf_layout = { 'down': '~25%' }
let g:fzf_files_options =
  \ '--preview "(highlight -O ansi {} || cat {}) 2> /dev/null | head -'.&lines.'"'
let g:fzf_buffers_jump = 1
let g:fzf_tags_command = 'ctags -R'

if isdirectory(".git")
  nmap <silent> <leader>t :GFiles<cr>
  nmap <silent> <leader>e :FZF<cr>
else
  nmap <silent> <leader>t :FZF<cr>
endif

nmap <silent> <leader>r :Buffers<cr>
nmap <silent> <leader>w :Files<cr>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

nnoremap <silent> <Leader>C :call fzf#run({
  \   'source':
  \     map(split(globpath(&rtp, "colors/*.vim"), "\n"),
  \         "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
  \   'sink':    'colo',
  \   'options': '+m',
  \   'left':    30
  \ })<CR>

command! FZFMru call fzf#run({
  \  'source':  v:oldfiles,
  \  'sink':    'e',
  \  'options': '-m -x +s',
  \  'down':    '40%'})

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)

command! -bang Colors
  \ call fzf#vim#colors({'left': '15%', 'options': '--reverse --margin 30%,0'}, <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
  \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir Buffers
  \ call fzf#vim#buffers(<q-args>, fzf#vim#with_preview(), <bang>0)

" Lightline plugin
"""""""""""""""""""""""""""""""""""""
let g:lightline = {
  \ 'colorscheme': 'Dracula'
\}
set laststatus=2
set noshowmode

" UltiSnips
"""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" YouCompleteMe
"""""""""""""""""""""""""""""""""""""
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'


" Committia.vim
"""""""""""""""""""""""""""""""""""""
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
	" Additional settings
	setlocal spell
	" If no commit message, start with insert mode
	if a:info.vcs ==# 'git' && getline(1) ==# ''
		startinsert
	end

	" Scroll the diff window from insert mode
	" Map <C-n> and <C-p>
	imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
	imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
	"
endfunction

" }}}

" vim:foldmethod=marker
