set termguicolors
colorscheme darkblue
set ts=4 sw=4
set bg=dark
set nu

set mouse=a


set breakindent
set linebreak
set breakindentopt=shift:4

func! DeleteTrailingWS()
  "exe "normal mz"
  %s/\s\+$//ge
  "exe "normal `z"
endfunc

let mapleader = " "

nnoremap <C-s> :up<cr>
nnoremap <silent> <BS> :nohl<cr>
nnoremap <silent> <S-Tab> :bp<cr>
nnoremap <silent> <Tab> :bn<cr>
nnoremap <silent> <Del> :bd<cr>
nnoremap <C-Space> :b<space>

nnoremap <Leader>gs :Gstatus<cr>
nnoremap <Leader>gd :Gdiff<cr>

nnoremap <silent> <C-h> :Neomake<cr>
nnoremap <silent> <C-Down> :lnext<cr>
nnoremap <silent> <C-Up> :lprev<cr>
nnoremap <silent> <C-Right> :lopen<cr>
nnoremap <silent> <C-Left> :lclose<cr>
nnoremap <silent> <cr> :ll<cr>

autocmd BufWrite *.c,*.cpp,*.h,*.H,*.js,*.py let w:winview = winsaveview() | :call DeleteTrailingWS()
autocmd BufWrite *.js :Neomake
autocmd BufWritePost *.c,*.cpp,*.h,*.H,*.js,*.py if exists('w:winview') | call winrestview(w:winview) | endif

execute pathogen#infect()
execute pathogen#helptags()

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_open_list = 1
