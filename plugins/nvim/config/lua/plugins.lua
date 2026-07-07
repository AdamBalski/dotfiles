-- Ensure packer is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]] return true
  end
  return false
end
local packer_bootstrap = ensure_packer()

-- Plugins
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  -- lsp
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'

  -- completion
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-calc'
  use 'micangl/cmp-vimtex'
  use 'lervag/vimtex'

  -- snippets
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'

  -- others
  use 'doums/darcula'
  use 'itchyny/lightline.vim'
  use 'preservim/nerdtree'
  use 'Xuyuanp/nerdtree-git-plugin'
  use 'junegunn/goyo.vim'
  use 'nvim-tree/nvim-web-devicons'
  use 'wellle/context.vim'

  --  telescope
  -- do :TSUpdate
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'adimit/prolog.vim'
  use 'sharkdp/fd'
  use 'mbbill/undotree'

  -- breadcrumbs
  use({
    "utilyre/barbecue.nvim",
    tag = "*",
    requires = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
      require("barbecue").setup()
    end,
  })
end)
