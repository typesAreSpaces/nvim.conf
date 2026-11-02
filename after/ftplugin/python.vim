setlocal tabstop=4 expandtab shiftwidth=2 softtabstop=2 signcolumn=yes textwidth=100
let b:undo_ftplugin = get(b:, 'undo_ftplugin', '')
      \ . '|setlocal tabstop< expandtab< shiftwidth< softtabstop< signcolumn< textwidth<'
