vim.cmd([[syntax on]])
vim.o.clipboard = 'unnamedplus'
vim.o.encoding = 'UTF-8'
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 0
vim.o.incsearch = true
vim.o.smarttab = true
vim.o.backup = false
vim.o.termguicolors = true

vim.o.tabstop = 2
vim.bo.tabstop = 2
vim.o.softtabstop = 2
vim.bo.softtabstop = 2
vim.o.shiftwidth = 2
vim.bo.shiftwidth = 2
vim.o.undofile = true
vim.bo.undofile = true
vim.o.swapfile = false
vim.bo.swapfile = false
vim.o.smartindent = true
vim.bo.smartindent = true
vim.o.expandtab = true
vim.bo.expandtab = true

vim.o.relativenumber = true
vim.wo.relativenumber = true
vim.o.rnu = true
vim.wo.rnu = true
vim.o.number = true
vim.wo.number = true

--opt('guifont', "InputMono\ NF:h30")

base16colorspace = 256
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_invert_selection = '0'
vim.cmd([[color gruvbox-material]])

vim.opt.conceallevel = 2
vim.opt.concealcursor = 'nc'
