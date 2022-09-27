return require('packer').startup(function()
  -- # Packer can manage itself
  use { 
    'wbthomason/packer.nvim', 
    cmd = { 'PackerCompile', 'PackerInstall', 'PackerUpdate', 'PackerClean', 'PackerSync', 'PackerLoad' } 
  }

  -- # IDE Experience
  use { 
    'williamboman/nvim-lsp-installer', 
    event = "BufWinEnter", 
    config = get_config("lsp-install") 
  }
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = get_config("lua-tree")
  }
  -- Install texlab using paru
  -- not nvim-lsp-installer 
  use { 
    'neovim/nvim-lspconfig', 
    config = get_config("lsp") 
  }
  use { 
    'nvim-treesitter/nvim-treesitter', 
    run = ':TSUpdate', 
    --event = "BufWinEnter",
    config = get_config("treesitter") 
  }
  use { 
    'nvim-treesitter/playground', 
    after = "nvim-treesitter" 
  }
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use { 
    'hrsh7th/nvim-cmp', 
    config = get_config("cmp-no-cmdline") 
  }
  use { 
    'nvim-telescope/telescope.nvim', 
    requires = { {'nvim-lua/plenary.nvim'} },
    cmd = "Telescope",
    config = get_config("telescope")
  }
  use { 
    'fhill2/telescope-ultisnips.nvim',
    after = "telescope.nvim",
    config = get_config("telescope-ultisnips")
  }
  use {
    'nvim-telescope/telescope-file-browser.nvim',
    after = "telescope.nvim",
    config = get_config("telescope-file-browser-config")
  }
  use 'mbbill/undotree'
  use 'jeffkreeftmeijer/vim-numbertoggle'
  use 'preservim/nerdcommenter'
  use 'puremourning/vimspector'
  use { 
    'SirVer/ultisnips',
    requires = "honza/vim-snippets", 
    config = get_config("ultisnips") 
  }
  use { 
    'lervag/vimtex', 
    config = get_config("vimtex") 
  }
  use 'mhinz/neovim-remote'
  use 'tpope/vim-fugitive'
  use 'skywind3000/asyncrun.vim'
  use { 
    'folke/which-key.nvim', 
    event = "BufWinEnter", 
    config = get_config("which-key") 
  }
  use { 
    'gelguy/wilder.nvim', 
    run = ':UpdateRemotePlugins', 
    event = "BufWinEnter",
    config = get_config("wilder") 
  }
  use 'MattesGroeger/vim-bookmarks'
  use 'voldikss/vim-mma'

  -- # Neovim apps 
  use 'iamcco/markdown-preview.nvim'
  use 'rhysd/vim-grammarous'
  use 'sotte/presenting.vim'
  use {
    'nvim-orgmode/orgmode', 
    config = get_config("orgmode-config")
  }
  use {
    'akinsho/org-bullets.nvim', 
    config = get_config("org-bullets-config")
  }

  -- # Themes
  use 'chriskempson/base16-vim'
  use 'sainnhe/gruvbox-material'
  use { 
    'folke/tokyonight.nvim', 
    branch = 'main' 
  }
  use 'shaunsingh/nord.nvim'
  use 'b4skyx/serenade'
  use 'dracula/vim' 

  -- # Ricing
  use 'mhinz/vim-startify'
  use { 
    'nvim-lualine/lualine.nvim', 
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }, 
    event = "BufWinEnter",
    config = get_config("lualine") 
  }
  use 'ryanoasis/vim-devicons'

  -- # Syntax
  use {
    'bohlender/vim-smt2', 
    config = get_config("smt2") 
  }
  use 'plasticboy/vim-markdown'
  use 'coreysharris/Macaulay2.vim'
end)
