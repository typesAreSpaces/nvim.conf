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

local function remove_list_item()
  local winid = vim.api.nvim_get_current_win()
  local info = vim.fn.getwininfo(winid)[1]
  if info.quickfix ~= 1 then return end
  local is_loclist = info.loclist == 1
  local list = is_loclist and vim.fn.getloclist(0, { items = 0, idx = 0 })
    or vim.fn.getqflist({ items = 0, idx = 0 })
  local row = vim.fn.line('.')
  if #list.items == 0 then return end
  table.remove(list.items, row)
  local idx = list.idx - (row < list.idx and 1 or 0)
  local update = { items = list.items, idx = math.min(idx, #list.items) }
  if is_loclist then
    vim.fn.setloclist(0, {}, 'r', update)
  else
    vim.fn.setqflist({}, 'r', update)
  end
  vim.api.nvim_win_set_cursor(winid, { math.max(1, math.min(row, #list.items)), 0 })
end

vim.api.nvim_create_user_command('RemoveQFItem', remove_list_item, {})
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('custom_quickfix', { clear = true }),
  pattern = 'qf',
  callback = function(args)
    vim.keymap.set('n', 'dd', '<cmd>RemoveQFItem<CR>', { buffer = args.buf, silent = true })
  end,
})

vim.api.nvim_create_user_command("Make", function(params)
  -- vim.o resolves global-local options when the local value is empty.
  local errorformat = vim.o.errorformat
  local cwd = vim.fn.getcwd()
  -- Insert args at the '$*' in the makeprg
  local cmd, num_subs = vim.o.makeprg:gsub("%$%*", function() return params.args end)
  cmd = "time " .. cmd
  if num_subs == 0 then
    cmd = cmd .. " " .. params.args
  end
  local task = require("overseer").new_task({
    cmd = vim.fn.expandcmd(cmd),
    cwd = cwd,
    components = {
      { "on_output_quickfix", errorformat = errorformat, open = not params.bang, open_height = 8 },
      "default",
    },
  })
  task:start()
end, {
desc = "Run your makeprg as an Overseer task",
nargs = "*",
bang = true,
})
