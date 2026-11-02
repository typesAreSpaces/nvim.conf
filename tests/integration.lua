local function equal(actual, expected)
  assert(vim.deep_equal(actual, expected), vim.inspect({ actual = actual, expected = expected }))
end

local function run()
  -- Keep test buffers from starting language servers.
  vim.lsp.enable({ 'texlab', 'clangd', 'pyright' }, false)
  local plugins = require('lazy.core.config').plugins
  for _, name in ipairs({ 'nvim-tree.lua', 'vimspector', 'minimap.vim', 'tokyonight.nvim', 'nord.nvim',
    'ultisnips', 'nvim-cmp', 'wilder.nvim', 'overseer.nvim', 'yanky.nvim', 'nvim-lspconfig', 'tabby.nvim' }) do
    assert(not plugins[name]._.loaded, name .. ' loaded eagerly')
  end
  assert(not plugins['telescope.nvim']._.loaded)

  local directory = vim.fn.tempname()
  vim.fn.mkdir(directory, 'p')
  directory = vim.uv.fs_realpath(directory)
  local function edit(name)
    vim.cmd('edit ' .. vim.fn.fnameescape(directory .. '/' .. name))
  end
  local function local_options()
    return {
      vim.bo.expandtab, vim.bo.tabstop, vim.bo.softtabstop, vim.bo.shiftwidth,
      vim.bo.textwidth, vim.wo.number, vim.wo.relativenumber,
      vim.wo.conceallevel, vim.wo.concealcursor,
    }
  end
  edit('Makefile')
  equal(vim.bo.filetype, 'make')
  equal(vim.bo.expandtab, false)
  vim.wo.number, vim.wo.relativenumber, vim.wo.conceallevel = false, false, 3
  local make_options = local_options()
  vim.cmd('ReloadConfig')
  equal(local_options(), make_options)
  edit('source.py')
  equal(vim.bo.tabstop, 4)
  assert(plugins['nvim-lspconfig']._.loaded, 'Python did not load the LSP configuration')
  assert(vim.lsp.config.pyright.capabilities.textDocument.completion.completionItem.snippetSupport)
  assert(not plugins['nvim-cmp']._.loaded and not plugins.ultisnips._.loaded,
    'LSP capabilities started the completion/snippet engine')
  local python_options = local_options()
  for _ = 1, 2 do
    vim.cmd('ReloadConfig')
    equal(local_options(), python_options)
  end
  equal(vim.go.tabstop, 2)
  equal(#vim.api.nvim_get_autocmds({ group = 'custom_quickfix', event = 'FileType' }), 1)

  -- Construct and run a real Overseer task with a format the defaults can't parse.
  local notifications = {}
  local notify = vim.notify
  vim.notify = function(message, level, opts)
    notifications[#notifications + 1] = tostring(message)
    return notify(message, level, opts)
  end
  local overseer = require('overseer')
  local new_task = overseer.new_task
  local task
  overseer.new_task = function(opts)
    task = new_task(opts)
    return task
  end
  vim.bo.makeprg = [[echo 'DIAG sample.py@7@failure']]
  vim.bo.errorformat = 'DIAG %f@%l@%m'
  vim.cmd('Make!')
  overseer.new_task = new_task
  equal(task:get_component('on_output_quickfix').params.errorformat, 'DIAG %f@%l@%m')
  assert(not task:get_component('display_duration'))
  assert(not task:get_component('on_output_summarize'))
  vim.cmd('enew')
  vim.bo.errorformat = 'OTHER %f@%l@%m'
  assert(vim.wait(5000, function() return task:is_complete() end), 'Build task timed out')
  equal(task.status, 'SUCCESS')
  local diagnostics = vim.tbl_filter(function(item) return item.valid == 1 end, vim.fn.getqflist())
  equal(#diagnostics, 1)
  equal(diagnostics[1].lnum, 7)
  equal(vim.api.nvim_buf_get_name(diagnostics[1].bufnr), directory .. '/sample.py')
  -- The supported renderer still supplies duration and output summaries.
  assert(#require('overseer.config').task_list.render(task) > 1)
  task:dispose(true)

  -- Ruff uses the real task constructor but doesn't launch uv or access a project.
  local original = { vim.bo.makeprg, vim.bo.errorformat, vim.go.makeprg, vim.go.errorformat }
  overseer.new_task = function(opts)
    task = new_task(opts)
    task.start = function() end
    return task
  end
  vim.cmd('RuffCheck')
  equal(task.cmd, { 'uv', 'run', 'ruff', 'check', '--output-format', 'concise', '--quiet', '.' })
  equal(task:get_component('on_output_quickfix').params.errorformat, '%f:%l:%c: %m')
  equal({ vim.bo.makeprg, vim.bo.errorformat, vim.go.makeprg, vim.go.errorformat }, original)
  task:dispose(true)
  overseer.new_task = function() error('test task creation failure') end
  assert(not pcall(vim.cmd, 'RuffCheck'))
  equal({ vim.bo.makeprg, vim.bo.errorformat, vim.go.makeprg, vim.go.errorformat }, original)
  overseer.new_task = new_task
  vim.notify = notify
  for _, message in ipairs(notifications) do
    assert(not message:find('deprecated'), message)
  end

  -- Exercise the actual cmp mapping with controlled menu state.
  local cmp = require('cmp')
  local visible, complete, select_next = cmp.visible, cmp.complete, cmp.select_next_item
  local requested, selected = 0, 0
  cmp.visible = function() return false end
  cmp.complete = function() requested = requested + 1 end
  cmp.select_next_item = function() selected = selected + 1 end
  local control_space = cmp.get_config().mapping['<C-Space>'].i
  control_space(function() error('Unexpected fallback') end)
  equal(requested, 1)
  cmp.visible = function() return true end
  control_space(function() error('Unexpected fallback') end)
  equal(selected, 1)
  cmp.visible, cmp.complete, cmp.select_next_item = visible, complete, select_next

  -- Large buffers skip both parser attachment and word indexing; small files
  -- retain highlighting and completion after switching away from a large file.
  vim.fn.writefile({ '--' .. string.rep('x', 1024 * 1024 + 1) }, directory .. '/large.lua')
  edit('large.lua')
  local performance = require('config.performance')
  local large = vim.api.nvim_get_current_buf()
  assert(performance.is_large(large))
  assert(not vim.treesitter.highlighter.active[large], 'Large file attached a highlighter')
  equal(vim.bo.syntax, 'OFF')
  assert(not cmp.get_config().enabled())
  vim.cmd('ReloadConfig')
  equal(vim.bo.syntax, 'OFF')
  assert(not vim.treesitter.highlighter.active[large], 'Reload re-enabled large-file highlighting')
  local buffer_source
  for _, source in ipairs(cmp.get_config().sources) do
    if source.name == 'buffer' then buffer_source = source end
  end
  equal(buffer_source.option.get_bufnrs(), {})
  vim.fn.writefile({ 'local small = true', 'return small' }, directory .. '/small.lua')
  edit('small.lua')
  local small = vim.api.nvim_get_current_buf()
  assert(not performance.is_large(small))
  assert(vim.treesitter.highlighter.active[small], 'Small file lost highlighting')
  assert(cmp.get_config().enabled())
  equal(buffer_source.option.get_bufnrs(), { small })
  -- Buffers that grow past the limit also release existing parser keymaps.
  vim.api.nvim_buf_set_lines(small, 0, -1, false, { '--' .. string.rep('x', 1024 * 1024 + 1) })
  vim.api.nvim_exec_autocmds('BufWritePost', { buffer = small, modeline = false })
  assert(not vim.treesitter.highlighter.active[small])
  equal(vim.fn.maparg('ti', 'n'), '')
  vim.cmd('enew!')

  -- Optional features load through their public entry points.
  local tree = require('nvim-tree')
  assert(plugins['nvim-tree.lua']._.loaded, 'NvimTree module did not trigger loading')
  -- File watching is outside the scope of these integration checks.
  local tree_options = vim.deepcopy(require('nvim-tree.config').u)
  tree_options.filesystem_watchers = { enable = false }
  tree.setup(tree_options)
  vim.cmd('NvimTreeOpen ' .. vim.fn.fnameescape(directory))
  vim.cmd('NvimTreeClose')
  assert(not plugins.vimspector._.loaded)
  vim.fn['vimspector#CompleteSessionName']('', '', 0)
  assert(plugins.vimspector._.loaded, 'Direct Vimspector function did not trigger loading')
  if vim.fn.executable('code-minimap') == 1 then
    vim.cmd('MinimapClose')
    assert(plugins['minimap.vim']._.loaded)
  end
  vim.cmd.colorscheme('tokyonight')
  assert(plugins['tokyonight.nvim']._.loaded)
  vim.cmd.colorscheme('gruvbox-material')
  require('lazy').load({ plugins = { 'telescope.nvim' } })
  for _, extension in ipairs({ 'file_browser', 'telescope-tabs', 'ultisnips' }) do
    assert(require('telescope').extensions[extension])
  end
  vim.cmd('edit ' .. vim.fn.fnameescape(directory))
  assert(vim.wait(1000, function() return vim.bo.filetype == 'oil' end), 'Oil did not open the directory')
  equal(require('nvim-tree.config').g.hijack_netrw, false)
  require('config.smt2')
  equal(vim.g.smt2_solver_version_switch, '-version')
  for _, case in ipairs({
    { 'example.smt2', 'smt2', 'vim-smt2' },
    { 'example.wl', 'mma', 'vim-mma' },
    { 'example.m2', 'Macaulay2', 'Macaulay2.vim' },
    { 'example.md', 'markdown', 'vim-markdown' },
  }) do
    edit(case[1])
    equal(vim.bo.filetype, case[2])
    assert(plugins[case[3]]._.loaded, case[3] .. ' did not load for its filetype')
  end
  print('Integration checks passed (parser installation disabled)')
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd('cquit 1')
end
vim.cmd('qa!')
