return {
  -- # IDE Experience
  'wfxr/minimap.vim', 
  {
    'stevearc/overseer.nvim',
    opts = {
      config = function()
        require 'config.overseer'
      end
    },
  },
  {
    "folke/zen-mode.nvim",
    opts = {
      window = {
        backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
        -- height and width can be:
        -- * an absolute number of cells when > 1
        -- * a percentage of the width / height of the editor when <= 1
        -- * a function that returns the width or the height
        width = 120, -- width of the Zen window
        height = 1, -- height of the Zen window
        -- by default, no options are changed for the Zen window
        -- uncomment any of the options below, or add other vim.wo options you want to apply
        options = {
          -- signcolumn = "no", -- disable signcolumn
          -- number = false, -- disable number column
          -- relativenumber = false, -- disable relative numbers
          -- cursorline = false, -- disable cursorline
          -- cursorcolumn = false, -- disable cursor column
          -- foldcolumn = "0", -- disable fold column
          -- list = false, -- disable whitespace characters
        },
      },
    }
  },
  {
    "nanozuki/tabby.nvim",
    config = function()
      require 'config.tabby-config'
    end
  },
  {
    "gbprod/yanky.nvim",
    opts = {
      config = function()
        require 'config.yanky'
      end
    },
  },
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
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'quangnguyen30192/cmp-nvim-ultisnips',
    },
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

  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require 'config.oil'
    end
  },

  -- # Themes
  'chriskempson/base16-vim',
  'sainnhe/gruvbox-material',
  'NTBBloodbath/doom-one.nvim',
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
