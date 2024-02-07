local wk = require("which-key")
wk.setup {
  plugins = {
    marks = false,
    registers = false,
    spelling = {enabled = false, suggestions = 20},
    presets = {operators = false, motions = false, text_objects = false, windows = false, nav = false, z = false, g = false}
  }
}

local mappings = {
  b = {
    name = "Bookmarks",
    j = {"<cmd>BookmarkNext<CR>", "Go to Next Bookmark"},
    k = {"<cmd>BookmarkPrev<CR>", "Go to Previous Bookmark"},
  },
  
  c = {
    name = "NERDCommenter",
  },

  d = {"<cmd>:Oil<CR>", "Oil"},

  g = {
    name = "Fugitive Git",
    s = {"<cmd>G<CR>", "Git Status"},
    j = {"<cmd>diffget //3<cr>", "Git master"},
    f = {"<cmd>diffget //2<cr>", "Git HEAD"},
  },

  j = {
    name = "Jumps",
    o = {"<C-o>", "Jump to Previous Position"},
    i = {"<C-i>", "Jump to Next Position"}
  },
  
  k = {
    name = "Keyboard Settings",
    c = {"<cmd>lua change_kbd()<CR>", "Toggle Caps Lock to ESC <-> Ctrl"}
  },

  l = {
    name = "LSP",
    i = {
      c = {":LspInfo<cr>", "Connected Language Servers"},
      m = {"<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation"}
    },
    c = {":LspInfo<cr>", "Connected Language Servers"},
    k = {"<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help"},
    K = {'<cmd>lua vim.lsp.buf.hover()<CR>', "Hover Command"},
    w = {'<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>', "Add Workspace Folder"},
    W = {'<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>', "Remove Workspace Folder"},
    l = {'<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>', "List Workspace Folders"},
    t = {'<cmd>lua vim.lsp.buf.type_definition()<cr>', "Type Definition"},
    d = {'<cmd>lua vim.lsp.buf.definition()<cr>', "Go To Definition"},
    D = {'<cmd>lua vim.lsp.buf.declaration()<cr>', "Go To Declaration"},
    r = {'<cmd>lua vim.lsp.buf.references()<cr>', "References"},
    R = {'<cmd>lua vim.lsp.buf.rename()<CR>', "Rename"},
    a = {'<cmd>lua vim.lsp.buf.code_action()<CR>', "Code Action"},
    e = {'<cmd>lua vim.diagnostic.show_line_diagnostics()<CR>', "Show Line Diagnostics"},
    n = {'<cmd>lua vim.diagnostic.goto_prev()<CR>', "Go To Next Diagnostic"},
    N = {'<cmd>lua vim.diagnostic.goto_next()<CR>', "Go To Previous Diagnostic"},
    q = {"<cmd>lua vim.diagnostic.setloclist()<CR>", "Diagnostic Set LocList"},
    f = {'<cmd>lua vim.lsp.buf.formatting()<CR>', "Formatting"},
  },

  m = {"<cmd>:Make<CR>", "Async :Make"},

  n = {
    name = "NvimTree",
    t = {"<cmd>:NvimTreeToggle<CR>", "Toggle"},
  },

  p = {"<cmd>:Lazy<CR>", "Plugins"},

  r = {
    name = "Overseer",
    t = {"<cmd>OverseerToggle<CR>", "Toggle"},
    r = {"<cmd>OverseerRun<CR>", "Run"},
  },

  s = {
    name = "Source Configs",
    u = {"<cmd>call UltiSnips#RefreshSnippets()<CR><cmd>echon 'Snippets refreshed'<CR>", "Source UltinSnippets Config"},
    c = {"<cmd>source $HOME/.config/nvim/init.lua<CR><cmd>echon 'Config sourced'<CR>", "Source nvim Config"},
  },

  t = {
    name = "Telescope",
    f = {
      name = "Files Utility",
      b = {"<cmd>Telescope file_browser prompt_prefix=🔍<CR>", "File Browser"},
      f = {"<cmd>Telescope find_files prompt_prefix=🔍<CR>", "Find Files"},
    },
    g = {"<cmd>Telescope live_grep<CR>", "Live Grep"},
    b = {'<cmd>Telescope buffers <CR>', "Buffers"},
    h = {'<cmd>Telescope help_tags<CR>', "Help Tags"},
    u = {'<cmd>Telescope ultisnips<CR>', "UltinSnippets"},
    t = {'<cmd>Telescope telescope-tabs list_tabs<CR>', "Tabs"},
  },

  v = {
    name = "VimTex",
    p = { "<cmd>lua ParentFile()<CR><CR>", "Go to Parent File"},
  },

  o = {
    name = "Org Mode"
  }, 

  w = {
    name = "Windows",
    j = {"<C-w><C-j>", "Move to the window on the left"},
    k = {"<C-w><C-k>", "Move to the window above"},
    l = {"<C-w><C-l>", "Move to the window below"},
    h = {"<C-w><C-h>", "Move to the window on the left"},
    y = {"<cmd>exe 'vertical resize +5'<CR>", "Resize vertical line +5"},
    u = {"<cmd>exe 'resize -5' <CR>", "Resize horizontal line -5"},
    i = {"<cmd>exe 'resize +5' <CR>", "Resize horizontal line +5"},
    o = {"<cmd>exe 'vertical resize -5'<CR>", "Resize vertical line -5"},
  }
}

local opts = {prefix = '<leader>'}
wk.register(mappings, opts)
