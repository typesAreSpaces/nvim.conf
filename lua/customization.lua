vim.o.clipboard = 'unnamedplus'
vim.o.encoding = 'UTF-8'
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 0
vim.o.incsearch = true
vim.o.smarttab = true
vim.o.backup = false
vim.o.termguicolors = true

local buffer_defaults = {
  tabstop = 2,
  softtabstop = 2,
  shiftwidth = 2,
  undofile = true,
  swapfile = false,
  smartindent = true,
  expandtab = true,
}
local window_defaults = {
  relativenumber = true,
  number = true,
  concealcursor = 'nc',
  conceallevel = 0,
}

-- Reloads update defaults for future buffers/windows, preserving existing ones.
for name, value in pairs(buffer_defaults) do vim.opt_global[name] = value end
for name, value in pairs(window_defaults) do vim.opt_global[name] = value end

--opt('guifont', "InputMono\ NF:h30")

vim.g.base16colorspace = 256
vim.g.gruvbox_material_background = 'hard'
vim.cmd([[color gruvbox-material]])
--vim.cmd([[color doom-one]])

vim.opt.autochdir = false

vim.g.vim_markdown_conceal = 0
vim.g.vim_markdown_conceal_code_blocks = 0
--vim.opt.textwidth = 80

return {
  -- Only initialization applies defaults to the initial buffer and window.
  apply_local_defaults = function()
    for name, value in pairs(buffer_defaults) do vim.bo[name] = value end
    for name, value in pairs(window_defaults) do vim.wo[name] = value end
  end,
}
