require('nvim-tree').setup({
  -- Oil handles directory buffers. Keep NvimTree available through its commands.
  disable_netrw = false,
  hijack_netrw = false,
  hijack_directories = { enable = false, auto_open = false },
  diagnostics = { debounce_delay = 50 },
  renderer = {
    highlight_git = false,
    icons = { padding = ' ', glyphs = { bookmark = '' } },
  },
  update_focused_file = { update_root = false },
})
