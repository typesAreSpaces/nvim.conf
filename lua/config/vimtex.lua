vim.cmd('filetype plugin indent on')

vim.g.Tex_DefaultTargetFormat = 'pdf'
vim.g.vimtex_view_enabled = 1
vim.g.vimtex_view_automatic = 1
vim.g.vimtex_view_method = 'sioyek'
if vim.fn.executable('sioyek') == 0
    and vim.fn.executable('/Applications/sioyek.app/Contents/MacOS/sioyek') == 1 then
  vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
end
vim.g.vimtex_view_forward_search_on_start = 1
vim.g.vimtex_compiler_progname = 'nvr'
vim.g.tex_flavor = "latex"
vim.g.active_refresh = 0

function SaveSession()
  vim.cmd('mksession! session')
  vim.cmd('echon "Session saved"')
end

function ParentFile()
  local file_name = vim.fn.expand('%:t')
  vim.cmd(string.format("silent grep -w \"input{%s}\" *.tex", string.sub(file_name, 0, -5)))
end
