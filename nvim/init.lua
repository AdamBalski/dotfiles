require("plugins")
require("plugins/plugin-configs")
require("general-options/remaps")

-- general
vim.opt.mouse = "a"
vim.opt.termguicolors = true
vim.opt.linebreak = true
vim.opt.clipboard = "unnamedplus"
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true -- "\C" after search to make it case sensitive
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.undofile = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "100"
vim.opt.guifont = "JetBrains Mono Medium Nerd Font Complete Mono 2137"
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':<C-u>nohlsearch<CR>', { noremap = true, silent = true })
vim.cmd([[colorscheme darcula]])

-- Sets the current working directory to be the directory where the currently edited file is
vim.cmd("command! CdCurrDir :cd %:p:h")
vim.api.nvim_set_keymap('n', '<leader>cd', ':CdCurrDir<CR>', { noremap = true, silent = true})

-- Splits
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h', { noremap = true, silent = true })
vim.o.splitbelow = true
vim.o.splitright = true

-- Keybindings
vim.api.nvim_set_keymap('n', '<F1>', ':SudaWrite %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F5>', ':!python3 %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F6>', ':!runghc %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-h>', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-h>', '<ESC>:tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-l>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<ESC>:tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-k>', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<ESC>:bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-j>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<ESC>:bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-t>', '<ESC>:tabnew<CR>', { noremap = true, silent = true })

-- Plugins' settings

-- Vimtex
vim.g.tex_flavor = 'latex'
vim.o.conceallevel = 1
vim.g.tex_conceal = 'abdmg'
vim.cmd("autocmd BufWritePost *.tex :!pdftex %")
vim.cmd("autocmd BufWritePost *.latex !pdflatex % ; rm %:r.aux %:r.log")

-- Bbye
vim.api.nvim_set_keymap('n', '<C-w>', ':Bdelete<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-w>', ':Bdelete<CR>', { noremap = true, silent = true })

-- Lightline
vim.g.lightline = { colorscheme = 'materia' }
vim.o.showmode = false

-- NerdTree
vim.api.nvim_set_keymap('n', '<C-s>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<ESC>:NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.g.NERDTreeShowLineNumbers = 1
vim.cmd("autocmd FileType nerdtree setlocal relativenumber")

-- todo nerdcommenter closetag emmet color-picker
