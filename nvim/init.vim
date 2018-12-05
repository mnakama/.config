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

nnoremap <C-s> :up<cr>

autocmd BufWrite *.c,*.cpp,*.h,*.H,*.js,*.py let w:winview = winsaveview() | :call DeleteTrailingWS()
autocmd BufWrite *.go :GoFmt
autocmd BufWritePost *.c,*.cpp,*.h,*.H,*.js,*.py if exists('w:winview') | call winrestview(w:winview) | endif

execute pathogen#infect()
execute pathogen#helptags()
