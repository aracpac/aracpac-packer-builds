" source plugin files
so ~/.vim/plugins.vim
" configure powerline
let g:Powerline_symbols = 'fancy'
" configure gitgutter
let g:gitgutter_terminal_reports_focus=0
" always display status line
set laststatus=2
" idle time before updatetime triggers are fired
set updatetime=100
" show line numbers
set number
" use 4 spaces as tabs
set tabstop=4
set shiftwidth=4
set expandtab
" allow backspaces in insert mode
set backspace=indent,eol,start
" stylize code syntax
syntax on
" enable 256 colors
set t_Co=256
" set the background and theme
set background=dark
colorscheme PaperColor
" create an undofile
set undofile
set undodir=~/.vim/undodir
