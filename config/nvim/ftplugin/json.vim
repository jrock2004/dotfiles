let g:neomake_json_jsonlint_maker = {
    \ 'args': ['--compact'],
    \ 'errorformat':
        \ '%ELine %l:%c,'.
        \ '%Z\\s%#Reason: %m,'.
        \ '%C%.%#,'.
        \ '%f: line %l\, col %c\, %m,'.
        \ '%-G%.%#'
\ }

let g:neomake_json_enabled_markers = ['jsonlint']