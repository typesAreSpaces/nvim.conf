local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}
require('tabby.tabline').set(function(line)
  return {
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('', hl, theme.fill),
        tab.is_current() and '' or '󰆣',
        tab.number(),
        tab.name(),
        tab.close_btn(''),
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    --line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      --return {
        --line.sep('', theme.win, theme.fill),
        --win.is_current() and '' or '',
        --win.buf_name(),
        --line.sep('', theme.win, theme.fill),
        --hl = theme.win,
        --margin = ' ',
      --}
    --end),
    hl = theme.fill,
  }
end)

-- Install after Tabby initializes: its own TabRename command requires an
-- argument, while this command also supports resetting the current tab name.
vim.api.nvim_create_user_command('TabRename', function(opts)
  require('tabby.feature.tab_name').set(0, vim.trim(opts.args))
end, {
  nargs = '?',
  desc = 'Rename the current tab, or reset its name when no argument is given',
})
