return {
  -- # IDE Experience
  'wfxr/minimap.vim',
  { 
    'williamboman/nvim-lsp-installer', 
    event = "BufWinEnter", 
    config = function()
      require 'config.lsp-install'
    end
  },
  {
    'kyazdani42/nvim-tree.lua',
    dependencies = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require 'config.lua-tree'
    end
  },
  -- Install texlab using paru
  -- not nvim-lsp-installer 
  { 
    'neovim/nvim-lspconfig', 
    config = function()
      require 'config.lsp'
    end
  },
  { 
    'nvim-treesitter/nvim-treesitter', 
    run = ':TSUpdate', 
    --event = "BufWinEnter",
    config = function()
      require 'config.treesitter'
    end,
    dependencies = {
      'nvim-treesitter/playground', 
    }
  },
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'quangnguyen30192/cmp-nvim-ultisnips',
  { 
    'hrsh7th/nvim-cmp', 
    config =function()
      require 'config.cmp-no-cmdline'
    end
  },
  { 
    'nvim-telescope/telescope.nvim', 
    dependencies = { 
      'nvim-lua/plenary.nvim', 
      'LukasPietzschmann/telescope-tabs',
      'fhill2/telescope-ultisnips.nvim',
      'fhill2/telescope-ultisnips.nvim',
      'nvim-telescope/telescope-file-browser.nvim'
    },
    cmd = "Telescope",
    config = function()
      require 'config.telescope'
    end
  },
  {
    'LukasPietzschmann/telescope-tabs',
    dependencies = {
      'nvim-telescope/telescope.nvim', 
    },
    config = function()
      require 'config.conf-telescope-tabs'
    end
  },
  --{ 
    --'fhill2/telescope-ultisnips.nvim',
    --dependencies = {
      --'SirVer/ultisnips',
      --'nvim-telescope/telescope.nvim', 
    --},
    --config = function()
      --require 'config.telescope-ultisnips'
    --end
  --},
  {
    'nvim-telescope/telescope-file-browser.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim', 
    },
    config = function()
      require 'config.telescope-file-browser-config'
    end
  },
  'mbbill/undotree',
  'jeffkreeftmeijer/vim-numbertoggle',
  'preservim/nerdcommenter',
  'puremourning/vimspector',
  { 
    'SirVer/ultisnips',
    dependencies = {
      "honza/vim-snippets"
    },
    config = function()
      require 'config.ultisnips'
    end
  },
  { 
    'lervag/vimtex', 
    config = function()
      require 'config.vimtex'
    end
  },
  'mhinz/neovim-remote',
  'tpope/vim-fugitive',
  'skywind3000/asyncrun.vim',
  { 
    'folke/which-key.nvim', 
    event = "BufWinEnter", 
    config = function()
      require 'config.which-key'
    end
  },
  { 
    'gelguy/wilder.nvim', 
    run = ':UpdateRemotePlugins', 
    event = "BufWinEnter",
    config = function()
      require 'config.wilder'
    end
  },
  'MattesGroeger/vim-bookmarks',
  'voldikss/vim-mma',

  -- # Neovim apps 
  'iamcco/markdown-preview.nvim',
  'rhysd/vim-grammarous',
  'sotte/presenting.vim',
  {
    'nvim-orgmode/orgmode', 
    config = function()
      require 'config.orgmode-config'
    end
  },
  {
    'akinsho/org-bullets.nvim', 
    config = function()
      require 'config.org-bullets-config'
    end
  },

  -- # Themes
  'chriskempson/base16-vim',
  'sainnhe/gruvbox-material',
  { 
    'folke/tokyonight.nvim', 
    branch = 'main' 
  },
  'shaunsingh/nord.nvim',
  'b4skyx/serenade',
  'dracula/vim', 

  -- # Ricing
  'mhinz/vim-startify',
  { 
    'nvim-lualine/lualine.nvim', 
    dependencies = { 'kyazdani42/nvim-web-devicons', opt = true }, 
    event = "BufWinEnter",
    config = function()
      require 'config.lualine'
    end
  },
  'ryanoasis/vim-devicons',
  'eandrju/cellular-automaton.nvim', 

  -- # Syntax
  {
    'bohlender/vim-smt2', 
    config = function()
      require 'config.smt2'
    end
  },
  'plasticboy/vim-markdown',
  'coreysharris/Macaulay2.vim',
}

