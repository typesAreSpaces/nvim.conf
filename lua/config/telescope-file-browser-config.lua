local actions = require('telescope.actions')
local action_state = require("telescope.actions.state")

return {
  theme = "ivy",
  respect_gitignore = false,
  hidden = { file_browser = false, folder_browser = false },
  prompt_path = true,
  -- Oil owns directory buffers; this picker is opened explicitly.
  hijack_netrw = false,
  mappings = {
    ["i"] = {
      -- your custom insert mode mappings
      ["<tab>"] = actions.select_default,
      ["<CR>"] = actions.select_default,
      ["<C-c>"] = function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_put({selection.ordinal}, "c", true, true)
      end,
      ["<C-s>"] = actions.send_selected_to_qflist,
      ["<C-d>"] = actions.add_selected_to_qflist,
      ["<C-m>"] = actions.add_selection,
      ["<C-t>"] = actions.select_tab,
      ["<C-g>"] = actions.close
    },
    ["n"] = {
      -- your custom normal mode mappings
    },
  },
}

