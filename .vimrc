" Before using install vundle


" <vundle>

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" <plugins>

" Vundle
Plugin 'VundleVim/Vundle.vim' " required

" Emmet
Plugin 'mattn/emmet-vim'

" Auto pairs
Plugin 'jiangmiao/auto-pairs'

" Vim Polyglot
Plugin 'sheerun/vim-polyglot'

" Syntastic
Plugin 'scrooloose/syntastic'

" Python Jedi Completion
Plugin 'davidhalter/jedi-vim'

" vCoolor
Plugin 'KabbAmine/vCoolor.vim'

" Surround
Plugin 'tpope/vim-surround'

" CloseTag
Plugin 'alvan/vim-closetag'

" Vim Css Color
Plugin 'ap/vim-css-color'

" Darcula from github.com/isobit/vim-darcula-colors
Bundle 'isobit/vim-darcula-colors'

" </plugins>
call vundle#end()            " required
filetype plugin indent on    " required

" </vundle>

" Usual
set mouse=a
set autoindent
syntax on
set number
set encoding=utf-8
map <F5> :!clear; sudo python3 %<CR>
map <F2> :w !sudo tee % > /dev/null<CR> 

" Emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Netrw
let g:netrw_banner = 0
let g:netrw_browse_split = 2
let g:netrw_winsize = 20
let g:netrw_liststyle=3

" Jedi-Vim
let g:pymode_rope = 0

" CloseTag
let g:closetag_filetypes = 'html,xhtml,xml,jsp'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'
