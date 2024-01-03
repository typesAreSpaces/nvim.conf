local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        ["<C-g>"] = actions.close,
        ["<C-s>"] = actions.send_selected_to_qflist,
        ["<C-d>"] = actions.add_selected_to_qflist,
        ["<esc>"] = actions.close
      }
    },
    layout_strategy = 'flex',
    scroll_stategy = 'cycle',
  },
  pickers = {
    find_files = {
      theme = "dropdown",
      previewer = false,
    },
    file_browser = {
      theme = "dropdown",
    },
    live_grep = {
      theme = "dropdown",
    },
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
    commads = {
      theme = "dropdown",
    },
  },
  extensions = {
  }
}
