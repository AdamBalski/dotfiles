-- Compatibility for older plugins that still call the deprecated function.
if vim.islist then
  vim.tbl_islist = vim.islist
end

-- Plugins
require("plugins")

-- General settings
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
vim.o.splitbelow = true
vim.o.splitright = true
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':<C-u>nohlsearch<CR>', { noremap = true, silent = true })
vim.cmd([[colorscheme darcula]])
-- Sets the current working directory to be the directory where the currently edited file is
vim.cmd("command! CdCurrDir :cd %:p:h")

-- Autoread/write configs (e.g. for coding agents to interop nicely with the editor)
vim.opt.autowrite = true
vim.opt.autowriteall = true
local timer = vim.loop.new_timer()

timer:start(
  1000,   -- initial delay (ms)
  1000,   -- repeat interval (ms)
  vim.schedule_wrap(function()
    if vim.fn.mode() ~= "c" then
      vim.cmd("checktime")
    end
  end)
)

vim.api.nvim_create_autocmd(
  { "CursorHold", "CursorHoldI", "FocusGained", "BufEnter" },
  { command = "checktime" }
)

-- equivalent of: set updatetime=500
vim.opt.updatetime = 500

-- augroup AutoSave
local autosave = vim.api.nvim_create_augroup("AutoSave", { clear = true })

-- autocmd CursorHold,CursorHoldI * silent! wall
vim.api.nvim_create_autocmd(
  { "CursorHold", "CursorHoldI" },
  {
    group = autosave,
    callback = function()
      vim.cmd("silent! wall")
    end,
  }
)

-- Keybindings

-- Leader
vim.g.mapleader = " "
-- interpreting python3, haskell, etc.
vim.api.nvim_set_keymap('n', '<leader>py', ':!python3 %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>bpy', ':!python3 %&<CR><CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ipy', ':term python3 %<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fpy', ':!python3 % < ', { noremap = true, silent = false })
vim.api.nvim_set_keymap('n', '<leader>ifpy', ':term python3 % < ', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>hs', ':!runghc %<CR>', { noremap = true, silent = true })
-- Tabs
vim.api.nvim_set_keymap('n', '<A-h>', ':tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-h>', '<ESC>:tabprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-l>', ':tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-l>', '<ESC>:tabnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-t>', '<ESC>:tabnew<CR>', { noremap = true, silent = true })
-- Buffers
vim.api.nvim_set_keymap('n', '<A-k>', ':bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-k>', '<ESC>:bprevious<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<A-j>', ':bnext<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<A-j>', '<ESC>:bnext<CR>', { noremap = true, silent = true })
-- Splits
vim.api.nvim_set_keymap('n', '<C-J>', '<C-W>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-L>', '<C-W>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-H>', '<C-W>h', { noremap = true, silent = true })
-- Code actions
vim.api.nvim_set_keymap('n', '<leader>fix', ':lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>mv', ':lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>pe', ':lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
-- Deleting buffers
-- first, delete these mappings
-- n  <C-W><C-D>    <C-W>d
--                  Show diagnostics under the cursor
-- n  <C-W>d      * <Lua 16: vim/_defaults.lua:0>
--                  Show diagnostics under the cursor
vim.api.nvim_del_keymap('n', '<C-W><C-D>')
vim.api.nvim_del_keymap('n', '<C-W>d')
vim.keymap.set('n', '<C-w>', ':bp | bd #<CR>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-w>', '<ESC>:bp | bd #<CR>', { noremap = true, silent = true })
-- Miscellanous
vim.api.nvim_set_keymap('n', '<leader>wsudo', ':SudaWrite %<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
vim.keymap.set('', '<leader>g', ':Goyo<CR>')
vim.api.nvim_set_keymap('n', '<leader>cd', ':CdCurrDir<CR>', { noremap = true, silent = true})

-- Plugins' settings

-- Lightline
vim.g.lightline = { colorscheme = 'materia' }
vim.o.showmode = false

-- NerdTree
vim.api.nvim_set_keymap('n', '<C-s>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-s>', '<ESC>:NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.g.NERDTreeShowLineNumbers = 1
vim.cmd("autocmd FileType nerdtree setlocal relativenumber")

-- Telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', telescope_builtin.find_files, {})
vim.keymap.set('n', '<leader>tb', telescope_builtin.buffers, {})
vim.keymap.set('n', '<leader>tgs', telescope_builtin.git_status, {})
require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { 
      "node_modules" 
    },
    mappings = {
        i = {
            ["<ESC>"] = require("telescope.actions").close
        }
    }
  }
}

-- Latex
vim.g.tex_flavor = 'latex'
vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg'
-- vim.api.nvim_create_autocmd("BufWritePost", {
--     pattern = "*.tex",
--     command = "!pdftex %",
-- })
vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.tex",
    command = "!pdflatex % ; rm -f %:r.aux %:r.log",
})

-- LSP, Completion, etc.
-- mason.nvim
require("mason").setup()
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('gopls', {
  capabilities = capabilities,
})
vim.lsp.enable('gopls')

vim.lsp.config('pyright', {
  capabilities = capabilities,
})
vim.lsp.enable('pyright')

vim.lsp.config('bashls', {
  capabilities = capabilities,
})
vim.lsp.enable('bashls')

-- nvim-cmp
-- helpers
local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources(
    { { name = 'luasnip' }, }, 
    { { name = 'nvim_lsp' }, },
    { { name = 'calc' }, },
    { { name = 'vimtex' }, }
  )
})
