source ~/.config/nvim/plugins.vim

" Section General {{{

" Abbreviations
abbr funciton function
abbr teh the

set nocompatible
set autoread

set history=1000
set textwidth=120

set nobackup
set nowritebackup
set noswapfile

set rtp+=~/.fzf

let g:python_host_prog = '/usr/bin/python'
let g:python3_host_prog = '/usr/bin/python3'

if (has('nvim'))
	set inccommand=nosplit
endif

" }}}

" Section User Interface {{{

" switch cursor to line when in insert mode, and block when not
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

if &term =~ '256color'
	" disable background color erase
	set t_ut=
endif

" enable 24 bit color support if supported
if (has('mac') && empty($TMUX) && has("termguicolors"))
	set termguicolors
endif

" let g:onedark_termcolors=16
" let g:onedark_terminal_italics=1

syntax on

set t_Co=256
colorscheme codedark

highlight Comment cterm=italic
highlight htmlArg cterm=italic

highlight SpecialKey ctermbg=none ctermfg=8
highlight NonText ctermbg=none ctermfg=8

set number
set relativenumber

set wrap
set wrapmargin=8
set linebreak
set showbreak=…

set autoindent
set smartindent

set list
set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
set showbreak=↪

match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

set backspace=indent,eol,start

set noexpandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set completeopt+=longest,preview

set foldmethod=marker
set foldnestmax=10
set nofoldenable
set foldlevel=1

set clipboard=unnamedplus

set ttyfast
set diffopt+=filler,vertical
set laststatus=2
set so=7
set wildmenu
set hidden
set showcmd
set noshowmode
set wildmode=list:longest
set scrolloff=3
set shell=$SHELL
set cmdheight=1
set title

set ignorecase
set smartcase
set hlsearch
set incsearch
set nolazyredraw

set magic

" Disable bracket highlighting
let loaded_matchparen = 1

set showmatch
set mat=2

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" mouse
set mouse=

" switch cursor to line when in insert mode, and block when not
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Shift-tab on GNU screen
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

" 80 chars/line
set textwidth=0
if exists('&colorcolumn')
	set colorcolumn=80
endif

" Keep the cursor on the same column
set nostartofline

" }}}

" Section Mappings {{{

let mapleader = ','
set pastetoggle=<leader>v
noremap <space> :set hlsearch! hlsearch?<cr>
nmap <leader>[ <<
nmap <leader>] >>

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

nnoremap <silent> j gj
nnoremap <silent> k gk
nnoremap <silent> ^ g^
nnoremap <silent> $ g$

nmap \t :set ts=4 sts=4 sw=4 noet<cr>
nmap \s :set ts=4 sts=4 sw=4 et<cr>

" disable Ex mode
noremap Q <NOP>

" shortcut to save
nmap <leader>, :w<cr>

" Generate/update ctags
command! MakeTags !ctags -R .

" }}}

" Section AutoGroups {{{

augroup configgroup
	autocmd!

	autocmd VimResized * exe 'normal! \<c-w>='
	autocmd VimResized * :wincmd =
	autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %
	autocmd BufWritePost .vimrc.local source %
	autocmd FocusLost * silent! wa

	autocmd FileType qf wincmd J

	autocmd BufNewFile,BufReadPost *.md set filetype=markdown
	autocmd BufNewFile,BufReadPost *.rst set filetype=markdown
	let g:markdown_fenced_languages = ['css', 'javascript', 'js=javascript', 'json=javascript', 'stylus', 'html']

	autocmd BufNewFile,BufRead,BufWrite *.md syntax match Comment /\%^---\_.\{-}---$/

	autocmd! BufWritePost * Neomake
augroup END

au BufRead,BufNewFile *.cshtml set filetype=cshtml

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
else
	nmap <silent> <leader>t :FZF<cr>
endif

nmap <silent> <leader>r :Buffers<cr>
nmap <silent> <leader>e :FZF<cr>
nmap <silent> <leader>w :Files<cr>
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

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

" Fugitive Shortcuts
"""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>gs :Gstatus<cr>
nmap <leader>ge :Gedit<cr>
nmap <silent><leader>gr :Gread<cr>
nmap <silent><leader>gb :Gblame<cr>

nmap <leader>m :MarkedOpen!<cr>
nmap <leader>mq :MarkedQuit<cr>
nmap <leader>* *<c-o>:%s///gn<cr>

" airline options
"""""""""""""""""""""""""""""""""""""
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='codedark'
let g:airline#extensions#tabline#enabled = 1 " enable airline tabline
let g:airline#extensions#tabline#tab_min_count = 2 " only show tabline if tabs are being used (more than 1 tab open)
let g:airline#extensions#tabline#show_buffers = 0 " do not show open buffers in tabline
let g:airline#extensions#tabline#show_splits = 0

" don't hide quotes in json files
let g:vim_json_syntax_conceal = 0

" YouCompleteMe
"""""""""""""""""""""""""""""""""""""
let g:ycm_path_to_python_interpreter = '/usr/bin/python3'

" Emmet
"""""""""""""""""""""""""""""""""""""
let g:user_emmet_mode='a'

" UltiSnips
"""""""""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger="<c-s>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

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

" Split-term.vim
"""""""""""""""""""""""""""""""""""""
set splitright
set splitbelow

" Limelight.vim
"""""""""""""""""""""""""""""""""""""
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_paragraph_span = 1
let g:limelight_priority = 1

" }}}

" Section Keymaps {{{

" Stop using the arrow keys
"""""""""""""""""""""""""""""""""""""
nnoremap <up> :echo "Stop being stupid"<cr>
nnoremap <down> :echo "Stop being stupid"<cr>
nnoremap <left> :echo "Stop being stupid"<cr>
nnoremap <right> :echo "Stop being stupid"<cr>

" YouCompleteMe
"""""""""""""""""""""""""""""""""""""
nnoremap <leader>f :YcmCompleter GoToDefinition<CR>

" Easier resizing
"""""""""""""""""""""""""""""""""""""
" Set my splits up
nnoremap <leader>. :belowright 5split<cr>:terminal<cr><c-\><c-n>:aboveleft vsplit<cr>:terminal<cr><c-\><c-n><c-w>k


" Moving Around
"""""""""""""""""""""""""""""""""""""
tnoremap <c-[> <c-\><c-n>

" }}}

let g:neomake_logfile = '/tmp/neomake.log'

" vim:foldmethod=marker:foldlevel=0
