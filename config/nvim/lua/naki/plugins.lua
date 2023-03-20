-- import packer safely
local status, packer = pcall(require, 'packer')
if not status then
  print("Packer is not installed")
  return
end

vim.cmd [[packadd packer.nvim]]

-- add list of plugins to install
return packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- packer can manage itself

  use 'nvim-lua/plenary.nvim'  -- lua functions that many plugins use

  -- theme
  use 'EdenEast/nightfox.nvim'         -- nightfox

  use 'christoomey/vim-tmux-navigator' -- tmux & split window navigation

  use 'szw/vim-maximizer'              -- maximizes and restores current window

  -- essential plugins
  use 'tpope/vim-surround'               -- add, delete, change surroundings (it's awesome)
  use 'inkarkat/vim-ReplaceWithRegister' -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  use 'numToStr/Comment.nvim'

  -- file explorer
  use 'nvim-tree/nvim-tree.lua'

  -- vs-code like icons
  use 'nvim-tree/nvim-web-devicons'

  -- statusline
  use 'nvim-lualine/lualine.nvim'

  -- fuzzy finding w/ telescope
  -- use({ 'nvim-telescope/telescope-fzf-native.nvim', run = "make" }) -- dependency for better sorting performance
  use 'nvim-telescope/telescope-file-browser.nvim'
  -- use({ 'nvim-telescope/telescope.nvim', branch = '0.1.x' }) -- fuzzy finder
  use 'nvim-telescope/telescope.nvim' -- fuzzy finder

  -- managing & installing lsp servers, linters & formatters
  use 'williamboman/mason.nvim'           -- in charge of managing lsp servers, linters & formatters
  use 'williamboman/mason-lspconfig.nvim' -- bridges gap b/w mason & lspconfig

  -- treesitter configuration
  use({
    'nvim-treesitter/nvim-treesitter',
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })

  -- auto closing
  use 'windwp/nvim-autopairs'                                  -- autoclose parens, brackets, quotes, etc...
  use({ 'windwp/nvim-ts-autotag', after = 'nvim-treesitter' }) -- autoclose tags

  -- git integration
  use 'lewis6991/gitsigns.nvim' -- show line modifications on left hand side

  -- LSP
  use 'neovim/nvim-lspconfig' -- configurations for Nvim LSP
  use 'onsails/lspkind-nvim'  -- vscode-like pictograms
  use 'L3MON4D3/LuaSnip'
  use({
    'glepnir/lspsaga.nvim', -- highly performant UI
    branch = 'main',
    require = {
      { 'nvim-tree/nvim-web-devicons' },
      { 'nvim-treesitter/nvim-treesitter' },
    },
  })
  use 'ray-x/lsp_signature.nvim' -- Show function signature when you type

  -- autocompletion
  use 'hrsh7th/cmp-buffer'   -- nvim-cmp source for buffer words
  use 'hrsh7th/cmp-nvim-lsp' -- nvim-cmp source for neovim's built-in LSP
  use 'hrsh7th/nvim-cmp'     -- completion

  -- enable code formatting
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'MunifTanjim/prettier.nvim'

  use 'folke/zen-mode.nvim'

  if packer_bootstrap then
    require('packer').sync()
  end
end)
