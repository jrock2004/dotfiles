call plug#begin('~/.nvim/plugged')

" colorschemes
Plug 'flazz/vim-colorschemes'

" utilities
Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim' " fuzzy file finder and so much more
Plug 'mileszs/ack.vim'
Plug 'jiangmiao/auto-pairs'
" Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'benekastah/neomake'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'garbas/vim-snipmate
Plug 'editorconfig/editorconfig-vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'sotte/presenting.vim', { 'for': 'markdown' }
Plug 'ervandew/supertab'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'tpope/vim-sleuth'
Plug 'sickill/vim-pasta'
Plug 'marijnh/tern_for_vim'
Plug 'Valloric/YouCompleteMe'

" html / templates
Plug 'mattn/emmet-vim', { 'for': 'html' }
Plug 'gregsexton/MatchTag', { 'for': 'html' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'mustache/vim-mustache-handlebars'
Plug 'digitaltoad/vim-jade', { 'for': 'jade' }

" JavaScript
Plug 'gavocanov/vim-js-indent', { 'for': 'javascript' }
Plug 'moll/vim-node', { 'for': 'javascript' }
Plug 'othree/yajs.vim', { 'for': 'javascript' }
Plug 'othree/es.next.syntax.vim', { 'for': 'javascript' }

" TypeScript
Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }

" Styles
Plug 'wavded/vim-stylus', { 'for': ['stylus', 'markdown'] }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'ap/vim-css-color', { 'for': ['css','stylus','scss'] }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }

" Markdown
Plug 'tpope/vim-markdown', { 'for': 'markdown' }

" Ember
Plug 'alexlafroscia/vim-ember-cli'

" General
Plug 'elzr/vim-json', { 'for': 'json' }

call plug#end()
