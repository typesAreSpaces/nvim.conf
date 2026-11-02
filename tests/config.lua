local root = vim.fn.getcwd()
vim.opt.rtp:prepend(root)
vim.opt.rtp:append(root .. '/after')
local function equal(actual, expected)
  assert(vim.deep_equal(actual, expected), vim.inspect({ actual = actual, expected = expected }))
end

for _, file in ipairs(vim.fn.glob(root .. '/**/*.lua', false, true)) do
  assert(loadfile(file))
end

-- Python overrides run after the standard runtime and do not change defaults.
vim.o.shiftwidth, vim.o.softtabstop, vim.o.tabstop, vim.o.textwidth = 2, 2, 2, 0
vim.cmd('filetype plugin indent on')
vim.cmd('edit /private/tmp/nvim-regression.py')
equal({ vim.bo.shiftwidth, vim.bo.softtabstop, vim.bo.tabstop, vim.bo.textwidth }, { 2, 2, 4, 100 })
equal({ vim.go.tabstop, vim.go.textwidth }, { 2, 0 })
vim.bo.filetype = 'text'
equal(vim.bo.textwidth, 0)
vim.cmd('enew')
equal({ vim.bo.tabstop, vim.bo.textwidth }, { 2, 0 })

require('settings')
local function entries()
  return {
    { filename = 'a', lnum = 1, text = 'a' },
    { filename = 'b', lnum = 1, text = 'b' },
    { filename = 'c', lnum = 1, text = 'c' },
  }
end
vim.fn.setqflist({}, ' ', { items = entries(), title = 'Keep title', context = { keep = true } })
vim.cmd('copen')
vim.api.nvim_win_set_cursor(0, { 2, 0 })
vim.cmd('RemoveQFItem')
equal(vim.api.nvim_win_get_cursor(0)[1], 2)
equal(vim.tbl_map(function(item) return item.text end, vim.fn.getqflist()), { 'a', 'c' })
equal(vim.fn.getqflist({ title = 0, context = 0 }), { title = 'Keep title', context = { keep = true } })
vim.cmd('RemoveQFItem')
equal(vim.api.nvim_win_get_cursor(0)[1], 1)
vim.cmd('RemoveQFItem')
vim.cmd('RemoveQFItem') -- empty lists are safe.
equal(vim.fn.getqflist(), {})
vim.cmd('cclose')

vim.fn.setqflist(entries(), 'r')
vim.fn.setloclist(0, entries(), 'r')
vim.cmd('lopen')
vim.api.nvim_win_set_cursor(0, { 2, 0 })
vim.cmd('RemoveQFItem')
equal(#vim.fn.getloclist(0), 2)
equal(#vim.fn.getqflist(), 3)
equal(vim.api.nvim_win_get_cursor(0)[1], 2)
vim.cmd('lclose')

-- Inspect task construction without spawning a shell or compiler.
local task_opts
package.loaded.overseer = { new_task = function(opts)
  task_opts = opts
  return { start = function() end }
end }
vim.api.nvim_buf_set_name(0, '/private/tmp/nvim-regression.lua')
vim.o.makeprg = 'echo $*'
vim.bo.errorformat = 'DIAG %f@%l@%m'
vim.cmd('Make! value%1')
equal(task_opts.cmd, vim.fn.expandcmd('time echo value%1'))
equal(task_opts.components[1].open, false)
equal(task_opts.components[1].errorformat, 'DIAG %f@%l@%m')
vim.o.makeprg = 'echo'
vim.cmd('Make value')
equal(task_opts.cmd, 'time echo value')
-- Empty local values inherit the global build options.
vim.bo.makeprg, vim.bo.errorformat = '', ''
vim.cmd('Make value')
equal(task_opts.cmd, 'time echo value')
equal(task_opts.components[1].errorformat, vim.go.errorformat)

require('commands')
for _ = 1, 3 do vim.cmd('ReloadConfig settings') end
equal(#vim.api.nvim_get_autocmds({ group = 'custom_quickfix', event = 'FileType' }), 1)
assert(not pcall(vim.cmd, 'ReloadConfig plugins'))

-- Size limits apply to unsaved buffers and don't require filesystem queries.
local performance = require('config.performance')
local scratch = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(scratch, 0, -1, false, { string.rep('x', 1024 * 1024 + 1) })
assert(performance.is_large(scratch))
local lines = {}
for _ = 1, 20001 do lines[#lines + 1] = 'x' end
vim.api.nvim_buf_set_lines(scratch, 0, -1, false, lines)
assert(performance.is_large(scratch))
vim.api.nvim_buf_set_lines(scratch, 0, -1, false, { 'small buffer' })
assert(not performance.is_large(scratch))
vim.api.nvim_buf_delete(scratch, { force = true })
print('Configuration regression checks passed')
vim.cmd('qa!')
