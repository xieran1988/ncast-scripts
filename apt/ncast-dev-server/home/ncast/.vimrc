
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
set nu
filetype plugin indent on
set ts=2
set sw=2
set mouse=a

