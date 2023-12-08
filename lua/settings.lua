vim.cmd([[
augroup custom_term
autocmd!
autocmd TermOpen * setlocal nonumber norelativenumber bufhidden=hide
augroup END
]])

vim.cmd([[
highlight! link TermCursor Cursor
highlight! TermCursorNC guibg=red guifg=white ctermbg=1 ctermfg=15
highlight! YankyPut guibg=None guifg=None ctermbg=1 ctermfg=15
highlight! YankyYanked guibg=None guifg=None ctermbg=1 ctermfg=15
]])

vim.cmd([[
augroup move_lcd
autocmd!
autocmd BufEnter * silent! lcd %:p:h
augroup END
]])
