require('oil').setup({
  -- Only Oil takes over directory buffers; other explorers remain explicit.
  default_file_explorer = true,
  columns = { 'icon' },
  float = { border = 'rounded' },
  confirmation = { border = 'rounded' },
  progress = { border = 'rounded' },
  keymaps = {
    ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
    ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
    ['<C-t>'] = { 'actions.select', opts = { tab = true } },
    ['<C-c>'] = 'actions.close',
    ['~'] = { 'actions.cd', opts = { scope = 'tab' } },
  },
})
