"  _         _  _              _            
" (_)       (_)| |            (_)           
"  _  _ __   _ | |_    __   __ _  _ __ ___  
" | || '_ \ | || __|   \ \ / /| || '_ ` _ \ 
" | || | | || || |_  _  \ V / | || | | | | |
" |_||_| |_||_| \__|(_)  \_/  |_||_| |_| |_| 

" Before using install vim-plug

" <vim-plug>
call plug#begin('~/.config/nvim')
" <plugins>

" moll/vim-bbye/
Plug 'moll/vim-bbye/'

" tpope/vim-fugitive
Plug 'tpope/vim-fugitive'

" lambdalisue/suda.vim
Plug 'lambdalisue/suda.vim'

" ctrlpvim/ctrlp.vim
Plug 'ctrlpvim/ctrlp.vim'

" Vimtex
Plug 'lervag/vimtex'

" vim-css-color
Plug 'ap/vim-css-color'

" Emmet
Plug 'mattn/emmet-vim'

" vCoolor
Plug 'KabbAmine/vCoolor.vim'

" Surround
Plug 'tpope/vim-surround'

" CloseTag
Plug 'alvan/vim-closetag'

" Auto-pairs
Plug 'jiangmiao/auto-pairs'

" Darcula
Plug 'doums/darcula'

" Incsearch
Plug 'haya14busa/incsearch.vim'

" Lightline
Plug 'itchyny/lightline.vim'

" Yet Another TypeScript Syntax
Plug 'HerringtonDarkholme/yats.vim'

" Conquer of completion
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" NerdTree
Plug 'preservim/nerdtree'

" NerdTree Git Plugin
Plug 'Xuyuanp/nerdtree-git-plugin'

" Nerd Commenter
Plug 'preservim/nerdcommenter'

" Goyo
Plug 'junegunn/goyo.vim'

" HardTime
Plug 'takac/vim-hardtime'

" ryanoasis/devicons
Plug 'ryanoasis/vim-devicons' 

" </plugins>
call plug#end()
" </vim-plug>

""" General
set mouse=a
set termguicolors
set linebreak
set clipboard+=unnamedplus
set shiftwidth=4
set tabstop=4
set expandtab
set number relativenumber
set ignorecase " "\C" after search to make it case sensitive
set nobackup
set writebackup
set undodir=~/.local/share/nvim/undodir
set undofile
set scrolloff=8
set colorcolumn=100
set guifont=JetBrains\ Mono\ Medium\ Nerd\ Font\ Complete\ Mono\ 2137
colorscheme darcula

""" Automatically sources init.vim after saving
autocmd BufWritePost init.vim :so %

""" Saves views (folds)
autocmd BufWinLeave * mkview
autocmd BufWinEnter * silent! call LoadView()
function LoadView()
	loadview
	normal gg
	normal 0
endfun

""" Splits
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
set splitbelow
set splitright


""" Keybindings
" F1 saves (you can save in read-only mode)
map <F1> :SudaWrite %<CR>
" F5 runs currently saved version of opened file in python3
map <F5> :!python3 %<CR>
" Go to left tab
nmap <A-h> :tabprevious<CR>
imap <A-h> <ESC>:tabprevious<CR>
" Go to right tab
nmap <A-l> :tabnext<CR>
imap <A-l> <ESC>:tabnext<CR>


""" Plugins' settings
" Vimtex
let g:tex_flavor= 'latex'
autocmd BufWritePost *.tex :!pdftex %
autocmd BufWritePost *.latex !pdflatex % ; rm %:r.aux %:r.log

" Bbye
nmap <C-w> :Bdelete<CR>

" Emmet
let g:user_emmet_install_global = 1

" CloseTag
let g:closetag_filetypes = 'html,xml'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ }
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" vCoolor
let g:vcoolor_map = '<F3>'

" incsearch.vim
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR> " Unsets hlsearch after searching

" Lightline
let g:lightline = { 'colorscheme': 'materia' }
set noshowmode " Disabled showing mode by nvim

" Conquer of Completion
source /home/adam/.config/nvim/init.coc.vim

" NerdTree
" Opens on <C-s>
map <C-s> :NERDTreeToggle<CR>
" Show line numbers
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber
" " Opens automatically when vim is opened on directory
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Nerd Commenter
filetype plugin on
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
nmap <C-_> <Plug>NERDCommenterToggle
vmap <C-_> <Plug>NERDCommenterToggle<CR>gv

" Goyo
map <F10> :Goyo<CR>
let g:goyo_width="80%"
let g:goyo_height="100%"

" HardTime
set mouse=r
let g:list_of_normal_keys = ["<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:list_of_insert_keys = []
let g:list_of_visual_keys = ["+","-","<UP>", "<DOWN>", "<LEFT>", "<RIGHT>"]
let g:hardtime_default_on = 1
let g:hardtime_timeout = 100000
