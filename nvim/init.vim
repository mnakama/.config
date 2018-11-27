set termguicolors
colorscheme darkblue
set ts=4 sw=4
set bg=dark
set nu

set mouse=a

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
