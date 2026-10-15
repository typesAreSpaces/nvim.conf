vim.api.nvim_create_user_command("TabRename", function(opts)
  -- Tabby stores custom names itself and redraws the tabline when they change.
  require('tabby.feature.tab_name').set(0, vim.trim(opts.args))
end, {
  nargs = '?',
  desc = 'Rename the current tab, or reset its name when no argument is given',
})

vim.api.nvim_create_user_command("RuffCheck", function()
  vim.cmd("wall") -- Save files before checking
  vim.opt_local.makeprg = "uv run ruff check --output-format concise --quiet ."
  vim.opt_local.errorformat = "%f:%l:%c: %m"
  vim.cmd("make!")
  vim.cmd("copen")
end, {})
