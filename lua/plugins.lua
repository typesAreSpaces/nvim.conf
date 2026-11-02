return {
  -- # IDE Experience
  'henrik/vim-indexed-search',
  {
    'wfxr/minimap.vim',
    cmd = { 'Minimap', 'MinimapClose', 'MinimapToggle', 'MinimapRefresh', 'MinimapUpdateHighlight', 'MinimapRescan' },
  },
  {
    'stevearc/overseer.nvim',
    cmd = { 'OverseerOpen', 'OverseerClose', 'OverseerToggle', 'OverseerRun', 'OverseerShell', 'OverseerTaskAction' },
    config = function()
      require 'config.overseer'
    end
  },
  {
    "folke/zen-mode.nvim", 
    cmd = 'ZenMode',
    config = function()
      require 'config.zenmode'
    end
  },
  {
    "nanozuki/tabby.nvim",
    event = 'TabNew',
    cmd = { 'TabRename', 'Tabby' },
    config = function()
      require 'config.tabby-config'
    end
  },
  {
    "gbprod/yanky.nvim",
    event = 'TextYankPost',
    cmd = 'YankyClearHistory',
    keys = {
      { '<Plug>(YankyPreviousEntry)' },
      { '<Plug>(YankyNextEntry)' },
      { '<Plug>(YankyYank)', mode = { 'n', 'x' } },
      { '<Plug>(YankyPutAfter)', mode = { 'n', 'x' } },
      { '<Plug>(YankyPutBefore)', mode = { 'n', 'x' } },
      { '<Plug>(YankyGPutAfter)', mode = { 'n', 'x' } },
      { '<Plug>(YankyGPutBefore)', mode = { 'n', 'x' } },
    },
    config = function()
      require 'config.yanky'
    end
  },
  {
    'kyazdani42/nvim-tree.lua',
    cmd = {
      'NvimTreeOpen', 'NvimTreeClose', 'NvimTreeToggle', 'NvimTreeFocus',
      'NvimTreeRefresh', 'NvimTreeClipboard', 'NvimTreeFindFile',
      'NvimTreeFindFileToggle', 'NvimTreeResize', 'NvimTreeCollapse',
      'NvimTreeCollapseKeepBuffers', 'NvimTreeHiTest',
    },
    dependencies = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function()
      require 'config.lua-tree'
    end
  },
  -- Language servers are installed externally and configured with vim.lsp.
  {
    'neovim/nvim-lspconfig',
    ft = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'tex', 'plaintex', 'bib', 'python' },
    cmd = { 'LspInfo', 'LspLog', 'LspStart', 'LspStop', 'LspRestart' },
    dependencies = { 'hrsh7th/cmp-nvim-lsp' },
    config = function()
      require 'config.lsp'
    end
  },
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master', -- Legacy configs API; see config/treesitter.lua.
    lazy = false, -- The legacy module system requires startup initialization.
    build = ':TSUpdate',
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
    event = 'InsertEnter',
    dependencies = {
      'SirVer/ultisnips',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
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
      'nvim-telescope/telescope-file-browser.nvim',
    },
    cmd = "Telescope",
    config = function()
      require 'config.telescope'
    end
  },
  {
    'mbbill/undotree',
    cmd = { 'UndotreeToggle', 'UndotreeHide', 'UndotreeShow', 'UndotreeFocus', 'UndotreePersistUndo' },
    event = 'FuncUndefined undotree#*',
  },
  'jeffkreeftmeijer/vim-numbertoggle',
  'preservim/nerdcommenter',
  {
    'puremourning/vimspector',
    -- Keep direct :call vimspector#... usage working alongside commands/maps.
    event = 'FuncUndefined vimspector#*',
    cmd = {
      'VimspectorNewSession', 'VimspectorSwitchToSession', 'VimspectorRenameSession',
      'VimspectorDestroySession', 'VimspectorWatch', 'VimspectorShowOutput',
      'VimspectorToggleLog', 'VimspectorDebugInfo', 'VimspectorEval',
      'VimspectorReset', 'VimspectorBreakpoints', 'VimspectorDisassemble',
      'VimspectorInstall', 'VimspectorUpdate', 'VimspectorAbortInstall',
      'VimspectorLoadSession', 'VimspectorMkSession',
    },
    keys = function()
      local keys = vim.tbl_map(function(name) return { '<Plug>Vimspector' .. name } end, {
        'Continue', 'Launch', 'Stop', 'Restart', 'Pause', 'ToggleBreakpoint',
        'ToggleConditionalBreakpoint', 'AddFunctionBreakpoint', 'StepOver',
        'StepInto', 'StepOut', 'RunToCursor', 'GoToCurrentLine', 'UpFrame',
        'DownFrame', 'JumpToNextBreakpoint', 'JumpToPreviousBreakpoint',
        'JumpToProgramCounter', 'Breakpoints', 'Disassemble',
      })
      keys[#keys + 1] = { '<Plug>VimspectorBalloonEval', mode = { 'n', 'x' } }
      return keys
    end,
  },
  {
    'SirVer/ultisnips',
    event = { 'InsertEnter', 'FuncUndefined UltiSnips#*' },
    cmd = { 'UltiSnipsEdit', 'UltiSnipsAddFiletypes', 'UltiSnipsRemoveFiletypes', 'UltiSnipsListLocations' },
    keys = { { '<C-e>', mode = 'x' } },
    dependencies = {
      "honza/vim-snippets"
    },
    init = function()
      require 'config.ultisnips'
    end
  },
  {
    'lervag/vimtex',
    lazy = false, -- Keep filetype detection and inverse search available.
    config = function()
      require 'config.vimtex'
    end
  },
  'mhinz/neovim-remote',
  'tpope/vim-fugitive',
  {
    'skywind3000/asyncrun.vim',
    cmd = { 'AsyncRun', 'AsyncStop', 'AsyncReset' },
    event = 'FuncUndefined asyncrun#*',
  },
  {
    'folke/which-key.nvim',
    event = "BufWinEnter",
    config = function()
      require 'config.which-key'
    end
  },
  {
    'gelguy/wilder.nvim',
    build = ':UpdateRemotePlugins',
    event = 'CmdlineEnter',
    config = function()
      require 'config.wilder'
    end
  },
  { 'voldikss/vim-mma', ft = 'mma' },

  -- # Neovim apps
  {
    'iamcco/markdown-preview.nvim',
    ft = 'markdown',
    build = function() vim.fn['mkdp#util#install']() end,
  },
  {
    'rhysd/vim-grammarous',
    cmd = { 'GrammarousCheck', 'GrammarousReset' },
    event = 'FuncUndefined grammarous#*',
  },
  { 'sotte/presenting.vim', cmd = { 'StartPresenting', 'PresentingStart' } },
  {
    'stevearc/oil.nvim',
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require 'config.oil'
    end
  },

  -- # Themes
  { 'chriskempson/base16-vim', lazy = true },
  { 'sainnhe/gruvbox-material', lazy = false, priority = 1000 },
  { 'NTBBloodbath/doom-one.nvim', lazy = true },
  {
    'folke/tokyonight.nvim',
    lazy = true,
    branch = 'main'
  },
  { 'shaunsingh/nord.nvim', lazy = true },
  { 'b4skyx/serenade', lazy = true },
  { 'dracula/vim', lazy = true },

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
  {
    'stevearc/dressing.nvim',
    config = function()
      require 'config.dressing'
    end
  },
  'ryanoasis/vim-devicons',
  { 'eandrju/cellular-automaton.nvim', cmd = 'CellularAutomaton' },

  -- # Syntax
  {
    'bohlender/vim-smt2',
    ft = 'smt2',
    config = function()
      require 'config.smt2'
    end
  },
  { 'plasticboy/vim-markdown', ft = 'markdown' },
  { 'coreysharris/Macaulay2.vim', ft = 'Macaulay2' },
}
