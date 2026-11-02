local function finish(ok, err)
  if not ok then
    vim.api.nvim_err_writeln(err)
    vim.cmd('cquit 1')
  end
  print('First-use checks passed: ' .. (vim.env.NVIM_FIRST_USE or 'insert'))
  vim.cmd('qa!')
end

local function await(predicate, callback)
  local started = vim.uv.hrtime()
  local function poll()
    local ok, err = xpcall(function()
      if predicate() then
        callback()
      elseif (vim.uv.hrtime() - started) / 1e6 > 5000 then
        error('First-use input timed out: ' .. vim.inspect(vim.api.nvim_buf_get_lines(0, 0, -1, false)))
      else
        vim.defer_fn(poll, 10)
      end
    end, debug.traceback)
    if not ok then finish(false, err) end
  end
  vim.schedule(poll)
end

local function run()
  local plugins = require('lazy.core.config').plugins
  local mode = vim.env.NVIM_FIRST_USE or 'insert'
  for _, name in ipairs({ 'ultisnips', 'nvim-cmp', 'wilder.nvim', 'overseer.nvim', 'tabby.nvim', 'yanky.nvim' }) do
    assert(not plugins[name]._.loaded, name .. ' loaded before first use')
  end
  -- Tests use private registers, never the user's system clipboard.
  vim.o.clipboard = ''
  vim.cmd('enew')
  if mode == 'insert' then
    vim.bo.filetype = 'tex'
    -- Use the native input queue, allowing InsertEnter/RPC initialization to
    -- finish before typing. feedkeys inside :luafile runs as a nested macro.
    vim.api.nvim_input('i')
    await(function()
      return package.loaded['config.cmp-no-cmdline'] and vim.fn.mode() == 'i'
    end, function()
      assert(plugins['nvim-cmp']._.loaded and plugins.ultisnips._.loaded)
      vim.api.nvim_input(';NN')
      await(function() return vim.api.nvim_get_current_line():find([[\mathbb{N}]], 1, true) end, function()
        vim.api.nvim_input(' ;ZZ')
        await(function() return vim.api.nvim_get_current_line():find([[\mathbb{Z}]], 1, true) end,
          function() finish(true) end)
      end)
    end)
    return true
  elseif mode == 'command' then
    local keys = vim.api.nvim_replace_termcodes(':let g:first_command_ok = 1<CR>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'xt', false)
    assert(plugins['wilder.nvim']._.loaded)
    assert(vim.g.first_command_ok == 1, 'First command was lost')
    assert(not plugins.ultisnips._.loaded, 'Command completion loaded the snippet engine')
  elseif mode == 'delete' or mode == 'yank' then
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'first history entry', 'second line' })
    if mode == 'delete' then
      vim.cmd('normal! dd')
    else
      vim.cmd('normal yy')
    end
    assert(plugins['yanky.nvim']._.loaded)
    local entry = require('yanky').history.first()
    assert(entry and entry.regcontents == 'first history entry\n', vim.inspect(entry))
  elseif mode == 'paste' then
    vim.fn.setreg('a', 'first paste', 'v')
    vim.cmd('normal "ap')
    assert(plugins['yanky.nvim']._.loaded)
    assert(vim.api.nvim_get_current_line() == 'first paste')
  elseif mode == 'tabs' or mode == 'tabnew' then
    if mode == 'tabnew' then
      vim.cmd('tabnew')
      assert(plugins['tabby.nvim']._.loaded, 'Opening a second tab did not initialize Tabby')
    end
    vim.cmd('TabRename Performance')
    assert(plugins['tabby.nvim']._.loaded)
    local names = require('tabby.feature.tab_name')
    assert(names.get_raw(0) == 'Performance')
    vim.cmd('TabRename')
    assert(names.get_raw(0) == '', 'TabRename reset stopped working')
    vim.cmd('tabnew')
    assert(vim.o.tabline:find('TabbyRenderTabline', 1, true))
    vim.cmd('TabRename Second tab')
    assert(names.get_raw(0) == 'Second tab')
  else
    error('Unknown first-use test mode: ' .. mode)
  end
end

-- Start after VimEnter so the startup dashboard/filetype detection cannot
-- replace the test buffer while its asynchronous input checks are running.
vim.schedule(function()
  local ok, pending = xpcall(run, debug.traceback)
  if not ok then
    finish(false, pending)
  elseif not pending then
    finish(true)
  end
end)
