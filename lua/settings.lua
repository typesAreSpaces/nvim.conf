vim.g.mapleader = " "

vim.cmd([[
augroup custom_term
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
augroup END
]])

vim.cmd([[
highlight! link TermCursor Cursor
highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
]])
