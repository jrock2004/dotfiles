function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction

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
  return winwidth(0) > 150 ? format . ' ' . WebDevIconsGetFileFormatSymbol() : ''
endfunction

function! LightlineFileType()
  return WebDevIconsGetFileTypeSymbol()
endfunction

function! LightlineGitBranch()
  return "\uE725 " . (exists('*fugitive#head') ? fugitive#head() : '')
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
  let blame = get(b:, 'coc_git_blame', '')
  let count = strchars(get(b:, 'coc_git_blame', ''))
  let parsed = count > 50 ? blame[0:50] : blame

  return winwidth(0) > 100 ? parsed : ''
endfunction
