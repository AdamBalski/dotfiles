"  _         _  _              _            
" (_)       (_)| |            (_)           
"  _  _ __   _ | |_    __   __ _  _ __ ___  
" | || '_ \ | || __|   \ \ / /| || '_ ` _ \ 
" | || | | || || |_  _  \ V / | || | | | | |
" |_||_| |_||_| \__|(_)  \_/  |_||_| |_| |_|                                         

" Before using install vim-plug

" <vim-plug>
call plug#begin()
" <plugins>

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

" </plugins>
call plug#end()
" </vim-plug>

""" General
set mouse=a
set termguicolors
set clipboard+=unnamedplus
set shiftwidth=4
set tabstop=4
set number relativenumber
set ignorecase " "\C" after search to make case sensitive
colorscheme darcula

""" Splits
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-H> <C-W>h
set splitbelow
set splitright


""" Keybindings
" F1 saves (you can save in read-only mode)
map <F2> :w !sudo tee % > /dev/null<CR> 
" F8 runs currently saved version of opened file in python3
map <F5> :!clear; sudo python3 %<CR>

""" Plugins' settings
" Emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css,scss EmmetInstall

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
source /home/adambalski/.config/nvim/init.coc.vim

" NerdTree
" Opens automatically when vim is opened on directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
" Opens on <C-d>
map <C-d> :NERDTreeToggle<CR>

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
