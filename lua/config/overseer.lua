require('overseer').setup({
  task_list = {
    direction = 'left',
    max_height = { 20, 0.1 },
    separator = '────────────────────────────────────────',
    keymaps = {
      ['<C-p>'] = 'keymap.scroll_output_up',
      ['<C-n>'] = 'keymap.scroll_output_down',
      ['<C-g>'] = { '<cmd>close<CR>', desc = 'Close task list' },
    },
  },
  form = { border = 'rounded', win_opts = { winblend = 10 } },
  task_win = { border = 'rounded', win_opts = { winblend = 10 } },
  component_aliases = {
    default = {
      -- The default task renderer already shows duration and output.
      'on_exit_set_status',
      'on_complete_notify',
      'on_complete_dispose',
    },
    default_vscode = {
      'default', 'on_result_diagnostics', 'on_result_diagnostics_quickfix',
    },
  },
})
