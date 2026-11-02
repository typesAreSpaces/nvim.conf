vim.api.nvim_create_user_command("RuffCheck", function()
  vim.cmd("wall") -- Save files before checking
  local cwd = vim.fn.getcwd()
  require('overseer').new_task({
    name = 'Ruff check',
    cmd = { 'uv', 'run', 'ruff', 'check', '--output-format', 'concise', '--quiet', '.' },
    cwd = cwd,
    components = {
      { 'on_output_quickfix', errorformat = '%f:%l:%c: %m', open = true, open_height = 8 },
      'default',
    },
  }):start()
end, {})

local reloadable = { 'customization', 'settings', 'mappings', 'commands' }
vim.api.nvim_create_user_command('ReloadConfig', function(opts)
  local modules = opts.args == '' and reloadable or { opts.args }
  for _, name in ipairs(modules) do
    if not vim.tbl_contains(reloadable, name) then
      error('Choose one of: ' .. table.concat(reloadable, ', '))
    end
    package.loaded[name] = nil
    require(name)
  end
  vim.notify('Reloaded ' .. table.concat(modules, ', ') .. '. Restart Neovim for plugin changes.')
end, {
  nargs = '?',
  desc = 'Reload core settings, or one core module; plugin changes require restart',
  complete = function() return reloadable end,
})
