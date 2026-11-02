local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key",
        ["<C-g>"] = actions.close,
        ["<C-s>"] = actions.send_selected_to_qflist,
        ["<C-d>"] = actions.add_selected_to_qflist,
        ["<esc>"] = actions.close,
        ["<C-k>"] = require('telescope.actions').delete_buffer
      }
    },
    layout_strategy = 'flex',
    scroll_strategy = 'cycle',
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
    commands = {
      theme = "dropdown",
    },
  },
  extensions = {
    file_browser = require('config.telescope-file-browser-config'),
  }
}

require('telescope-tabs').setup({})
for _, extension in ipairs({ 'file_browser', 'telescope-tabs', 'ultisnips' }) do
  require('telescope').load_extension(extension)
end
