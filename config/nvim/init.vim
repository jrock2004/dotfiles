call functions#PlugLoad()
call plug#begin('~/.config/nvim/plugged')

" General {{{
  set autoread
  set history=1000
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
  set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

  if (has('nvim'))
    set inccommand=nosplit
  endif

  set backspace=indent,eol,start
  set clipboard^=unnamedplus,unnamed

  if has('mouse')
    set mouse=a
  endif

  set ignorecase
  set smartcase
  set hlsearch
  set incsearch
  set nolazyredraw

  set magic

  set noerrorbells
  set visualbell
  set t_vb=
  set tm=500
  set encoding=utf-8

  scriptencoding utf-8
" }}}

" Appearance {{{
  set number
  set relativenumber
  set wrap
  set wrapmargin=8
  set linebreak
  set showbreak=…
  set signcolumn=auto
  set autoindent
  set ttyfast
  set diffopt+=vertical,iwhite,internal,algorithm:patience,hiddenoff
  set laststatus=2
  set so=7
  set wildmenu
  set hidden
  set showcmd
  set noshowmode
  set wildmode=list:longest
  set shell=$SHELL
  set cmdheight=1
  set title
  set showmatch
  set mat=2
  set colorcolumn=80
  set updatetime=300
  set signcolumn=yes
  set shortmess+=c

  set smarttab
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
  set shiftround

  set foldmethod=syntax
  set foldlevelstart=99
  set foldnestmax=10
  set nofoldenable
  set foldlevel=1

  set list
  set listchars=tab:→\ ,eol:¬,trail:⋅,extends:❯,precedes:❮
  set showbreak=↪

  set t_Co=256
  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
        \,sm:block-blinkwait175-blinkoff150-blinkon175

  if &term =~ '256color'
    set t_ut=
  endif

  if (has("termguicolors"))
    if (!(has("nvim")))
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif

    set termguicolors
  endif

  match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

  Plug 'morhetz/gruvbox'
  Plug 'arcticicestudio/nord-vim'
  Plug 'joshdick/onedark.vim'
  Plug 'Rigellute/shades-of-purple.vim'
  Plug 'chriskempson/base16-vim'

  " LightLine {{{
    Plug 'itchyny/lightline.vim'
    Plug 'mike-hearn/base16-vim-lightline'

    let g:lightline = {
          \ 'colorscheme': 'base16_default_dark',
          \ 'active': {
          \   'left': [ [ 'mode', 'paste' ],
          \           [ 'gitbranch' ],
          \           [ 'readonly', 'filetype', 'filename' ]],
          \   'right': [ [ 'percent' ], [ 'lineinfo' ],
          \            [ 'fileformat', 'fileencoding' ],
          \            [ 'gitblame',
          \              'currentfunction',
          \              'cocstatus',
          \              'linter_errors',
          \              'linter_warnings' 
          \            ]]
          \ },
          \ 'component_expand': {
          \ },
          \ 'component_type': {
          \   'readonly': 'error',
          \   'linter_warnings': 'warning',
          \   'linter_errors': 'error'
          \ },
          \ 'component_function': {
          \   'fileencoding': 'LightlineFileEncoding',
          \   'filename': 'LightlineFileName',
          \   'fileformat': 'LightlineFileFormat',
          \   'filetype': 'LightlineFileType',
          \   'gitbranch': 'LightlineGitBranch',
          \   'cocstatus': 'coc#status',
          \   'currentfunction': 'CoCCurrentFunction',
          \   'gitblame': 'CocGitBlame'
          \ },
          \ 'tabline': {
          \   'left': [ [ 'tabs' ] ],
          \   'right': [ [ 'close' ] ]
          \ },
          \ 'tab': {
          \   'active': [ 'filename', 'modified' ],
          \   'inactive': [ 'filename', 'modified' ],
          \ },
          \ 'separator': { 'left': '', 'right': '' },
          \ 'subseparator': { 'left': '', 'right': '' }
          \ }

    function! LightlineFileName() abort
      let filename = winwidth(0) > 70 ? expand('%') : expand('%:t')
      if filename =~ 'NERD_tree'
        return ''
      endif
      let modified = &modified ? ' +' : ''
      return fnamemodify(filename, ":~:.") . modified
    endfunction

    function! LightlineFileEncoding()
      " only show the file encoding if it's not 'utf-8'
      return &fileencoding == 'utf-8' ? '' : &fileencoding
    endfunction

    function! LightlineFileFormat()
      " only show the file format if it's not 'unix'
      let format = &fileformat == 'unix' ? '' : &fileformat
      return winwidth(0) > 70 ? format . ' ' . WebDevIconsGetFileFormatSymbol() : ''
    endfunction

    function! LightlineFileType()
      return WebDevIconsGetFileTypeSymbol()
    endfunction

    function! LightlineGitBranch()
      return "\uE725" . (exists('*fugitive#head') ? fugitive#head() : '')
    endfunction

    function! LightlineUpdate()
      if g:goyo_entered == 0
        " do not update lightline if in Goyo mode
        call lightline#update()
      endif
    endfunction

    function! CoCCurrentFunction()
      return get(b:, 'coc_current_function', '')
    endfunction

    function! CocGitBlame()
      return winwidth(0) > 70 ? get(b:, 'coc_git_blame', '') : ''
    endfunction
  " }}}

" }}}

" General Mappings {{{
  let mapleader = ','

  nmap <leader>, :w<cr>
  set pastetoggle=<leader>v
  noremap <space> :set hlsearch! hlsearch?<cr>
  nnoremap <C-e> 3<C-e>
  nnoremap <C-y> 3<C-y>
  nnoremap <silent> j gj
  nnoremap <silent> k gk
  nnoremap <silent> ^ g^
  nnoremap <silent> $ g$

  vmap < <gv
  vmap > >gv
" }}}

" AutoGroups {{{
  " file type specific settings
  augroup configgroup
    autocmd!

    " automatically resize panes on resize
    autocmd VimResized * exe 'normal! \<c-w>='
    autocmd BufWritePost .vimrc,.vimrc.local,init.vim source %
    autocmd BufWritePost .vimrc.local source %
    " save all files on focus lost, ignoring warnings about untitled buffers
    autocmd FocusLost * silent! wa

    " make quickfix windows take all the lower section of the screen
    " when there are multiple windows open
    autocmd FileType qf wincmd J
    autocmd FileType qf nmap <buffer> q :q<cr>
  augroup END
" }}}

" General Functionality {{{
  " Plug 'wincent/ferret'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-surround'
  Plug 'benmills/vimux'
  Plug 'tpope/vim-repeat'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'vim-scripts/PreserveNoEOL'

  let g:PreserveNoEOL = 1
  Plug 'tpope/vim-vinegar'

  " Make starting vim better {{{
  Plug 'mhinz/vim-startify'

  " Don't change to directory when selecting a file
  let g:startify_files_number = 5
  let g:startify_change_to_dir = 0
  let g:startify_custom_header = [ ]
  let g:startify_relative_path = 1
  let g:startify_use_env = 1

  function! s:list_commits()
    let git = 'git -C ' . getcwd()
    let commits = systemlist(git . ' log --oneline | head -n5')
    let git = 'G' . git[1:]

    return map(commits, '{"line": matchstr(v:val, "\\s\\zs.*"), "cmd": "'. git .' show ". matchstr(v:val, "^\\x\\+") }')
  endfunction

  " Custom startup list, only show MRU from current directory/project
  let g:startify_lists = [
        \  { 'type': 'dir', 'header': [ 'Files '. getcwd() ] },
        \  { 'type': function('s:list_commits'), 'header': [ 'Recent Commits' ] },
        \  { 'type': 'sessions',  'header': [ 'Sessions' ]		 },
        \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]		 },
        \  { 'type': 'commands',  'header': [ 'Commands' ]		 },
        \ ]

  let g:startify_commands = [
        \ { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
        \ { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
        \ ]

  let g:startify_bookmarks = [
        \ { 'c': '~/.dotfiles/config/nvim/init.vim' },
        \ { 'z': '~/.dotfiles/zsh/zshrc.symlink' }
        \ ]

  autocmd User Startified setlocal cursorline
  nmap <leader>st :Startify<cr>
" }}}

Plug 'sickill/vim-pasta'
Plug 'ryanoasis/vim-devicons'

" FZF {{{
  Plug '/usr/local/opt/fzf'
  Plug 'junegunn/fzf.vim'
  let g:fzf_layout = { 'down': '~25%' }

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

  nnoremap <silent> <Leader>C :call fzf#run({
        \ 'source':
        \   map(split(globpath(&rtp, "colors/*.vim"), "\n"),
        \     "substitute(fnamemodify(v:val, ':t'), '\\..\\{-}$', '', '')"),
        \ 'sink':    'colo',
        \ 'options': '+m',
        \ 'left':    30
        \ })<CR>

  command! FZFMru call fzf#run({
        \  'source':  v:oldfiles,
        \  'sink':    'e',
        \  'options': '-m -x +s',
        \  'down':    '40%'})

  command! -bang -nargs=* Find call fzf#vim#grep(
        \ 'rg --column --line-number --no-heading --follow --color=always '.<q-args>, 1,
        \ <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'), <bang>0)
  command! -bang -nargs=? -complete=dir Files
        \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
  command! -bang -nargs=? -complete=dir GitFiles
        \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview('right:50%', '?'), <bang>0)
" }}}

" vim-fugitive {{{
  Plug 'tpope/vim-fugitive'
  nmap <silent> <leader>gs :Gstatus<cr>
  nmap <leader>ge :Gedit<cr>
  nmap <silent><leader>gr :Gread<cr>
  nmap <silent><leader>gb :Gblame<cr>

  Plug 'tpope/vim-rhubarb' " hub extension for fugitive
  Plug 'junegunn/gv.vim'
  Plug 'sodapopcan/vim-twiggy'
" }}}

" UltiSnips {{{
  Plug 'SirVer/ultisnips' " Snippets plugin
  Plug 'honza/vim-snippets'
  Plug 'jrock2004/react-snippets'

  " let g:UltiSnipsExpandTrigger="<tab>"
" }}}

" coc {{{ "
  Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " coc-prettier
  command! -nargs=0 Prettier :CocCommand prettier.formatFile
  nmap <leader>f :CocCommand prettier.formatFile<cr>

  " coc-git
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  nmap gs <Plug>(coc-git-chunkinfo)
  nmap gu :CocCommand git.chunkUndo<cr>

  "remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> gh <Plug>(coc-doHover)

  " diagnostics navigation
  nmap <silent> [c <Plug>(coc-diagnostic-prev)
  nmap <silent> ]c <Plug>(coc-diagnostic-next)

  let g:coc_global_extensions = [
        \ 'coc-css',
        \ 'coc-docker',
        \ 'coc-ember',
        \ 'coc-emoji',
        \ 'coc-emmet',
        \ 'coc-eslint',
        \ 'coc-git',
        \ 'coc-highlight',
        \ 'coc-html',
        \ 'coc-json',
        \ 'coc-pairs',
        \ 'coc-prettier',
        \ 'coc-sh',
        \ 'coc-snippets',
        \ 'coc-tailwindcss',
        \ 'coc-tsserver',
        \ 'coc-vimlsp',
        \ 'coc-yaml'
        \ ]

  " rename
  nmap <silent> <leader>rn <Plug>(coc-rename)

  " Remap for format selected region
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  " organize imports
  command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

  " Use K to show documentation in preview window
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
          execute 'h '.expand('<cword>')
      else
          call CocAction('doHover')
      endif
  endfunction

  "tab completion
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  "" Close preview window when completion is done.
  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}

" Language-Specific Configuration {{{
  " html / templates {{{
    " emmet support for vim - easily create markdup wth CSS-like syntax
    Plug 'mattn/emmet-vim'

    " match tags in html, similar to paren support
    Plug 'gregsexton/MatchTag', { 'for': 'html' }

    " html5 support
    Plug 'othree/html5.vim', { 'for': 'html' }

    " mustache support
    Plug 'mustache/vim-mustache-handlebars'

    " pug / jade support
    Plug 'digitaltoad/vim-pug', { 'for': ['jade', 'pug'] }
  " }}}

  " JavaScript {{{
    Plug 'othree/yajs.vim', { 'for': [ 'javascript', 'javascript.jsx', 'html' ] }
    " Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'javascript.jsx', 'html'] }
    Plug 'moll/vim-node', { 'for': 'javascript' }
    Plug 'ternjs/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'], 'do': 'yarn install' }
    Plug 'MaxMEllon/vim-jsx-pretty'
    let g:vim_jsx_pretty_highlight_close_tag = 1
  " }}}

  " TypeScript {{{
    Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
    " Plug 'Shougo/vimproc.vim', { 'do': 'make' }
  " }}}

  " Styles {{{
    Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
    Plug 'groenewege/vim-less', { 'for': 'less' }
    Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
    Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
    Plug 'stephenway/postcss.vim', { 'for': 'css' }
  " }}}

  " markdown {{{
    Plug 'tpope/vim-markdown', { 'for': 'markdown' }
  " }}}

  " JSON {{{
    Plug 'elzr/vim-json', { 'for': 'json' }

    let g:vim_json_syntax_conceal = 0
  " }}}

  Plug 'fatih/vim-go', { 'for': 'go' }
  Plug 'ekalinin/Dockerfile.vim', { 'for': 'dockerfile' }
  Plug 'joukevandermaas/vim-ember-hbs', { 'for': 'html.handlebars' }
" }}}

call plug#end()

" Colorscheme and final setup {{{
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
else
  colorscheme base16-default-dark
endif
syntax on
filetype plugin indent on
" make the highlighting of tabs and other non-text less annoying
" highlight SpecialKey ctermfg=236
" highlight NonText ctermfg=236
highlight SpecialKey ctermfg=19 guifg=#333333
highlight NonText ctermfg=19 guifg=#333333

" make comments and HTML attributes italic
highlight Comment cterm=italic term=italic gui=italic
highlight htmlArg cterm=italic term=italic gui=italic
highlight xmlAttrib cterm=italic term=italic gui=italic
" highlight Type cterm=italic term=italic gui=italic
highlight Normal ctermbg=none
" }}}

" vim:foldmethod=marker foldlevel=0
