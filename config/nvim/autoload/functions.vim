" load vim-plug if it does not exist in the dotfiles
let s:plugpath = expand('<sfile>:p:h') . '/plug.vim' " this is relative to this file, which is in autoload
function! functions#PlugLoad()
  if !filereadable(s:plugpath)
    if executable('curl')
      echom "Installing vim-plug at " . s:plugpath
      let plugurl = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      call system('curl -fLo ' . shellescape(s:plugpath) . ' --create-dirs ' . plugurl)
      if v:shell_error
        echom "Error downloading vim-plug. Please install it manually.\n"
        exit
      endif
    else
      echom "vim-plug not installed. Please install it manually or install curl.\n"
      exit
    endif
  endif
endfunction

" When term starts, auto go into insert mode
autocmd TermOpen * startinsert

" Turn off line numbers etc
autocmd TermOpen * setlocal listchars= nonumber norelativenumber

" Creates a floating window with a most recent buffer to be used
function! CreateCenteredFloatingWindow()
  let width = float2nr(&columns * 0.6)
  let height = float2nr(&lines * 0.6)
  let top = ((&lines - height) / 2) - 1
  let left = (&columns - width) / 2
  let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

  let top = "╭" . repeat("─", width - 2) . "╮"
  let mid = "│" . repeat(" ", width - 2) . "│"
  let bot = "╰" . repeat("─", width - 2) . "╯"
  let lines = [top] + repeat([mid], height - 2) + [bot]
  let s:buf = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
  call nvim_open_win(s:buf, v:true, opts)
  set winhl=Normal:Floating
  let opts.row += 1
  let opts.height -= 2
  let opts.col += 2
  let opts.width -= 4
  call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

function! OpenTerm(cmd)
  call CreateCenteredFloatingWindow()
  call termopen(a:cmd, { 'on_exit': function('OnTermExit') })
endfunction

function! ToggleLazyGit()
  if empty(bufname('lazygit'))
    call OpenTerm('lazygit')
  else
    bd!
  endif
endfunction

function! OnTermExit(job_id, code, event) dict
  if a:code == 0
    bd!
  endif
endfunction

