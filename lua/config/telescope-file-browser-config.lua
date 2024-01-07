local actions = require('telescope.actions')

-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
require("telescope").setup {
  extensions = {
    file_browser = {
      theme = "ivy",
      respect_gitignore = false,
      hidden = { file_browser = false, folder_browser = false },
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
          ["<tab>"] = actions.select_default,
          ["<C-s>"] = actions.send_selected_to_qflist,
          ["<C-d>"] = actions.add_selected_to_qflist,
          ["<C-t>"] = actions.select_tab
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"
